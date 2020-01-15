function  OSCsetPoints2read( OSCobject,points2Read )
%OSCsetPoints2read set OSC data points of each capture process
%   OSCobject£ºoscilloscope object 
%   points2Read £º data points 
fprintf(OSCobject,'WAVeform:POINts:MODE RAW');

fprintf(OSCobject,[':WAVeform:POINts',' ',points2Read]);
fprintf(OSCobject,':WAVeform:POINts?');
pointAvailable=fscanf(OSCobject,'%s');
disp('a')
disp(['Number of points to read is: ',pointAvailable]);


end

