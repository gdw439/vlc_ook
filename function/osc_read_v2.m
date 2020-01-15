function Rxdata_ori = osc_read_v2(oscVisaAddr_USB, oscChannelSelected)
    addpath("./function/OSC");

    visaAddrTYPE = 0;
    oscPonints2Read = 2e6;      % ��ȡ�ĵ���
    % oscSamRate = 0.2e9;         % 200Msam per second

    % ��ʼ��
    oscObject = OSCinitialize(oscVisaAddr_USB,visaAddrTYPE);  % ��������
    OSCsetPoints2read(oscObject,oscPonints2Read);
    OSCsourceSelect(oscObject,oscChannelSelected);   % default channel 1
    % OSCsetSampleRate(oscObject,oscSamRate);

    % �ɼ�����
    OSCrun(oscObject);
    pause(3e-1);
    OSCstop(oscObject);
    pause(3e-1);
    Rxdata_ori = OSCreadData(oscObject);
end