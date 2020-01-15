function [ xx,e,v,mu1,titlename,mu2 ] = clock_recv_fixed( SendBit,TED_Type,sps )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%% TED_Type
adc_width  = 14;
mu_width   = 16;

SendBit = round(SendBit ./ max(abs(SendBit)) * (2^(adc_width-1)-1));

offset = 2;
switch TED_Type
    case '1' % Maximum Likelihood Timing Error Detector
        SendBitD = SendBit(offset:end-1) - SendBit(offset+1:end);
        SendBit  = SendBit(offset+1:end);
        titlename= 'MLTED';
    case '2' % Early-Late Timing Error Detector
        SendBitD = SendBit(offset+sps/2:end-sps) - SendBit(offset+sps+sps/2:end);
        SendBit  = SendBit(offset+sps:end-sps/2);
        titlename= 'ELTED';
    case '3' % Zero-Crossing Timing Error Detector
        SendBitD = SendBit(offset:end-sps);
        SendBit  = SendBit(offset+sps/2:end-sps/2);
        titlename= 'ZCTED';
    case '4' % Gardner Timing Error Detector
        SendBitD = SendBit(offset:end-sps) - SendBit(offset+sps:end);
        SendBit  = SendBit(offset+sps/2:end-sps/2);
        titlename= 'GTED';
    case '5' % Mueller and Müller Timing Error Detector
        SendBitD = SendBit(offset:end-sps);
        SendBit  = SendBit(offset+sps:end);
        titlename= 'MMTED';
    otherwise % Gardner Timing Error Detector
        TED_Type = '4';
        SendBitD = SendBit(offset:end-sps) - SendBit(offset+sps:end);
        SendBit  = SendBit(offset+sps/2:end-sps/2);
        titlename= 'GTED';
end

%% LBF
% K1 = -3.5446e-3;
% K2 = -1.4769e-6;
% alpha = 0.5;

DelatF = 100;  % ppm  1G采样率下的频偏
Ts     = 25e6; % symbol rate
T      = 1e9;  % sample rate
BnTs = DelatF*1e-6/Ts*T; % 0.005
Xi   = 1; % 1  sqrt(2)
N    = sps;
Kp   = 1.6; % 0.235
K0   = -1*(mean(abs((SendBit))));   % -1*(std(SendBit))^2
[ K1,K2 ] = PLL_K_calc( BnTs,Xi,N,Kp,K0 );
alpha = 0.5; % 5

k_width  = 0;
k1_width  = ceil(log2(abs(1/K1)))+k_width;
k2_width  = ceil(log2(abs(1/K2)))+k_width;

K1_amp    = round(K1 * (2^(k1_width-1)-1));
K2_amp    = round(K2 * (2^(k2_width-1)-1));

fprintf('k1_width = %d   K1_amp = %d\n',k1_width,K1_amp);
fprintf('k2_width = %d   K2_amp = %d\n',k2_width,K2_amp);

N        = sps;
CNT_next = 0;
mu_next  = 0;
underflow= 0;
vi       = 0;
k        = 1;
symb_len = floor(length(SendBitD)/N);
xx       = zeros(symb_len,1);
mu1      = zeros(symb_len,1);
mu2      = zeros(symb_len*N,1);
e        = zeros(symb_len*N,1);
v        = zeros(symb_len*N,1);
w        = zeros(symb_len*N,1);
vp       = zeros(symb_len*N,1);
vi1      = zeros(symb_len*N,1);
inp      = zeros(symb_len*N,1);
for n = 1+N :symb_len*N-1-N-2 % 2倍过采样时，需要再去掉2个点
    % evaluate arithmetic expressions in topological order
    CNT = CNT_next;
    miu = mu_next;
    inp(n) = InterpFunc_fixed( alpha,4,miu,mu_width,SendBit(n:n+4-1) );
    if underflow == 1
        r1  = InterpFunc_fixed( alpha,4,miu,mu_width,SendBit(n:n+4-1) );  
        r2  = InterpFunc_fixed( alpha,4,miu,mu_width,SendBitD(n:n+4-1) );
        if TED_Type == '3' % Zero-Crossing Timing Error Detector
            e(n)  = -( sign(r2) - sign(InterpFunc_fixed( alpha,4,miu,mu_width,SendBitD(n+sps:n+sps+4-1) )) )*r1;
        elseif TED_Type == '4' % Gardner Timing Error Detector
            e(n)  = -r1*r2/2^(adc_width-1);
        elseif TED_Type == '5' % Mueller and Müller Timing Error Detector
            e(n)  = sign(r2)*r1-sign(r1)*r2;
        else
            e(n)  = -sign(r1)*r2;
        end
        xx(k) = r1;
        mu1(k)= miu;
        k     = k + 1;
    else
        e(n)  = 0;
    end
    vp(n)= round(K1_amp*e(n)) * 2^(k2_width-k1_width);
    % 两路同时要放大k2_width位
    vi   = vi+round(K2_amp*e(n));
    vi1(n)= vi;
    v(n) = vi + vp(n);
    w(n) = round(1/N * 2^(k2_width - 1) + v(n));
    mu2(n+1) = mu2(n)-v(n);
    % update registers
    
    CNT_next = CNT - w(n);
    if CNT_next < 0
        CNT_next = 2^(k2_width-1)+CNT_next;
        underflow= 1;
