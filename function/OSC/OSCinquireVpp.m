function [ Vpp ] = OSCinquireVpp( OSCobject,ChannelIndex )
%OSCINQUIREVPP inquire signal vpp on selected channel
%   OSCobject：oscilloscope object 
%   channelIndex ： the index of selected channel
%   output：
%       VPP： [mV]
%% 适当增加排错函数
    fprintf(OSCobject,[':MEASure:VPP? CHANnel',num2str(ChannelIndex)]);
    Vpp = str2num(fscanf(OSCobject));
end

