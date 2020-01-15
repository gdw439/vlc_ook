function OSCsetSampleRate( OSCobject,SampleRates )
%OSCSETTIMESCALE set time scale ��sample rate�����ò�����
%   OSCobject��oscilloscope object 
%   SampleRates �� Sample rate [sample per second]
%   ԭ�� һ��ÿ�� timescale ��Ӧ һ�� ������ ����� ���� ĳ�������ʣ�ȡ �ܲɼ��� 
%   �������� �Ǹ� timescale ��Ϊ ��Ҫ�趨�� timescale����Ϊ ʾ����ֻ���趨timescale
%    AvailableSampleRates   10M     40M     50M     62.5M   80M 
%                           100M    125M    200M    250M    400M 
%                           500M    1G      2G      5G      10G 
%                           20G 
%% ���������Ƶ�� (ע ��� �� ʾ���� �ͺ��й�)
    AvailableSampleRates = [1e7 4e7 5e7 6.25e7 8e7 1e8 1.25e8 2e8 2.5e8 4e8 ...
        5e8 1e9 2e9 5e9 1e10 2e10 ];
    %% TimeScale = 2e6 /sample rate / 10 *1000
    AvailableTimeScale   = [ 20.0000 5.0000 4.0000 3.2000 2.5000 2.0000 1.6000 ...
        1.0000 0.8000 0.5000 0.4000 0.2000 0.1000 0.0400 0.0200 0.0100];  %% ��λ ms
    index = find(AvailableSampleRates == SampleRates, 1);
    if isempty(index)
        disp('your input sample rates is not supported')
    else
        fprintf(OSCobject,[':TIMebase:SCALe ',num2str(AvailableTimeScale(index)),'ms']);
        pause(3e-1);
    end
    localWaitForComplete(OSCobject);

end

