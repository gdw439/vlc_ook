[isSync , recvSignalDownSamAfterSync,blockNum ] = pam_sync(recvSignals,SignalInfo,symblLengh,syncSeq,GraphON,-2);
   
%    chanEstOffset = 1;
%     mean(sendSignals(chanEstOffset:chanEstOffset-1+channelEstNum)./recvSignalDownSamAfterSync(chanEstOffset:chanEstOffset-1+channelEstNum))
%    chanEstSeg = chanEstOffset:chanEstOffset+ channelEstNum -1;
%    place_1 = find(sendSignals(chanEstSeg) == SignalInfo.ModOrder - 1 );
%    place_2 = find(sendSignals(chanEstSeg) == - SignalInfo.ModOrder + 1);
%     recvSignalDownSamAfterSync = recvSignalDownSamAfterSync * ...
%    mean([sendSignals(place_1);sendSignals(place_2)]./...
%    [recvSignalDownSamAfterSync(place_1);recvSignalDownSamAfterSync(place_2)]);
switch ChannelEstEquMod
    case 1
        chanEstOffset = 1;
        mean(sendSignals(chanEstOffset:chanEstOffset-1+channelEstNum)./recvSignalDownSamAfterSync(chanEstOffset:chanEstOffset-1+channelEstNum))
        chanEstSeg = chanEstOffset:chanEstOffset+ channelEstNum -1;
        place_1 = find(sendSignals(chanEstSeg) == SignalInfo.ModOrder - 1 );
        place_2 = find(sendSignals(chanEstSeg) == - SignalInfo.ModOrder + 1);
        recvSignalDownSamAfterSync = recvSignalDownSamAfterSync * ...
        mean([sendSignals(place_1);sendSignals(place_2)]./...
        [recvSignalDownSamAfterSync(place_1);recvSignalDownSamAfterSync(place_2)]);
    case 2 
        eq1 = lineareq(3,lms(0.000003));
%eq1 = dfe(6,2,lms(0.00001));
        eq1.RefTap = 1;
        eq1.SigConst = [(SignalInfo.ModOrder-1):-2:-(SignalInfo.ModOrder-1)];
        [recvSignalDownSamAfterSync,~,e] = equalize(eq1,400*recvSignalDownSamAfterSync,...
        sendSignals(1:channelEstNum));  

    case 3
        recvSignalDownSamAfterSync = filter([1.0000   -0.1559    0.0490    0.0211   -0.0312   -0.0603 ],1,recvSignalDownSamAfterSync);
        chanEstOffset = 1;
        mean(sendSignals(chanEstOffset:chanEstOffset-1+channelEstNum)./recvSignalDownSamAfterSync(chanEstOffset:chanEstOffset-1+channelEstNum))
        chanEstSeg = chanEstOffset:chanEstOffset+ channelEstNum -1;
        place_1 = find(sendSignals(chanEstSeg) == SignalInfo.ModOrder - 1 );
        place_2 = find(sendSignals(chanEstSeg) == - SignalInfo.ModOrder + 1);
        recvSignalDownSamAfterSync = recvSignalDownSamAfterSync * ...
        mean([sendSignals(place_1);sendSignals(place_2)]./...
        [recvSignalDownSamAfterSync(place_1);recvSignalDownSamAfterSync(place_2)]);
end
% eq1 = lineareq(6,lms(0.000003));
% %eq1 = dfe(6,2,lms(0.00001));
% eq1.RefTap = 1;
% eq1.SigConst = [(SignalInfo.ModOrder-1):-2:-(SignalInfo.ModOrder-1)];
% recvSignalDownSamAfterSync = equalize(eq1,400*recvSignalDownSamAfterSync,...
%     sendSignals(1:channelEstNum));  

%% fixed coefficient equalization 
%  eq_h = [1.0000   -0.9030    0.1860   -0.0220];
%  eq_h_4PAM_BIGawg_MCcoding_8 = [1.0000   -0.6990    0.0609    0.0091    0.0464    0.0074    0.0141    0.0194
% ]
% eq_h_4PAM_BIGawg_MCcoding_4 = [1.0000   -0.7012    0.0438   -0.0012]

