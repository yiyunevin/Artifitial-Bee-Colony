%% ���� f�A�ýT�O f �b�d��
% ��J:f_max ���D�سW�w
%      u_theta_err�Bux_err �� PID ����~�t
% ��X�Gf  
function f = change_f(f_max, u_theta_err, ux_err)
    f = u_theta_err * f_max + 0.5 * ux_err;
    if f > f_max
        f = f_max;
    elseif f < -f_max
        f = -f_max;
    end
end