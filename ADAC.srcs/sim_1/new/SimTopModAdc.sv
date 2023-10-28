`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2023 08:59:57 PM
// Design Name: 
// Module Name: SimTopModAdc
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


module SimTopModAdc(

    );

    // generate clock
    localparam [3:0] CLK_PERIOD = 10; //ns, 100MHz
    reg clk = 0;
    initial clk = 1'b0;
    always #( CLK_PERIOD/2 )
    clk = ~clk;
 
    // daddr_in
    localparam [7:0] XA1 = 8'h16; // AD6
    localparam [7:0] XA3 = 8'h17; // AD7
    localparam [7:0] XA2 = 8'h1e; // AD14
    localparam [7:0] XA4 = 8'h1f; // AD15
    
    
    reg [6:0] daddr_in = XA4[6:0];
    wire [15:0] do_out;
    wire drdy_out;
    wire eos_out;
    
    ModAdc #(.SIM_FILE("C:/Users/DurkusMaximus/Desktop/Xilinx/ADAC/design.txt")) modAdc(
        .daddr_in(daddr_in),
        .dclk_in(clk),
//        .vauxp6(),
//        .vauxn6(),
//        .vauxp7(),
//        .vauxn7(),
//        .vauxp14(),
//        .vauxn14(),
//        .vauxp15(),
//        .vauxn15(),
        .do_out(do_out),
        .drdy_out(drdy_out),
        .eos_out(eos_out)
//        .vp_in(),
//        .vn_in()
        );

endmodule
