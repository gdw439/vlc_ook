% by vortex
% for drawing eye
% 2018.11.8

function h = EyePattern(ss_ele_Rx, N_OS, cyc)
    cycle =  floor(length(ss_ele_Rx)/2/N_OS);
    h = figure();
    eye_wave = reshape(ss_ele_Rx(1:N_OS*2*cycle), N_OS*2, cycle);
    eye_wave = eye_wave';
    plot(1:N_OS*2, eye_wave, '-b');
    xlabel('Ê±¼ä');ylabel('·ù¶È');
    title('ÑÛÍ¼');
    path = sprintf('fig_a\\signalR %d.fig', cyc);
%     saveas(h,path);
end