function [u_theta_err, ux_err] = PID_controller(id, x_err, theta_err, sum_x_err, sum_theta_err, K, sampling_time)
    if id > 1
        theta_err_dot = (theta_err(id) - theta_err(id-1)) / sampling_time;
        x_err_dot = (x_err(id) - x_err(id-1)) / sampling_time;
    else
        theta_err_dot = 0;
        x_err_dot = 0;
    end
    u_theta_err = K(1) * theta_err(id) + K(2) * sum_theta_err * sampling_time + K(3) * theta_err_dot;
    ux_err = K(4) * x_err(id) + K(5) * sum_x_err * sampling_time + K(6) * x_err_dot;
end