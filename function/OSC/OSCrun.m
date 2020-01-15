function OSCrun( OSCobject )
%UNTITLED4 run OWC
%   OSCobject£ºoscilloscope object 
fprintf(OSCobject,':RUN');
localWaitForComplete(OSCobject);
end

