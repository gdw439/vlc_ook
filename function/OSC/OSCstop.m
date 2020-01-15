function  OSCstop( OSCobject )
%UNTITLED5 stop OWC capturing data
%   OSCobject£ºoscilloscope object        
fprintf(OSCobject,':STOP');
localWaitForComplete(OSCobject);

end