%         mu_next  = round(CNT/w*2^(mu_width-1));  % /w
        mu_next  = round(CNT*N*2^(mu_width-k2_width));  % /w
    else
        underflow = 0;
        mu_next   = miu;
    end
end
mu2 = mu2/2^(k2_width - 1)*N;
v   = -v/2^(k2_width - 1)*N;
% figure;plot(xx,'.');xlabel('sample');ylabel('抽取点的幅值');title('时钟恢复之后抽取的点');
% figure;
% title_name = strcat('v1  最大位宽',num2str(log2(max(abs(vp)))));
% subplot(2,2,1);plot(vp(1:1e4));xlabel('sample');ylabel('vp');title(title_name);
% title_name = strcat('v2  最大位宽',num2str(log2(max(abs(vi1)))));
% subplot(2,2,2);plot(vi1(1:1e4));xlabel('sample');ylabel('vi');title(title_name);
% title_name = strcat('lpf2model1  最大位宽',num2str(log2(max(abs(v)))));
% subplot(2,2,3);plot(v(1:1e4));xlabel('sample');ylabel('v');title(title_name);
% title_name = strcat('lpf2model1+1/4  最大位宽',num2str(log2(max(abs(w)))));
% subplot(2,2,4);plot(w(1:1e4));xlabel('sample');ylabel('w');title(title_name);
% title_name = strcat('插值后的波形inp  最大位宽',num2str(log2(max(abs(inp)))));
% figure;plot(inp(1:1e4));xlabel('sample');ylabel('inp');title(title_name);

% SendData0    = xx(sign(xx) == -1);
% SendData1    = xx(sign(xx) ==  1);
% SendData0M   = mean(SendData0);
% SendData1M   = mean(SendData1);
% SendData0Std = std(SendData0);
% SendData1Std = std(SendData1);
% Q_factor     = abs(SendData1M - SendData0M) / (SendData0Std+SendData1Std);
% BER   = 1/2*erfc(Q_factor / sqrt(2));
% fprintf('Q_factor = %d   BER = %d\n',Q_factor,BER);

% fsTitle=28; fsAxis=28; fsTick=28; % fontsize of figures.  32
% scrsz = get(groot,'ScreenSize');
% figure('Position',[1 1 scrsz(3)/2 scrsz(4)/2]);
% subplot(2,1,1);plot(e(1:4e4));xlabel('sample','fontsize',fsAxis);ylabel('e','fontsize',fsAxis); set(gca, 'fontsize',fsTick);grid on;title('TED输出');
% % subplot(3,1,2);plot(v);xlabel('sample','fontsize',fsAxis);ylabel('v','fontsize',fsAxis);set(gca, 'fontsize',fsTick);grid on;
% subplot(2,1,2);plot(mu1(1:1e4));xlabel('symbol','fontsize',fsAxis);ylabel('\mu');set(gca, 'fontsize',fsTick);grid on;title('反馈的偏移量');
end

