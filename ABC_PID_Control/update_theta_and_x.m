%% 更新 theta 與 x 的相關參數 (根據題目)
function [x,dx,theta,dtheta]=update_theta_and_x...
    (x, dx, f, M, m, L,...
    theta, dtheta, mu_c, mu_p, g, sampling_time)
    num1 = (M+m)*g*sin(theta);
    num2 = -cos(theta)*(f+m*L*(dtheta^2*sin(theta))-(M+m)*mu_c*sign(dx));
    num3 = -mu_p*(M+m)*dtheta/(m*L);
    den = 4/3*(M+m)*L-m*L*(cos(theta))^2;
    %更新ddtheta及ddx (依講義式子)
    ddtheta = (num1+num2+num3)/den;
    ddx = (f+m*L*(dtheta^2*sin(theta)-ddtheta*cos(theta)))/(M+m)-mu_c*sign(dx);
    %更新dtheta及dx (積分)
    dtheta = dtheta + ddtheta * sampling_time;
    theta = theta + dtheta * sampling_time;
    %更新theta及x (積分)
    dx = dx + ddx * sampling_time;
    x = x + dx * sampling_time;
end