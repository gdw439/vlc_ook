function  OSCstop( OSCobject )
%UNTITLED5 stop OWC capturing data
%   OSCobject��oscilloscope object        
fprintf(OSCobject,':STOP');
localWaitForComplete(OSCobject);

end

