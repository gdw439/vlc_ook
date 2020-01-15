function OSCautoAmpScale( OSCobject,ChannelIndex )
%OSCAUTOAMPSCALE auto adjust amplitude(y axis) scale
%   OSCobject：oscilloscope object 
%   channelIndex ： the index of selected channel
%% 可以自己修改算法
% 基本想法就是 获取 当前采集到的信号VPP 和 当前scale
% 计算比值
%  示波器y轴总共八个格子
%  比值迭代到覆盖到 6-8 个格子之间
CurrentAmpScale = OSCinquireAmpScale(OSCobject,ChannelIndex);
CurrentVpp = OSCinquireVpp(OSCobject,ChannelIndex);
ratio = CurrentVpp/CurrentAmpScale;    %% 最好在6-8 之间
while ratio > 8 || ratio<6   %% 最好在6-8 之间
%     if CurrentVpp >5 000
%         CurrentVpp
%         setAmpScale = 2*CurrentAmpScale;
%     else
        setAmpScale =CurrentAmpScale/ (7.5 / ratio) ;
%     end
    OSCsetAmpScale(OSCobject,ChannelIndex,[num2str(setAmpScale),'V']);
    CurrentAmpScale = OSCinquireAmpScale(OSCobject,ChannelIndex);
    CurrentVpp = OSCinquireVpp(OSCobject,ChannelIndex);
    ratio = CurrentVpp/CurrentAmpScale;    %% 最好在6-8 之间
end

