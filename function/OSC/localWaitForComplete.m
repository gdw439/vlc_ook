function localWaitForComplete(intrumentObject)
        % LOCALWAITFORCOMPLETE This function causes the AWG to execute all 
        % commands up till function call and returns when done
        fwrite(intrumentObject, '*WAI');
        while (str2double(query(intrumentObject, '*OPC?'))~=1)
            pause(1e-3);
        end
    end