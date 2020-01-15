function OSCsetSampleRate( OSCobject,SampleRates )
%OSCSETTIMESCALE set time scale （sample rate）设置采样率
%   OSCobject：oscilloscope object 
%   SampleRates ： Sample rate [sample per second]
%   原理 一个每个 timescale 对应 一个 采样率 ，因此 给定 某个采样率，取 能采集到 
%   点数最多的 那个 timescale 作为 需要设定的 timescale，因为 示波器只能设定timescale
%    AvailableSampleRates   10M     40M     50M     62.5M   80M 
%                           100M    125M    200M    250M    400M 
%                           500M    1G      2G      5G      10G 
%                           20G 
%% 请自行添加频率 (注 这个 与 示波器 型号有关)
    AvailableSampleRates = [1e7 4e7 5e7 6.25e7 8e7 1e8 1.25e8 2e8 2.5e8 4e8 ...
        5e8 1e9 2e9 5e9 1e10 2e10 ];
    %% TimeScale = 2e6 /sample rate / 10 *1000
    AvailableTimeScale   = [ 20.0000 5.0000 4.0000 3.2000 2.5000 2.0000 1.6000 ...
        1.0000 0.8000 0.5000 0.4000 0.2000 0.1000 0.0400 0.0200 0.0100];  %% 单位 ms
    index = find(AvailableSampleRates == SampleRates, 1);
    if isempty(index)
        disp('your input sample rates is not supported')
    else
        fprintf(OSCobject,[':TIMebase:SCALe ',num2str(AvailableTimeScale(index)),'ms']);
        pause(3e-1);
    end
    localWaitForComplete(OSCobject);

end

