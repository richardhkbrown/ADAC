`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2023 08:22:28 PM
// Design Name: 
// Module Name: ModAdc
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

//(* CORE_GENERATION_INFO = "xadc_wiz_0,xadc_wiz_v3_3_8,{component_name=xadc_wiz_0,enable_axi=false,enable_axi4stream=false,dclk_frequency=100,enable_busy=true,enable_convst=false,enable_convstclk=false,enable_dclk=true,enable_drp=true,enable_eoc=true,enable_eos=true,enable_vbram_alaram=false,enable_vccddro_alaram=false,enable_Vccint_Alaram=false,enable_Vccaux_alaram=false,enable_vccpaux_alaram=false,enable_vccpint_alaram=false,ot_alaram=false,user_temp_alaram=false,timing_mode=continuous,channel_averaging=None,sequencer_mode=on,startup_channel_selection=contineous_sequence}" *)

module ModAdc
#(parameter SIM_FILE = "design.txt")
(
    input [6:0] daddr_in,      // Address bus for the dynamic reconfiguration port
    input dclk_in,             // Clock input for the dynamic reconfiguration port
    input vauxp6,              // Auxiliary channel 6
    input vauxn6,
    input vauxp7,              // Auxiliary channel 7
    input vauxn7,
    input vauxp14,             // Auxiliary channel 14
    input vauxn14,
    input vauxp15,             // Auxiliary channel 15
    input vauxn15,
    output [15:0] do_out,      // Output data bus for dynamic reconfiguration port
    output drdy_out,           // Data ready signal for the dynamic reconfiguration port
    output eos_out
);

    wire FLOAT_VCCAUX;
    wire FLOAT_VCCINT;
    wire FLOAT_TEMP;
    wire GND_BIT;
    wire [2:0] GND_BUS3;
    assign GND_BIT = 0;
    assign GND_BUS3 = 3'b000;
    wire [15:0] aux_channel_p;
    wire [15:0] aux_channel_n;
    assign aux_channel_p[0] = 1'b0;
    assign aux_channel_n[0] = 1'b0;
    
    assign aux_channel_p[1] = 1'b0;
    assign aux_channel_n[1] = 1'b0;
    
    assign aux_channel_p[2] = 1'b0;
    assign aux_channel_n[2] = 1'b0;
    
    assign aux_channel_p[3] = 1'b0;
    assign aux_channel_n[3] = 1'b0;
    
    assign aux_channel_p[4] = 1'b0;
    assign aux_channel_n[4] = 1'b0;
    
    assign aux_channel_p[5] = 1'b0;
    assign aux_channel_n[5] = 1'b0;
    
    assign aux_channel_p[6] = vauxp6;
    assign aux_channel_n[6] = vauxn6;
    
    assign aux_channel_p[7] = vauxp7;
    assign aux_channel_n[7] = vauxn7;
    
    assign aux_channel_p[8] = 1'b0;
    assign aux_channel_n[8] = 1'b0;
    
    assign aux_channel_p[9] = 1'b0;
    assign aux_channel_n[9] = 1'b0;
    
    assign aux_channel_p[10] = 1'b0;
    assign aux_channel_n[10] = 1'b0;
    
    assign aux_channel_p[11] = 1'b0;
    assign aux_channel_n[11] = 1'b0;
    
    assign aux_channel_p[12] = 1'b0;
    assign aux_channel_n[12] = 1'b0;
    
    assign aux_channel_p[13] = 1'b0;
    assign aux_channel_n[13] = 1'b0;
    
    assign aux_channel_p[14] = vauxp14;
    assign aux_channel_n[14] = vauxn14;
    
    assign aux_channel_p[15] = vauxp15;
    assign aux_channel_n[15] = vauxn15;
    
    // connect the .eoc_out to .den_in to get continuous conversion
    wire den_in;
    wire eoc_out;
    assign den_in = eoc_out;
    
// Config
// | DI15 | DI14 | DI13 | DI12 | DI11 | DI10 |  DI9 |  DI8 |  DI7 |  DI6 |  DI5 |  DI4 |  DI3 |  DI2 |  DI1 | DI0 |
// | CAVG |    0 | AVG1 | AVG0 |  MUX |   BU |   EC |  ACQ |    0 |    0 |    0 |  CH4 |  CH3 |  CH2 |  CH1 | CH0 |
// | SEQ3 | SEQ2 | SEQ1 | SEQ0 | ALM6 | ALM5 | ALM4 | ALM3 | CAL3 | CAL2 | CAL1 | CAL0 | ALM2 | ALM1 | ALM0 |  OT |
// |  CD7 |  CD8 |  CD5 |  CD4 |  CD3 |  CD2 |  CD1 |  CD0 |    0 |   0  |  PD1 |  PD0 |    0 |    0 |    0 |   0 |
XADC #(
    .INIT_40(16'b0000000000000000), // config reg 0
    .INIT_41(16'b0010000110101111), // config reg 1
    .INIT_42(16'b0000001000000000), // config reg 2
    .INIT_48(16'h0000), // Sequencer channel selection
    .INIT_49(16'hC0C0), // Sequencer channel selection
    .INIT_4A(16'h0000), // Sequencer Average selection
    .INIT_4B(16'h0000), // Sequencer Average selection
    .INIT_4C(16'h0000), // Sequencer Bipolar selection
    .INIT_4D(16'h0000), // Sequencer Bipolar selection
    .INIT_4E(16'h0000), // Sequencer Acq time selection
    .INIT_4F(16'h0000), // Sequencer Acq time selection
    .INIT_50(16'hB5ED), // Temp alarm trigger
    .INIT_51(16'h57E4), // Vccint upper alarm limit
    .INIT_52(16'hA147), // Vccaux upper alarm limit
    .INIT_53(16'hCA33), // Temp alarm OT upper
    .INIT_54(16'hA93A), // Temp alarm reset
    .INIT_55(16'h52C6), // Vccint lower alarm limit
    .INIT_56(16'h9555), // Vccaux lower alarm limit
    .INIT_57(16'hAE4E), // Temp alarm OT reset
    .INIT_58(16'h5999), // VCCBRAM upper alarm limit
    .INIT_5C(16'h5111), // VCCBRAM lower alarm limit
    .SIM_DEVICE("7SERIES"),
    .SIM_MONITOR_FILE(SIM_FILE)
)

xadc_inst (
    .CONVST(GND_BIT),
    .CONVSTCLK(GND_BIT),
    .DADDR(daddr_in[6:0]),
    .DCLK(dclk_in),
    .DEN(den_in),
    .DI(16'h0000),
    .DWE(32'h00000000),
    .RESET(GND_BIT),
    .VAUXN(aux_channel_n[15:0]),
    .VAUXP(aux_channel_p[15:0]),
    .ALM(),
    .BUSY(),
    .CHANNEL(),
    .DO(do_out[15:0]),
    .DRDY(drdy_out),
    .EOC(eoc_out),
    .EOS(eos_out),
    .JTAGBUSY(),
    .JTAGLOCKED(),
    .JTAGMODIFIED(),
    .OT(),
    .MUXADDR(),
    .VP(),
    .VN()
);

endmodule