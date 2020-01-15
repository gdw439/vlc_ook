function data_ber = cal_err(err_bc, err_mc, err_ac)
    th = 300;   % 判断为误帧的门限
    data_ber = zeros(3,1);
    k1 = length(find(err_bc>th));
    err_bc(err_bc>th) = 0;
    [m,n] = size(err_bc);
    sum(sum(err_bc))
    mean_ber_bc = sum(sum(err_bc))/((m*n-k1)*2040);
    disp(['bc:   ',num2str(mean_ber_bc)]);
    data_ber(1) = mean_ber_bc;

    k2 = length(find(err_mc>th));
    err_mc(err_mc>th) = 0;
    [m,n] = size(err_mc);
    mean_ber_mc = sum(sum(err_mc))/((m*n-k2)*1632);
    disp(['mc:   ',num2str(mean_ber_mc)]);
    data_ber(2) = mean_ber_mc;

    k3 = length(find(err_ac>th));
    err_ac(err_ac>th) = 0;
    [m,n] = size(err_ac);
    mean_ber_ac = sum(sum(err_ac))/((m*n-k3)*1504);
    disp(['ac:   ',num2str(mean_ber_ac)]);
    data_ber(3) = mean_ber_ac;
end