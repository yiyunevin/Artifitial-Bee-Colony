%rectangular_command�Ψӿ�X��i����
%��J�G��i�g���B�j�p�B�{�b�ɶ�
%��X�G����
function [mag]=rectangular_command(period, magnitude, time)
        scale = mod(time, period);
        if scale < period/2
            mag = magnitude;
        else
            mag = -magnitude;
        end
end