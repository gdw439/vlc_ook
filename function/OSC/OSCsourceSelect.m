function  OSCsourceSelect( OSCobject,channelIndex )
%OSCsourceSelect  select channel to capture signal
%   OSCobject£ºoscilloscope object 
%   channelIndex £º the index of selected channel

if channelIndex>4 || channelIndex < 0
    disp('source index is invalid( valid: 1-4)');
else
    source = num2str(channelIndex);
    fprintf(OSCobject,[':TRIGger:SOURce',' ','CHANnel',source]);
    fprintf(OSCobject,[':WAVeform:SOURce CHANnel',source]);
    localWaitForComplete(OSCobject);
end

end

