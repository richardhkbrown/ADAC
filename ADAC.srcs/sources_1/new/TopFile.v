`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2023 08:15:18 PM
// Design Name: 
// Module Name: TopFile
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



module TopFile(
    input clk,
    input [2:0] sw,
    output [15:0] led,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output [3:0] JA,
    input vauxp6, input vauxn6,
    input vauxp7, input vauxn7,
    input vauxp14, input vauxn14,
    input vauxp15, input vauxn15,
    output RsTx
    );
    
    `include "Hex2Ascii.vh"

    // daddr_in
    // VCC GND XA4p XA3p XA2p XA1p 
    // VCC GND XA4n XA3n XA2n XA1n
    localparam [7:0] XA1 = 8'h16; // AD6
    localparam [7:0] XA3 = 8'h17; // AD7
    localparam [7:0] XA2 = 8'h1e; // AD14
    localparam [7:0] XA4 = 8'h1f; // AD15
    wire [6:0] daddrIn;
    assign daddrIn = sw == 2'b00 ? XA1[6:0] :
                     sw == 2'b01 ? XA2[6:0] :
                     sw == 2'b10 ? XA3[6:0] :
                     sw == 2'b11 ? XA4[6:0] :
                     XA1[6:0];
    
    // write doOut value as hex to uart
    reg [31:0] counter = 0;
    reg [7:0] dataIn = 0;
    reg writeEn = 0;
    wire [15:0] doOut;
    wire eosOut;
    reg [15:0] doOutLatch;
    always @ ( posedge(clk) ) begin
    
        if ( counter < 100000000 ) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
        end
        if ( counter==0 ) begin
            doOutLatch <= doOut;
        end else if ( counter==1 ) begin
            dataIn <= hex2ascii(doOutLatch[15:12]);
            writeEn <= 1;
        end else if ( counter==2 ) begin
            dataIn <= hex2ascii(doOutLatch[11:8]);
            writeEn <= 1;
        end else if ( counter==3 ) begin
            dataIn <= hex2ascii(doOutLatch[7:4]);
            writeEn <= 1;
        end else if ( counter==4 ) begin
            dataIn <= hex2ascii(doOutLatch[3:0]);
            writeEn <= 1;
        end else if ( counter==5 ) begin
            dataIn <= 10;
            writeEn <= 1;
        end else if ( counter==6 ) begin
            dataIn <= 13;
            writeEn <= 1;
        end else begin
            writeEn <= 0;
        end
                       
    end
    
    // DA2 0 - 3.3 V
    reg [11:0] dataA = 0;
    reg [11:0] dataB = 0;
    reg req = 0;
    wire ack;
    reg [($clog2(3+1)):0] state = 0; // 2 is max state
    always @ ( posedge(clk) ) begin
    
        case ( state )
        
            0:
                if ( ack==0 ) begin
                    dataA <= dataA + 1;
                    dataB <= dataB - 1;
                    state <= 1;
                end
            
            1:
                begin
                    req <= 1;
                    state <= 2;
                end
            
            2:
                if ( ack==1 ) begin
                    req <= 0;
                    state <= 3;
                end
                
            3:
                if ( ack==0 ) begin
                    state <= 0;
                end
                
            default:
                begin
                end
                
        endcase
    
    end

    ModUartTx instTx( .clk(clk), .RsTx(RsTx), .dataIn(dataIn), .writeEn(writeEn), .full() );
    ModAdc instAdc( .daddr_in(daddrIn), .dclk_in(clk),
        .vauxp6(vauxp6), .vauxn6(vauxn6),
        .vauxp7(vauxp7), .vauxn7(vauxn7),
        .vauxp14(vauxp14), .vauxn14(vauxn14),
        .vauxp15(vauxp15), .vauxn15(vauxn15), 
        .do_out(doOut), .drdy_out(), .eos_out(eosOut) );
    ModHex7Seg instHex( .clk(clk), .digits(doOutLatch),
        .decimals(4'b0), .seg(seg), .dp(dp), .an(an) );
    ModDa2 #( .SIO_RATE(10000000) ) instDa2( .clk(clk), .do(JA), .dataA(dataA), .dataB(dataB), .req(req), .ack(ack) );
       
    assign led = sw[2]==0 ? doOut :
                 {dataB[11:4],dataA[11:4]};

endmodule
