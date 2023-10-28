`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 10:15:10 PM
// Design Name: 
// Module Name: ModHex7Seg
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


module ModHex7Seg
#(parameter REFRESH = 240,  parameter CLK_RATE = 100000000) (
    input clk,
    input [15:0] digits,
    input [3:0] decimals,
    output [6:0] seg,
    output dp,
    output [3:0] an
    );
    
    // Creat 1 cycle counter
    localparam real PERIOD = CLK_RATE/REFRESH;
    localparam integer BITS_NEEDED = $clog2($rtoi(PERIOD)+1);
    localparam [(BITS_NEEDED-1):0] RESET_COUNT = $rtoi(PERIOD);
    reg [(BITS_NEEDED-1):0] counter = 0;
    
    // 7-segment encoding
    //      0
    //     ---
    //  5 |   | 1
    //     --- <--6
    //  4 |   | 2
    //     ---
    //      3

    // Zero is active
    wire [7:0] SEGMENTS [15:0];
    assign SEGMENTS[0] = 7'b1000000;
    assign SEGMENTS[1] = 7'b1111001;
    assign SEGMENTS[2] = 7'b0100100;
    assign SEGMENTS[3] = 7'b0110000;
    assign SEGMENTS[4] = 7'b0011001;
    assign SEGMENTS[5] = 7'b0010010;
    assign SEGMENTS[6] = 7'b0000010;
    assign SEGMENTS[7] = 7'b1111000;
    assign SEGMENTS[8] = 7'b0000000;
    assign SEGMENTS[9] = 7'b0010000;
    assign SEGMENTS[10] = 7'b0001000;
    assign SEGMENTS[11] = 7'b0000011;
    assign SEGMENTS[12] = 7'b1000110;
    assign SEGMENTS[13] = 7'b0100001;
    assign SEGMENTS[14] = 7'b0000110;
    assign SEGMENTS[15] = 7'b0001110;

    reg [($clog2(3+1)):0] state = 0; // 3 is max state
    
    assign an = state==0 ? 4'b1110 :
                state==1 ? 4'b1101 :
                state==2 ? 4'b1011 :
                state==3 ? 4'b0111 :
                4'b1111;
    
    assign seg = state==0 ? SEGMENTS[digits[3:0]] :
                 state==1 ? SEGMENTS[digits[7:4]] :
                 state==2 ? SEGMENTS[digits[11:8]] :
                 state==3 ? SEGMENTS[digits[15:12]] :
                 7'b1111111;
                 
    assign dp = ~decimals[state];
    
    // State machines
    always @ ( posedge(clk) ) begin
    
        // Counter
        if ( counter<RESET_COUNT ) begin
            counter <= counter+1;
        end else begin
            counter <= 0;
            if ( state<3 ) begin
                state <= state + 1;
            end else begin
                state <= 0;
            end
        end
        
    end

endmodule
