`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 01:28:06 PM
// Design Name: 
// Module Name: ModUartTx
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


module ModUartTx
#(parameter BAUD = 9600, parameter CLK_RATE = 100000000) (
    input clk,
    output reg RsTx = 1,
    input [7:0] dataIn,
    input writeEn,
    output full
    );
    
    // Create 1 cycle counter
    localparam real PERIOD = CLK_RATE/BAUD;
    localparam integer BITS_NEEDED = $clog2($rtoi(PERIOD)+1);
    localparam [(BITS_NEEDED-1):0] RESET_COUNT = $rtoi(PERIOD);
    reg [(BITS_NEEDED-1):0] counter = 0;
    
    // Fifo connections
    wire ALMOSTEMPTY;
    wire ALMOSTFULL;
    wire [7:0] DO;
    wire EMPTY;
    wire FULL;
    wire [10:0] RDCOUNT;
    wire RDERR;
    wire [10:0] WRCOUNT;
    wire WRERR;
    wire CLK;
    wire [7:0] DI;
    reg RDEN = 0;
    reg RST = 1;
    wire WREN;
    wire RDEN_EN;
    wire WREN_EN;
    
    // Wire assignment
    assign CLK = clk;
    reg [($clog2(10+1)):0] fifoResetCount = 10;
    assign DI = dataIn;       
    assign TC = 1'b1;
    assign CE = 1'b1;
    assign WREN = writeEn && !FULL;
    assign full = FULL;
    
    // Reset fifo
    always @ ( posedge(CLK) ) begin
        RST <= ( fifoResetCount>=4 );
        if ( fifoResetCount>0 ) begin
            fifoResetCount <= fifoResetCount - 1;
        end
    end
    assign RDEN_EN = RDEN & !RST;
    assign WREN_EN = WREN & !RST;
    
    // State machines
    reg [($clog2(10+1)):0] state = 0; // 10 is max state
    always @ ( posedge(clk) ) begin
    
        // Counter
        if ( state!=0 && counter<RESET_COUNT ) begin
            counter <= counter+1;
        end else begin
            counter <= 0;
        end
        
        // Parallel to serial
        if ( counter==RESET_COUNT ) begin
            case ( state )
            
                0:
                    if ( !EMPTY && (fifoResetCount==0) ) begin
                        RsTx <= 0;
                        state <= 1;
                    end

                1,2,3,4,5,6,7,8:
                    begin
                        RsTx <= DO[state-1];
                        state <= state + 1;
                    end
                    
                9:
                    begin
                        RsTx <= 1;
                        state <= 10;
                    end
                    
                10:
                    begin
                        state <= 0;
                    end
                    
                default:
                    begin
                    end
                    
            endcase
        end
        
        // FIFO read
        if ( state==1 ) begin
            if (!EMPTY) begin
                RDEN <= 1;
            end
        end else begin
            RDEN <= 0;
        end

    end
    
   // FIFO_SYNC_MACRO: Synchronous First-In, First-Out (FIFO) RAM Buffer
   //                  Artix-7
   // Xilinx HDL Language Template, version 2022.2

   /////////////////////////////////////////////////////////////////
   // DATA_WIDTH | FIFO_SIZE | FIFO Depth | RDCOUNT/WRCOUNT Width //
   // ===========|===========|============|=======================//
   //   37-72    |  "36Kb"   |     512    |         9-bit         //
   //   19-36    |  "36Kb"   |    1024    |        10-bit         //
   //   19-36    |  "18Kb"   |     512    |         9-bit         //
   //   10-18    |  "36Kb"   |    2048    |        11-bit         //
   //   10-18    |  "18Kb"   |    1024    |        10-bit         //
   //    5-9     |  "36Kb"   |    4096    |        12-bit         //
   //    5-9     |  "18Kb"   |    2048    |        11-bit         //
   //    1-4     |  "36Kb"   |    8192    |        13-bit         //
   //    1-4     |  "18Kb"   |    4096    |        12-bit         //
   /////////////////////////////////////////////////////////////////

   FIFO_SYNC_MACRO  #(
      .DEVICE("7SERIES"), // Target Device: "7SERIES" 
      .ALMOST_EMPTY_OFFSET(9'h080), // Sets the almost empty threshold
      .ALMOST_FULL_OFFSET(9'h080),  // Sets almost full threshold
      .DATA_WIDTH(8), // Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      .DO_REG(0),     // Optional output register (0 or 1)
      .FIFO_SIZE ("18Kb")  // Target BRAM: "18Kb" or "36Kb" 
   ) FIFO_SYNC_MACRO_inst (
      .ALMOSTEMPTY(ALMOSTEMPTY), // 1-bit output almost empty
      .ALMOSTFULL(ALMOSTFULL),   // 1-bit output almost full
      .DO(DO),                   // Output data, width defined by DATA_WIDTH parameter
      .EMPTY(EMPTY),             // 1-bit output empty
      .FULL(FULL),               // 1-bit output full
      .RDCOUNT(RDCOUNT),         // Output read count, width determined by FIFO depth
      .RDERR(RDERR),             // 1-bit output read error
      .WRCOUNT(WRCOUNT),         // Output write count, width determined by FIFO depth
      .WRERR(WRERR),             // 1-bit output write error
      .CLK(CLK),                 // 1-bit input clock
      .DI(DI),                   // Input data, width defined by DATA_WIDTH parameter
      .RDEN(RDEN_EN),            // 1-bit input read enable
      .RST(RST),                 // 1-bit input reset
      .WREN(WREN_EN)                // 1-bit input write enable
    );

   // End of FIFO_SYNC_MACRO_inst instantiation

endmodule
