function OSCrun( OSCobject )
%UNTITLED4 run OWC
%   OSCobject��oscilloscope object 
fprintf(OSCobject,':RUN');
localWaitForComplete(OSCobject);
end

