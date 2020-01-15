function Rxdata_ori = osc_read(visaResourceString,source,pointtoread)
    obj1 = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::2391::6032::MY54390336::0::INSTR', 'Tag', '');
    if isempty(obj1)
        obj1 = visa('AGILENT', visaResourceString);
    else
        fclose(obj1);
        disp('fail');
        obj1 = obj1(1);
    end
    set(obj1, 'InputBufferSize', 2e6);
    set(obj1, 'OutputBufferSize', 512);
    fopen(obj1);
    pause(1e-2);
    
    fprintf(obj1,[':TRIGger:SOURce',' ','CHANnel',source]);
    fprintf(obj1,[':WAVeform:SOURce CHANnel',source]);
    
    pause(1e-2);
    fprintf(obj1,'WAVeform:POINts:MODE RAW');
    fprintf(obj1,[':WAVeform:POINts',' ',pointtoread]);
    fprintf(obj1,':WAVeform:POINts?');
    pointavailable=fscanf(obj1,'%s');
    
    pause(1e-2);
    fprintf(obj1,':RUN');
    pause(1e-4);
%     fprintf(obj1,':STOP');
    fprintf(obj1,'WAVeform:PREamble?');
    preamble = str2num(fscanf(obj1,'%s'));
    points = preamble(3);
    x_increment = preamble(5);
    x_origin = preamble(6);
    y_increment = preamble(8);
    y_origin = preamble(9);
    y_reference = preamble(10);
    x=x_origin:x_increment:x_origin+(points-1)*x_increment;
    fprintf(obj1,'WAVeform:DATA?');
    data=fread(obj1);
    y=(data(11:end-1)-y_reference).*y_increment+y_origin;
    Rxdata_ori=y';
    fprintf(obj1,':RUN');
    pause(1e-2);
    fclose(obj1);
end