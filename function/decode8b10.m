function decode_data = decode8b10(data)
% Decodedta=dec2bin(data,10);
Decodedta = char(data+'0');
fghi=Decodedta(4:-1:1);
abcdi=Decodedta(10:-1:5);
%%3b4b译码
if(strcmp(fghi,'1011')||strcmp(fghi,'1011')) HGF='000';
elseif (strcmp(fghi,'1001')) HGF='001';
elseif (strcmp(fghi,'0101')) HGF='010';
elseif (strcmp(fghi,'1100')||strcmp(fghi,'0011')) HGF='011';
elseif (strcmp(fghi,'1101')||strcmp(fghi,'0010')) HGF='100';
elseif (strcmp(fghi,'1010')) HGF='101';
elseif (strcmp(fghi,'0110')) HGF='110';
elseif (strcmp(fghi,'1110')||strcmp(fghi,'0001')) HGF='111';
else sprintf('3B4B接收到无效译码数据！');HGF='000';
end
%%5b6b译码
if(strcmp(abcdi,'100111') || strcmp(abcdi,'011000')) EDCBA='00000';
elseif(strcmp(abcdi,'011101') || strcmp(abcdi,'100010')) EDCBA='00001';
elseif(strcmp(abcdi,'101101') || strcmp(abcdi,'010010')) EDCBA='00010';
elseif(strcmp(abcdi,'110001')) EDCBA='00011';
elseif(strcmp(abcdi,'110101') || strcmp(abcdi,'001010')) EDCBA='00100';
elseif(strcmp(abcdi,'101001')) EDCBA='00101';
elseif(strcmp(abcdi,'011001')) EDCBA='00110';
elseif(strcmp(abcdi,'111000') || strcmp(abcdi,'000111')) EDCBA='00111';
elseif(strcmp(abcdi,'111001') || strcmp(abcdi,'000110')) EDCBA='01000';
elseif(strcmp(abcdi,'100101')) EDCBA='01001';
elseif(strcmp(abcdi,'010101')) EDCBA='01010';
elseif(strcmp(abcdi,'110100')) EDCBA='01011';
elseif(strcmp(abcdi,'001101')) EDCBA='01100';
elseif(strcmp(abcdi,'101100')) EDCBA='01101';
elseif(strcmp(abcdi,'011100')) EDCBA='01110';
elseif(strcmp(abcdi,'010111') || strcmp(abcdi,'101000')) EDCBA='01111';
elseif(strcmp(abcdi,'011011') || strcmp(abcdi,'100100')) EDCBA='10000';
elseif(strcmp(abcdi,'100011')) EDCBA='10001';
elseif(strcmp(abcdi,'010011')) EDCBA='10010';
elseif(strcmp(abcdi,'110010')) EDCBA='10011';
elseif(strcmp(abcdi,'001011')) EDCBA='10100';
elseif(strcmp(abcdi,'101010')) EDCBA='10101';
elseif(strcmp(abcdi,'011010')) EDCBA='10110';
elseif(strcmp(abcdi,'111010') | strcmp(abcdi,'000101')) EDCBA='10111';
elseif(strcmp(abcdi,'110011') | strcmp(abcdi,'001100')) EDCBA='11000';
elseif(strcmp(abcdi,'100110')) EDCBA='11001';
elseif(strcmp(abcdi,'010110')) EDCBA='11010';
elseif(strcmp(abcdi,'110110') | strcmp(abcdi,'001001')) EDCBA='11011';
elseif(strcmp(abcdi,'001110')) EDCBA='11100';
elseif(strcmp(abcdi,'101110') || strcmp(abcdi,'010001')) EDCBA='11101';
elseif(strcmp(abcdi,'011110') | strcmp(abcdi,'100001')) EDCBA='11110';
elseif(strcmp(abcdi,'101011') | strcmp(abcdi,'010100')) EDCBA='11111';
else sprintf('5B6B接收到无效译码数据！');EDCBA='00000';
end
strdata=[HGF EDCBA];
% decode_data = bin2dec(strdata(1:end)) ;  
decode_data = double(strdata(1:end)-48) ;

