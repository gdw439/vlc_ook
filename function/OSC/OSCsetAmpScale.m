function  OSCsetAmpScale( OSCobject,ChannelIndex,AmpScale )
%OSCSETAMPSCALE set amplitude scale
%   OSCobject��oscilloscope object 
%   channelIndex �� the index of selected channel
%   AmpScale�� Y(amplitude) scale ['1mV']
%% ��������Щ��麯��
    fprintf(OSCobject,[':CHANnel',num2str(ChannelIndex),':SCALe ',AmpScale]);
    pause(3e-2);



end

