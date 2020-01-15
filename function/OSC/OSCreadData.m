function [ y ] = OSCreadData( OSCobject )
%OSCreadData CAPTURE data fromm OSC
%   OSCobject£ºoscilloscope object 
%   output:
%       y: data
fprintf(OSCobject,'WAVeform:PREamble?');
preamble=str2num(fscanf(OSCobject,'%s'));
points=preamble(3);
x_increment=preamble(5);
x_origin=preamble(6);
y_increment=preamble(8);
y_origin=preamble(9);
y_reference=preamble(10);
x=x_origin:x_increment:x_origin+(points-1)*x_increment;
localWaitForComplete(OSCobject);
fprintf(OSCobject,'WAVeform:DATA?');
data=fread(OSCobject);
y=(data(11:end-1)-y_reference).*y_increment+y_origin;

end

