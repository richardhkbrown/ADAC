rng(0);
fprintf(1,'TIME  VAUXP[6] VAUXN[6] VAUXP[7] VAUXN[7] VAUXP[14] VAUXN[14] VAUXP[15] VAUXN[15]\n');
VAUX6  = {'0000','0001','0002','0003','0004','0005','0006','0007','0008','0009','000A','000B','000C','000D','000E','000F'};
VAUX7  = {'0000','1111','2222','3333','4444','5555','6666','7777','8888','9999','AAAA','BBBB','CCCC','DDDD','EEEE','FFFF'};
VAUX14 = {'0000','1001','2002','3003','4004','5005','6006','7007','8008','9009','A00A','B00B','C00C','D00D','E00E','F00F'};
VAUX15 = {'0000','BABE','DEAD','0BAD','DEED','FEED','0BED','ABE1','BEAD','BEEF','0DAD','0FAD','0CAD','0ACE','0CAB','FADE'};

fprintf(1,'00000 1.000000 0.000000 1.000000 0.000000  1.000000  0.000000  1.000000  0.000000\n');
for idx = 1:length(VAUX7)
    tick_ns = 4*520*(idx);
    fprintf(1,'%05d',tick_ns);
    fprintf(1,' %08f 0.000000',hex2dec(VAUX6{idx})/hex2dec('FFFF'));
    fprintf(1,' %08f 0.000000',hex2dec(VAUX7{idx})/hex2dec('FFFF'));
    bias = 0.5*rand;
    fprintf(1,'  %08f  %08f',hex2dec(VAUX14{idx})/hex2dec('FFFF')+bias,bias);
    bias = 0.5*rand;
    fprintf(1,'  %08f  %08f',hex2dec(VAUX15{idx})/hex2dec('FFFF')+bias,bias);
    fprintf(1,'\n');
end
