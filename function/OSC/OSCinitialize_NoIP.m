function [ OSCobject ] = OSCinitialize( visaAddr_USB )
%initializedOSC initialize OSC
%   visaAddr : OSC usb addr
%   output:
%      OSCobject£ºoscilloscope object
if nargin <1
    visaAddr_USB = 'USB0::0x0957::0x1790::MY54390336::0::INSTR';
end

OSCobject = instrfind('Type', 'visa-usb', 'RsrcName', visaAddr_USB, 'Tag', '');
% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(OSCobject)
    OSCobject = visa('AGILENT', visaAddr_USB);
else
    fclose(OSCobject);
    OSCobject = OSCobject(1);
end
% Configure instrument object, obj1
set(OSCobject, 'InputBufferSize', 4e6);
% Configure instrument object, obj1
set(OSCobject, 'OutputBufferSize', 512);
% Connect to instrument object, obj1.
fopen(OSCobject);
OSCrun(OSCobject);

end

