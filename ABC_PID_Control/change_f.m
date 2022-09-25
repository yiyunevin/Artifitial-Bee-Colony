%% 改變 f，並確保 f 在範圍內
% 輸入:f_max 為題目規定
%      u_theta_err、ux_err 為 PID 控制器誤差
% 輸出：f  
function f = change_f(f_max, u_theta_err, ux_err)
    f = u_theta_err * f_max + 0.5 * ux_err;
    if f > f_max
        f = f_max;
    elseif f < -f_max
        f = -f_max;
    end
end