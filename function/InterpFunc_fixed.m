function [ DataOut ] = InterpFunc_fixed( Alpha,Orders,Uk,h_width,DataIn )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
if Orders == 4
%     DataOut = (Alpha*Uk^2-Alpha*Uk) * DataIn(4) + (-Alpha*Uk^2+(1+Alpha)*Uk) * DataIn(3) + (-Alpha*Uk^2-(1-Alpha)*Uk+1) * DataIn(2) + (Alpha*Uk^2-Alpha*Uk) * DataIn(1);
    DataOut = (Alpha*Uk^2-Alpha*Uk * 2^(h_width-1)) * DataIn(4) + (-Alpha*Uk^2+(1+Alpha)*Uk * 2^(h_width-1)) * DataIn(3) + (-Alpha*Uk^2-(1-Alpha)*Uk * 2^(h_width-1) + 2^(h_width*2-2)) * DataIn(2) + (Alpha*Uk^2-Alpha*Uk * 2^(h_width-1)) * DataIn(1);
    DataOut =  floor(DataOut./2^(h_width-1)./2^(h_width-1));
else disp('�˲����������ԣ�Ӧ��Ϊ4');
end

end

