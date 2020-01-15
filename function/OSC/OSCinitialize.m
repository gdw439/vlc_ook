function [ OSCobject ] = OSCinitialize( visaAddr,visaAddrType )
%initializedOSC initialize OSC
%   visaAddr : OSC usb addr
%   output:
%      OSCobject��oscilloscope object
if nargin <1
    visaAddr = 'USB0::0x0957::0x1790::MY54390336::0::INSTR';
    visaAddrType = 0 ;
end

if visaAddrType == 0
	OSCobject = instrfind('Type', 'visa-usb', 'RsrcName', visaAddr, 'Tag', '');
	% Create the VISA-USB object if it does not exist
	% otherwise use the object that was found.
	if isempty(OSCobject)
    		OSCobject = visa('AGILENT', visaAddr);
	else
    		fclose(OSCobject);
    		OSCobject = OSCobject(1);
	end
	% Configure instrument object, obj1
	set(OSCobject, 'InputBufferSize', 4e6);
	% Configure instrument object, obj1
	set(OSCobject, 'OutputBufferSize', 512);
	% Connect to instrument object, obj1.
	fopen(OSCobject);
	OSCrun(OSCobject);
else
	if regexp(visaAddr,'(\d{1,3}\.){3}\d{1,3}')   %% ������ʽ ƥ�� ip��ַ����Ϊ��ʱ֧��ip����
    		visaADDR = [ 'TCPIP0::',visaADDR_IP,'::inst0::INSTR'];
    		tempObj = instrfind('Type', 'visa-tcpip', 'RsrcName', visaADDR, 'Tag', '');
    		if isempty(tempObj)   %% ����Ƿ��Ѿ����� DPobj ���󣬱����ͻ
        		OSCobject = visa( 'AGILENT',visaADDR ); %����VISA����
    		else
        		fclose(tempObj);
        		OSCobject = tempObj(1);
    		end
    		% Configure instrument object, obj1
		set(OSCobject, 'InputBufferSize', 4e6);
		% Configure instrument object, obj1
		set(OSCobject, 'OutputBufferSize', 512);
		% Connect to instrument object, obj1.
		fopen(OSCobject);
		OSCrun(OSCobject);
        
	else
    		error('��������ȷip��ַ����ʱ��֧���������ӷ�ʽ��')
    end
end

end
