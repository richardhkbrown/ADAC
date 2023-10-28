`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2023 04:03:19 PM
// Design Name: 
// Module Name: ModDa2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ModDa2
#(parameter SIO_RATE = 1000000, parameter CLK_RATE = 100000000) (
    input clk,
    output [3:0] do,
    input [11:0] dataA,
    input [11:0] dataB,
    input req,
    output reg ack = 0
    );

    reg sync = 0;    
    assign rdy = ~sync;

    // Create 1 cycle counter
    localparam real PERIOD = CLK_RATE/SIO_RATE;
    localparam integer BITS_NEEDED = $clog2($rtoi(PERIOD)+1);
    localparam [(BITS_NEEDED-1):0] RESET_COUNT = $rtoi(PERIOD);
    localparam [(BITS_NEEDED-1):0] HALF_COUNT = $rtoi(0.5*PERIOD);
    reg [(BITS_NEEDED-1):0] counter = 0;
    reg sclk = 0;
    
    // State machines
    localparam PD = 2'b00;
    reg [($clog2(17+1)):0] state = 0; // 17 is max state
    assign index = state - 4;
    reg dina = 0;
    reg dinb = 0;
    assign do = {sclk,dinb,dina,~sync};
    always @ ( posedge(clk) ) begin
    
        // Counter
        if ( counter<RESET_COUNT ) begin
            counter <= counter+1;
        end else begin
            counter <= 0;
        end
        
        sclk <= counter<=HALF_COUNT;

        // Parallel to serial
        if ( counter==RESET_COUNT ) begin
            case ( state )
            
                0:
                    if ( req==1 ) begin
                        ack <= 1;
                        sync <= 1;
                        dina <= 0;
                        dinb <= 0;
                        state <= 1;
                    end
                    
                1:
                    state <= state + 1;
    
                2:
                    begin
                        dina <= PD[0];
                        dinb <= PD[0];
                        state <= 3;
                    end
    
                3:
                    begin
                        dina <= PD[1];
                        dinb <= PD[1];
                        state <= 4;
                    end  
    
                4,5,6,7,8,9,10,11,12,13,14,15:
    
                    begin
                        dina <= dataA[15-state];
                        dinb <= dataB[15-state];
                        state <= state + 1;
                    end
                    
                16:
                    begin
                        sync <= 0;
                        state <= 17;
                    end
                    
                17:
                    if ( req==0 ) begin
                        ack <= 0;
                        state <= 0;
                    end
                    
                default:
                    begin
                    end
                    
            endcase
        end

    end
        
endmodule
