clc; close all; clear
%% Main fubction for ABC inverted pendulum problem  2020.05.31
%% 參數 Parameter - PID Contoller Part
% 可調參數
m = 0.1; % [0.1, 0.3]
L = 0.5; % [0.5, 1.5]
f_max = 80; % [-80, +80]
sampling_time = 0.01; % for plotting
% 固定參數
M = 1.1;     
g = 9.8;
mu_c = 0.1;  
mu_p = 0.01;
ti = 0; % 起始 / 結束時間
tf = 60; 

% desired theta
theta_desire = 0; 
dtheta_desire = 0; 
ddtheta_desire = 0;
% x_desire (方波)
dx_desire = 0;
ddx_desire = 0;
period = 20; 
magnitude = 0.5; 

%initial condition
theta = pi/6;  % (+)(-) pi/6 
dtheta = 0; 
ddtheta = 0;
x = 0; 
dx = 0; 
ddx = 0;
%% 參數 Parameter - ABC Part
round = 10; 
D = 6; % dimention
maxIter =10;   
numSN = 50; % population size
Xmax = [10 1 10 10 1 10]; 
Xmin = [0 0 0 0 0 0];
% For cost function - accumulation
t_ini = ti; % 累加起始時間
t_accumu = 60; % cost function 累加結束時間
smp_accumu = 0.01; % cost function 累加所用取樣時間

%% ABC演算法：求 K 值 Decide Kp, Ki, kd
% Control theta : Kp,  Ki,  Kd
% Control   x   : Kp2, Ki2, Kd2

% save data for reporter
BestCost = zeros(round, maxIter);
TimeCount = zeros(round, 1);
FitSave = zeros(round, 1);
K_save = zeros(round, D);

for r = 1:round
    [K, cost, time, fit] = ABC(numSN, D, Xmax, Xmin, maxIter, t_ini, t_accumu, smp_accumu,...
        theta, dtheta, theta_desire, x, dx,...
        M, m, L, f_max ,mu_c, mu_p, g, period, magnitude);
    
    BestCost(r, :) = cost;
    TimeCount(r) = time;
    FitSave(r) = fit;
    K_save(r, :) = K;
        
    disp(['ABC: Round ' num2str(r)  ': [Kp] = ' num2str(K(1)) ', [Ki] = ' num2str(K(2)) ', [Kd] = ' num2str(K(3)) ',[Kp2] = ' num2str(K(4)) ', [Ki2] = ' num2str(K(5)) ', [Kd2] = ' num2str(K(6))]);
end

% data recording for reporter
TimeAvg = mean(TimeCount);
ABSF = mean(BestCost);
AMF = mean(FitSave);
MBSF = median(BestCost);
MEAN = mean(BestCost(:, maxIter));
STDEV = std(BestCost(:, maxIter));
% save('ABCrecord.mat', 'BestCost', 'K_save', 'maxIter', 'ABSF', 'AMF', 'MBSF', 'MEAN', 'STDEV', 'TimeAvg');

%% 正式跑 PID 結果  PID Result
% save datas for plotting
x_save = []; 
theta_save = []; 
x_desire_save = []; 

% save datas of theta_error & x_error
% 事前宣告大小可以加快速度
len = (tf - tf)/sampling_time + 1;
tE = zeros(len, 1); 
xE = zeros(len, 1); 
sum_tE = 0; 
sum_xE = 0;
id = 0;

for t = ti:sampling_time:tf
    % desired x : rectangular wave
    x_desire = rectangular_command(period, magnitude, t); 
    
    % save datas
    x_save = [x_save x]; 
    theta_save = [theta_save theta]; 
    x_desire_save = [x_desire_save x_desire]; 
    
    % PID control
    id = id + 1;
    tE(id) = theta -theta_desire;
    xE(id) = x - x_desire;
    sum_tE = sum_tE + tE(id);
    sum_xE = sum_xE + xE(id);
    [u_theta_err, ux_err] = PID_controller(id, xE, tE, sum_xE, sum_tE, K, sampling_time);
    
    % change f = [-f_max, f_max]
    f =  change_f(f_max, u_theta_err, ux_err);

    % update
    [x, dx, theta, dtheta] = update_theta_and_x...
        (x, dx, f, M, m, L, theta, dtheta, mu_c, mu_p, g, sampling_time);
end

%% 繪圖 Plotting
plot_theta_and_x(x_save, theta_save, ti, sampling_time, tf, x_desire_save);