%% BigAWGUnderwater8PamMCcodingPreEq_2 后向均横抽头  【0.5767   -0.0546   -0.0229   -0.0262】
%% BigAWGUnderwater4PamNoMCcodingPreEq_3p5 后向均横抽头 [0.2312   -0.0322   -0.0160   -0.0099]
%% BigAWGUnderwater4PamMCcodingPreEq200Mcascade 后向均衡抽头 [1.0000   -0.4823   -0.2249   -0.0120】
%% BigAWGUnderwater4PamMCcoding200MPreEqNew 1.0000   -0.3630   -0.1643    0.0393 
%% BigAWGUnderwater4PamMCcodingPreEq200Mcascade2 1.0000   -0.1559    0.0490    0.0211   -0.0312   -0.0603
%% or  1.0000   -0.1799    0.0582    0.0138   -0.0333   -0.0624 this one is better
 %    recvSignalDownSamAfterSync = filter([  1.0000   -0.0631    0.0472    0.1063   -0.0141   -0.0168  ],1,recvSignalDownSamAfterSync);
% 
% chanEstOffset = 1;
%     mean(sendSignals(chanEstOffset:chanEstOffset-1+channelEstNum)./recvSignalDownSamAfterSync(chanEstOffset:chanEstOffset-1+channelEstNum))
%    chanEstSeg = chanEstOffset:chanEstOffset+ channelEstNum -1;
%    place_1 = find(sendSignals(chanEstSeg) == SignalInfo.ModOrder - 1 );
%    place_2 = find(sendSignals(chanEstSeg) == - SignalInfo.ModOrder + 1);
%     recvSignalDownSamAfterSync = recvSignalDownSamAfterSync * ...
%    mean([sendSignals(place_1);sendSignals(place_2)]./...
%    [recvSignalDownSamAfterSync(place_1);recvSignalDownSamAfterSync(place_2)]);

 recvSignalDownSamAfterSync = 1*recvSignalDownSamAfterSync;
 if GraphON
   figure(3)
   plot(recvSignalDownSamAfterSync(10000:10000+100),'k');
   hold on;
   plot(sendSignals(10000:10000+100),'r');
 end
 %% decide Manchester decoding or not  
   
if SignalInfo.Other.ManchesterCodingYorN
   temp = reshape(recvSignalDownSamAfterSync,2,[])';
   recvSignal2demod = 1/2*(temp(:,1) - temp(:,2));
   temp = reshape(sendSignals,2,[])';
   sendSignalsReshpe = 1/2*(temp(:,1) - temp(:,2));
else
   recvSignal2demod = recvSignalDownSamAfterSync;
   sendSignalsReshpe = sendSignals;
end
if GraphON
   figure(4) 
   recvPlotOffset = 9000;
   recvPlotSeg = 100;
   plot(recvSignal2demod(recvPlotOffset:recvPlotOffset+recvPlotSeg),'k');
   hold on;
   tempp = mod([recvPlotOffset:recvPlotOffset+recvPlotSeg],16384);
   tempp(tempp == 0) = 16384; 
   plot(sendSignalsReshpe(tempp),'r');
   figure(5)
   eyedigramK = 3;
   tempSig = recvSignal2demod(1:eyedigramK*floor(length(recvSignal2demod(1000:40000))/eyedigramK));
   %temp2draw = reshape(tempSig,eyedigramK,[]);
   %plot(temp2draw(1:10,:),'k');
   plot(reshape(tempSig,eyedigramK,[]),'k');
   figure(7)
   plot(xcorr(recvSignalDownSamAfterSync,syncSeq));
end 
%% demodulation
   demodulator=modem.pamdemod('M',SignalInfo.ModOrder,...
            'SymbolOrder','Gray','OutputType','bit','DecisionType','hard decision');
 % sendBits=demodulate(demodulator,repmat(sendSignalsReshpe,2,1));
 %  
 dupSendBits = repmat(sendBits,blockNum,1);
 recvBits = demodulate(demodulator,recvSignal2demod);
  
   [a,b] = biterr(dupSendBits(channelEstNum+1:end),recvBits(channelEstNum+1:end)) ;
   if GraphON
    figure(6)
    plot (xor(repmat(sendBits,blockNum,1),recvBits()),'*')
   end 
 sym2evm = 8000;
 evm = sqrt(sum((recvSignal2demod(1:sym2evm) - sendSignalsReshpe(1:sym2evm)).^2)/sum(sendSignalsReshpe(1:sym2evm).^2));
 evmdB(index) = 10*log10(evm);
 snrdB(index) = 10*log10(1/evm^2);
 BER_th(index)= 2*(SignalInfo.ModOrder-1)/SignalInfo.ModOrder/log2(SignalInfo.ModOrder)*qfunc(sqrt(3/(SignalInfo.ModOrder^2-1)*1/evm^2));
 BER_ex(index) = b;
 err_cnt(index) = a;
 bit_cnt(index) = length(recvBits-channelEstNum);
 
 
 index = index + 1;
