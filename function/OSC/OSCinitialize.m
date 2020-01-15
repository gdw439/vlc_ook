function [ OSCobject ] = OSCinitialize( visaAddr,visaAddrType )
%initializedOSC initialize OSC
%   visaAddr : OSC usb addr
%   output:
%      OSCobject：oscilloscope object
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
	if regexp(visaAddr,'(\d{1,3}\.){3}\d{1,3}')   %% 正则表达式 匹配 ip地址，因为暂时支持ip连接
    		visaADDR = [ 'TCPIP0::',visaADDR_IP,'::inst0::INSTR'];
    		tempObj = instrfind('Type', 'visa-tcpip', 'RsrcName', visaADDR, 'Tag', '');
    		if isempty(tempObj)   %% 检查是否已经存在 DPobj 对象，避免冲突
        		OSCobject = visa( 'AGILENT',visaADDR ); %创建VISA对象
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
    		error('请输入正确ip地址（暂时不支持其他连接方式）')
    end
end

end
