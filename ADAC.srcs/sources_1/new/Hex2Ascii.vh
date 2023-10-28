`ifndef _Hex2Ascii_vh_
`define _Hex2Ascii_vh_

function [7:0] hex2ascii(
    input [3:0] nibble
    );

    hex2ascii = nibble==0 ? 48 :
                nibble==1 ? 49 :
                nibble==2 ? 50 :
                nibble==3 ? 51 :
                nibble==4 ? 52 :
                nibble==5 ? 53 :
                nibble==6 ? 54 :
                nibble==7 ? 55 :
                nibble==8 ? 56 :
                nibble==9 ? 57 :
                nibble==10 ? 65 :
                nibble==11 ? 66 :
                nibble==12 ? 67 :
                nibble==13 ? 68 :
                nibble==14 ? 69 :
                nibble==15 ? 70 :
                64;

endfunction

`endif