function [codedta,next_rd] = encode8b10(data,RD)
% Encodedta=dec2bin(data,8);
Encodedta = char(data+'0');
% str_temp=[];
% for i = 1: 8
%     str_temp=[str_temp,char(data(i))];
% end
EDCBA=Encodedta(4:8);
HGF=Encodedta(1:3);
%%5b6b±àÂë
    if(strcmp(EDCBA,'00000')) 
        if RD==-1  abcdei='100111' ;tempRD1 = 1 ;
        else abcdei='011000';tempRD1 = -1;
        end
    end
    if (strcmp(EDCBA,'00001')) 
        if RD==-1  abcdei='011101';tempRD1 = 1; 
        else abcdei='100010';tempRD1 = -1;
        end
    end
    if(strcmp(EDCBA,'00010')) 
        if RD==-1  abcdei='101101';tempRD1 = 1 ;
        else abcdei='010010';tempRD1 = -1;
        end
    end
    if(strcmp(EDCBA,'00011')) abcdei='110001';tempRD1 = RD ; end  
    if(strcmp(EDCBA,'00100')) 
        if RD==-1  abcdei='110101';tempRD1 = 1; 
        else abcdei='001010';tempRD1 = -1;
        end
    end
    if(strcmp(EDCBA,'00101')) abcdei='101001';tempRD1 = RD ;end     
    if(strcmp(EDCBA,'00110')) abcdei='011001';tempRD1 = RD;end 
    if(strcmp(EDCBA,'00111')) if RD==-1  abcdei='111000';tempRD1 = 1 ;
        else abcdei='000111';tempRD1 = -1;
        end
    end
    if(strcmp(EDCBA,'01000')) 
        if RD==-1  abcdei='111001';tempRD1 = 1; 
        else abcdei='000110';tempRD1 = -1;
        end  
    end
  if(strcmp(EDCBA,'01001')) abcdei='100101';tempRD1 = RD;end  
  if(strcmp(EDCBA,'01010'))  abcdei='010101';tempRD1 = RD;end    
  if(strcmp(EDCBA,'01011'))  abcdei='110100';tempRD1 =RD;end
  if(strcmp(EDCBA,'01100')) abcdei='001101';tempRD1 = RD;end
  if(strcmp(EDCBA,'01101')) abcdei='101100';tempRD1 = RD; end 
  if(strcmp(EDCBA,'01110')) abcdei='011100';tempRD1 = RD;end
  if(strcmp(EDCBA,'01111')) 
        if RD==-1  abcdei='010111';tempRD1 = 1 ;
        else abcdei='101000';tempRD1 = -1;
        end
  end
     
 if(strcmp(EDCBA,'10000')) 
        if RD==-1  abcdei='011011';tempRD1 = 1 ;
        else abcdei='100100';tempRD1 = -1;
        end
 end
     
 if(strcmp(EDCBA,'10001')) abcdei='100011';tempRD1 = RD; end
 if(strcmp(EDCBA,'10010'))abcdei='010011';tempRD1 = RD;end
 if(strcmp(EDCBA,'10011'))  abcdei='110010';tempRD1 = RD; end
 if(strcmp(EDCBA,'10100'))  abcdei='001011';tempRD1 = RD;end
 if(strcmp(EDCBA,'10101')) abcdei='101010';tempRD1 = RD;end
 if(strcmp(EDCBA,'10110')) abcdei='011010';tempRD1 = RD;end
 if(strcmp(EDCBA,'10111')) 
        if RD==-1  abcdei='111010';tempRD1 = 1 ;
        else abcdei='000101';tempRD1 = -1;
        end
        end
 if(strcmp(EDCBA,'11000')) 
        if RD==-1  abcdei='110011';tempRD1 = 1 ;
        else abcdei='001100';tempRD1 = -1;
        end
 end
 if(strcmp(EDCBA,'11001')) abcdei='100110';tempRD1 = RD; end
 if(strcmp(EDCBA,'11010'))  abcdei='010110';tempRD1 = RD;  end  
 if(strcmp(EDCBA,'11011')) 
        if RD==-1  abcdei='110110';tempRD1 = 1 ;
        else abcdei='001001';tempRD1 = -1;
        end
 end
 if(strcmp(EDCBA,'11100')) abcdei='001110';tempRD1 = RD;end
 if(strcmp(EDCBA,'11101')) 
        if RD==-1  abcdei='101110';tempRD1 = 1; 
        else abcdei='010001';tempRD1 = -1;
        end
 end

        
  if(strcmp(EDCBA,'11110'))
          if RD==-1  abcdei='011110';tempRD1 = 1; 
         else abcdei='100001';tempRD1 = -1;
          end
  end
       
 if(strcmp(EDCBA,'11111')) 
         if RD==-1  abcdei='101011';tempRD1 = 1 ;
         else abcdei='010100';tempRD1 = -1;
         end
 end
 %%%3b4b±àÂë
 if(strcmp(HGF,'000'))
     if RD==-1 fghi='1011';tempRD2 =1;
     else fghi ='0100';tempRD2 = -1;
     end
 end
if(strcmp(HGF,'001')) 
    fghi ='1001';tempRD2 =RD;
end
if(strcmp(HGF,'010')) 
    fghi ='0101';tempRD2 = RD;
end         
 if(strcmp(HGF,'011'))
     if RD==-1 fghi='1100';tempRD2 =1;
     else fghi ='0011';tempRD2 = -1;
     end
 end    
  if(strcmp(HGF,'100'))
     if RD==-1 fghi='1101';tempRD2 =1;
     else fghi ='0010';tempRD2 = -1;
     end
 end          
if(strcmp(HGF,'101')) 
    fghi ='1010';tempRD2 = RD;
end  
 
if(strcmp(HGF,'110')) 
    fghi ='0110';tempRD2 = RD;
end
 if(strcmp(HGF,'111'))
     if RD==-1 fghi='1110';tempRD2 =1;
     else fghi ='0001';tempRD2 = -1;
     end
 end   
 
 if (tempRD1 == tempRD2) next_rd = RD;
 else next_rd = -RD;
 end
 strdata=[abcdei fghi];
%  codedta = bin2dec(strdata(end:-1:1)) ;    
codedta = double(strdata(end:-1:1)-48) ;
     
     
     
 
