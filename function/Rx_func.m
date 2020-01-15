function [ xx,e,v,mu,titlename,Q_factor,Q_BER,eye,SendDataMach ] = Rx_func( span,sps,srrc,SendBit,TED_Type )
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
%% Match Filter
% SendBit = SendBit - mean(SendBit);
SendBit = conv(srrc,SendBit);
SendBit = SendBit(span*sps/2+1:end-span*sps/2);

SendDataMach = SendBit;

%%
% figure(101);
% eye_plot( SendBit,sps );

% figure(101);
% eye_plot( SendBit,UPsample );
% [ Q_factor,BER ] = QfactorCalc( SendBit,sps );
% fprintf(' Q= \t%.2f   BER： %.2e\n', Q_factor,BER);

%% clock_recv
if TED_Type == '0'
    [ xx]    = TED_Cnt( SendBit,sps,2^6-1,0.125 );
    e = 0;v = 0;mu = 0;
    titlename = 'COUNT';
else
    [ xx,e,v,mu,titlename,mu2 ]  = clock_recv_fixed( SendBit,TED_Type,sps );
%     [ xx,e,v,mu,titlename ]  = clock_recv( SendBit,TED_Type,sps );
end

RxData0    = xx(sign(xx) == -1);
RxData1    = xx(sign(xx) ==  1);
RxData0M   = mean(RxData0);
RxData1M   = mean(RxData1);
RxData0Std = std(RxData0);
RxData1Std = std(RxData1);
Q_factor   = abs(RxData1M - RxData0M) / (RxData0Std+RxData1Std);
Q_BER      = 1/2*erfc(Q_factor / sqrt(2));

eye   = reshape(SendBit(1:sps*2*floor(length(SendBit)/sps/2)),sps*2,[]);
end

