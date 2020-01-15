function osc = osc_init(visaResourceString,source,pointtoread)
obj1 = instrfind('Type', 'visa-usb', 'RsrcName', visaResourceString, 'Tag', '');
if isempty(obj1)
    obj1 = visa('AGILENT', visaResourceString);
else
    fclose(obj1);
    obj1 = obj1(1);
end
set(obj1, 'InputBufferSize', 2e6);
set(obj1, 'OutputBufferSize', 512);
fopen(obj1);
pause(1e-3);
fprintf(obj1,[':TRIGger:SOURce',' ','CHANnel',source]);
fprintf(obj1,[':WAVeform:SOURce CHANnel',source]);
pause(1e-3);

fprintf(obj1,'WAVeform:POINts:MODE RAW');
fprintf(obj1,[':WAVeform:POINts',' ',pointtoread]);
fprintf(obj1,':WAVeform:POINts?');
pointavailable=fscanf(obj1,'%s');
disp(pointavailable);
osc = obj1;
end