function Rxdata_ori = osc_read_v2(oscVisaAddr_USB, oscChannelSelected)
    addpath("./function/OSC");

    visaAddrTYPE = 0;
    oscPonints2Read = 2e6;      % 读取的点数
    % oscSamRate = 0.2e9;         % 200Msam per second

    % 初始化
    oscObject = OSCinitialize(oscVisaAddr_USB,visaAddrTYPE);  % 建立连接
    OSCsetPoints2read(oscObject,oscPonints2Read);
    OSCsourceSelect(oscObject,oscChannelSelected);   % default channel 1
    % OSCsetSampleRate(oscObject,oscSamRate);

    % 采集数据
    OSCrun(oscObject);
    pause(3e-1);
    OSCstop(oscObject);
    pause(3e-1);
    Rxdata_ori = OSCreadData(oscObject);
end