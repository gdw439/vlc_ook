function [ K1,K2 ] = PLL_K_calc( BnTs,Xi,N,Kp,K0 )
%UNTITLED5 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
K1 = (4*Xi/N)*(BnTs/(Xi+1/(4*Xi)))/(1+2*Xi/N*(BnTs/(Xi+1/(4*Xi)))+(BnTs/(N*(Xi+1/(4*Xi)))^2))/Kp/K0;
K2 = (4*Xi/N^2)*(BnTs/(Xi+1/(4*Xi)))^2/(1+2*Xi/N*(BnTs/(Xi+1/(4*Xi)))+(BnTs/(N*(Xi+1/(4*Xi)))^2))/Kp/K0;

end

