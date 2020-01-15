% 对应OOK_Rx_A.m  
% 和其他版本的不同： 发送端发送20帧数据，并在帧头标号
% 方便误码率的计算，代码做相应的修改
% 2018.10.27
% vortex

close all;
clear;clc;

N_OS = 10;
frame = 20;
rs_len = 204;
frame_len = 188;
m_sequence = [
    1 1 1 1 1 1 1 0 0 0 1 1 1 0 1 1 ...
    0 0 0 1 0 1 0 0 1 0 1 1 1 1 1 0 ...
    1 0 1 0 1 0 0 0 0 1 0 1 1 0 1 1 ...
    1 1 0 0 1 1 1 0 0 1 0 1 0 1 1 0 ...
    0 1 1 0 0 0 0 0 1 1 0 1 1 0 1 0 ...
    1 1 1 0 1 0 0 0 1 1 0 0 1 0 0 0 ...
    1 0 0 0 0 0 0 1 0 0 1 0 0 1 1 0 ...
    1 0 0 1 1 1 1 0 1 1 1 0 0 0 0 0];
sps = N_OS;
span = 6;
rolloff = 0.5;
srrc = rcosdesign(rolloff,span,sps,'sqrt'); 
flag = 1:1:frame;
valid_data = randi([0,255],frame,frame_len-1);
test_data = [flag',valid_data];

% ----------- RS Encode --------------------------
gf_data = gf(test_data,8);
rsgf_data = rsenc(gf_data,204,188);
rsdo_data = zeros(1,rs_len*frame);
for f = 1 : frame
    for i = 1:rs_len
      nn = rsgf_data(f,i);
      nn_x = nn.x;     
      rsdo_data(i +(f-1)*rs_len) = double(nn_x);
    end
end

% ----------- 8b10b Encode --------------------------
rd = 0;
filp_data = zeros(rs_len*frame,10);
for i = 1:rs_len*frame
    tmp = bin2str(rsdo_data(i),8);
    [filp_data(i,:),rd] = encode8b10(tmp,rd);
end
bit_stream_m = reshape(filp_data',rs_len*10,frame);

bit_stream_m = bit_stream_m'; 
bit_stream_syn_m = [repmat(m_sequence,frame,1),bit_stream_m];
bit_stream_syn = reshape(bit_stream_syn_m',1,[]);

bit_stream_syn = bit_stream_syn*2 -1;
add_zeros = zeros(N_OS-1,length(bit_stream_syn));
bit_stream_os = reshape([bit_stream_syn;add_zeros],1,[]);
frame_sig_len = length(bit_stream_os)/frame;
% 一帧数据的bit位数
[~,frame_sig_bits] = size(bit_stream_syn_m);

SendBit = conv(srrc,bit_stream_os);
SendBit = SendBit(span*sps/2+1:end-span*sps/2);

SendBit = SendBit';
test_data = test_data';
bit_stream_m = bit_stream_m';
rsdo_dataT = reshape(rsdo_data, rs_len, frame);
rsdo_dataT = rsdo_dataT';
if exist('data_a\para.mat','file') == 0 
    save('data_a\signalT.txt', 'SendBit', '-ASCII', '-double');
    save('data_a\para.mat', 'N_OS', 'rs_len', 'frame_len', 'm_sequence',...
        'srrc','sps','span','rolloff','test_data','bit_stream_m','rsdo_dataT',...
        'frame','frame_sig_len', 'frame_sig_bits');
    disp('文件已生成！');
else
    disp('不能覆盖文件！');
end
