function [ AmpScale ] = OSCinquireAmpScale( OSCobject,ChannelIndex)
%OSCSETAMPSCALE inquire amplitude scale of selected channel
%   OSCobject：oscilloscope object 
%   channelIndex ： the index of selected channel
%   output 
%       AmpScale: current Amplitude(y) scale of selected channel
%% 可以增添些检查函数
    fprintf(OSCobject,[':CHANnel',num2str(ChannelIndex),':SCALe?']);
    %pause(3e-1);
    AmpScale = str2num(fscanf(OSCobject));

end

