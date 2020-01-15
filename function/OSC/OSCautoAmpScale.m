function OSCautoAmpScale( OSCobject,ChannelIndex )
%OSCAUTOAMPSCALE auto adjust amplitude(y axis) scale
%   OSCobject��oscilloscope object 
%   channelIndex �� the index of selected channel
%% �����Լ��޸��㷨
% �����뷨���� ��ȡ ��ǰ�ɼ������ź�VPP �� ��ǰscale
% �����ֵ
%  ʾ����y���ܹ��˸�����
%  ��ֵ���������ǵ� 6-8 ������֮��
CurrentAmpScale = OSCinquireAmpScale(OSCobject,ChannelIndex);
CurrentVpp = OSCinquireVpp(OSCobject,ChannelIndex);
ratio = CurrentVpp/CurrentAmpScale;    %% �����6-8 ֮��
while ratio > 8 || ratio<6   %% �����6-8 ֮��
%     if CurrentVpp >5 000
%         CurrentVpp
%         setAmpScale = 2*CurrentAmpScale;
%     else
        setAmpScale =CurrentAmpScale/ (7.5 / ratio) ;
%     end
    OSCsetAmpScale(OSCobject,ChannelIndex,[num2str(setAmpScale),'V']);
    CurrentAmpScale = OSCinquireAmpScale(OSCobject,ChannelIndex);
    CurrentVpp = OSCinquireVpp(OSCobject,ChannelIndex);
    ratio = CurrentVpp/CurrentAmpScale;    %% �����6-8 ֮��
end

