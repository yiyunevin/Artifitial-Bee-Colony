% Cost Function ver. 3
function [profit] = Cost_function_ABC(inp, t_ini, t_accumu, smp_accumu,...
    theta, dtheta, theta_desire, x, dx,...
    M, m, L, f_max ,mu_c, mu_p, g, period, magnitude)

    theta_err_accumu = 0; % accumulation of errors
    w1 = 0.5; w2 = 0.5; % weight for theta and x respectively
    len = (t_accumu - t_ini)/smp_accumu + 1; % number of rounds of accumulation
    tE = zeros(len, 1); xE = zeros(len, 1); % save data of errors
    sum_tE = 0; sum_xE = 0; % sum of errors
    t = t_ini; % conting of time for rectangular wave / x desire
    
    for i= 1:len
        %% PID part1
        x_desire = rectangular_command(period, magnitude, t); % square wave
        t = t + smp_accumu;
        
        %% ²Ö¥[ Accumulation
        theta_err = theta -theta_desire;
        x_err = x - x_desire;
        
        %% PID part2       
        % Update u_theta and u_x
        tE(i) = theta_err;
        xE(i) = x_err;
        sum_tE = sum_tE + theta_err;
        sum_xE = sum_xE + x_err;
        [u_theta_err, ux_err] = PID_controller(i, xE, tE, sum_xE, sum_tE, inp, smp_accumu);

        theta_err_accumu = theta_err_accumu + w1 * abs(theta_err) + w2 * abs(x_err);
  
        % Update f and keep it in the range
        f = change_f(f_max, u_theta_err, ux_err);

        % Update parameters about x and theta
        [x, dx, theta, dtheta] = update_theta_and_x...
            (x, dx, f, M, m, L, theta, dtheta, mu_c, mu_p, g, smp_accumu);
    end
    profit = theta_err_accumu;
end