% the ook simulation and experence progrom
% Transmission rate depends on the sampling frequency of the oscilloscope.
% Revision:
%   find and renew the bug when change the oversampling multiple from 8 to another.
% by vortex
% 2020.01.06

close all;
clear;clc;
addpath("./function");
addpath("./function/OSC");
%  mode conversion
%  sim = 0 simulation | sim = 1 experience | sim == 2 offline
                      sim = 0; cycle = 1;
                       OSC_Channel = 2;
        port = 'USB0::0x0957::0x1790::MY56271017::0::INSTR';

% ����OOK�������ݵĲ�����Щ�������ɷ��Ͷ˳�������ģ����ն���ȡ��Щ�������ڽ����Ҫ����Ϊ������������ͬ�����е� 
load('data_a\para.mat');    
Tx_stream = bit_stream_m';
test_data = test_data';

ber_bc = zeros(1,cycle);        % ԭʼ������
ber_ac = zeros(1,cycle);        % �ŵ�������������
ber_mc = zeros(1,cycle); 

total  = 100;
err_bc = zeros(cycle, total);   % ����������8B10B����ǰ�Ĵ��������
err_ac = zeros(cycle, total);   % ���ڱ���RS�����Ĵ��������
err_mc = zeros(cycle, total);   % ���ڱ���RS����ǰ������ݵĴ��������
frame_id = zeros(cycle, total); % ֡ͷ���ֽ�Ϊ֡ͷ��ţ����˲�����20֡�����ն������ж�֡ͷ��������Ա�����BER

for cyc = 0:cycle-1
    str = sprintf('Loop: %d', cyc+1);
    disp(str);
    errbit1 = 0;  errbit2 = 0; errbit3 = 0;
    if sim == 0
        Tx_wave = load('data_a\signalT.txt');
        ss_ele_Rx = Tx_wave';
%         ss_ele  =  [Tx_wave; 0; 0; 0;] + [0; 0; 0; Tx_wave];
%         ss_ele_Rx = [ss_ele', ss_ele', ss_ele'];
    elseif sim == 1
        % �ϰ汾��ʾ������ȡ����
        % ss_ele_Rx = osc_read(port,2,1000000);
        % ����1�汾��ʾ������ȡ
        ss_ele_Rx = osc_read_v2(port,OSC_Channel);
        
        if exist('data_a\total.mat','file') ~= 0 
            num = load('data_a\total.mat');
            num = num.num + 1;
            save('data_a\total.mat', 'num');
        else
            num = 0;
            save('data_a\total.mat', 'num');
        end
        path = sprintf('data_a\\signalR %d.txt', num);
        save(path,'ss_ele_Rx', '-ASCII', '-double');
    elseif sim == 2
        path = sprintf('data_a\\signalR %d.txt', cyc);
        ss_ele_Rx = load(path);
    end

    ss_ele_Rx = ss_ele_Rx - mean(ss_ele_Rx);    % ȥ��ֱ������
    h = [-1.43305769334211,7.19187755963437,5.08805533992481,3.37676998328699,-8.37499679573799];
    
    % ����
%     Rx_down = filter(h,1,ss_ele_Rx);
    % ��������
    Rx_down = ss_ele_Rx(1:1:end);

    frame_cnt = floor(length(ss_ele_Rx)/frame_sig_len) - 3;     % �жϽ��յ���������а������ٶ�����֡.
    [ xx,~,~,mu,~,Q1,Q_BER1,~,~ ] = Rx_func( span, N_OS, srrc, Rx_down, '2' ); % λͬ�����̣�ϸ��̫���þ���

    rec_bit = (xx>0);   % ԭʼ�ź�Ϊ[-1,1],ӳ��Ϊ[0,1]
    rec_bit = rec_bit';

    % define the serach space
    % ʹ��ƥ��ͬ�����������ҷ�ֵ��ߵ㼴Ϊ������ʼλ��
    window = rs_len*10+128; 
    tmp = zeros(1,window);
    addr_id = zeros(1,frame_cnt);
    for f = 1:frame_cnt
        for i = 1 : window
           tmp(i) = sum(rec_bit(i+f*window:i+f*window + length(m_sequence)-1) .* m_sequence);
        end
        [~,n] = max(tmp);
        n = n + 128;
        addr_id(f) = n+f*frame_sig_bits;
        recv_data = rec_bit(addr_id(f):addr_id(f)+rs_len*10-1);

        recv_data_m = reshape(recv_data,10,rs_len);
        recv_data_m = recv_data_m';
        data_after_8b10b = zeros(1,rs_len);
        zx = [128;64;32;16;8;4;2;1];

        % ----------- 8B10B Decode --------------------------
        for i = 1:rs_len
            data_after_8b10b(i) = sum(decode8b10(recv_data_m(i,:))*zx);
        end

        % ----------- RS Decode --------------------------
        gf_data = gf(data_after_8b10b,8);
        rec_gf = rsdec(gf_data,204,188);
        rec_rs = zeros(1,frame_len);
        for i = 1:frame_len
          nn = rec_gf(i);
          nn_x = nn.x;     
          rec_rs(i) = double(nn_x);
        end
        id = rec_rs(1);
        frame_id(cyc+1,f) = id;
%         disp(id);
        if (id<frame+1 && id>0)
            % ������ʼ���
            [number,~] = biterr(Tx_stream(id,:),recv_data);
            errbit1 = errbit1 + number;
            err_bc(cyc+1,f) = number;

            [number,~] = biterr(test_data(id,:),rec_rs);
            errbit2 = errbit2 + number;
            err_ac(cyc+1,f) = number;
            
            [number,~] = biterr(rsdo_dataT(id,:),data_after_8b10b);
            errbit3 = errbit3 + number;
            err_mc(cyc+1,f) = number;

        else
            errbit1 = inf;
            err_bc(cyc+1,f) = inf;
            errbit2 = inf;
            err_ac(cyc+1,f) = inf;
            errbit3 = inf;
            err_mc(cyc+1,f) = inf;
        end
    end
    
    ber_bc(cyc+1) = errbit1/(frame_cnt*2040);    % ����ǰ������
    ber_ac(cyc+1) = errbit2/(frame_cnt*1504);    % �����������
    ber_mc(cyc+1) = errbit3/(frame_cnt*1632);
    
    % ����ŵ�����ǰ��������
    disp(['error bits before 8b10b��',num2str(errbit1),'/' , num2str(frame_cnt*2040)]);
    % �ŵ�������������
    disp(['error bits after  rs��',num2str(errbit2),'/' , num2str(frame_cnt*1504)]);
    % 8b10b�е�������
    disp(['error bits after  8b10b��',num2str(errbit3),'/' , num2str(frame_cnt*1632)]);
    
    close all;
    EyePattern(ss_ele_Rx(1:30000), N_OS, cyc);
end
% save('result\error_e5.mat','err_bc','err_ac','err_mc','frame_id');
% if sim==2    
%     data_ber = cal_err(err_bc, err_mc, err_ac);
% end


