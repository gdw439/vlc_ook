function data = osc_data(osc)
    fprintf(osc,':RUN');
    pause(1e-4);
    fprintf(osc,':STOP');
    fprintf(osc,'WAVeform:PREamble?');
    preamble = str2num(fscanf(osc,'%s'));
    points = preamble(3);
    x_increment = preamble(5);
    x_origin = preamble(6);
    y_increment = preamble(8);
    y_origin = preamble(9);
    y_reference = preamble(10);
    fprintf(osc,'WAVeform:DATA?');
    data1=fread(osc);
    y=(data1(11:end-1)-y_reference).*y_increment+y_origin;
    data=y';
    fprintf(osc,':RUN');
    pause(1e-3);
    fclose(osc);
end