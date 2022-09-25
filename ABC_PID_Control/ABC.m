%% Artificial Bee Colony Algorithm  ver. 2020.05.31
% �ĤG�椧�᪺�ѼƳ��O�� cost function (�M PID ����) �Ϊ�
function [K, costt, time_use, mean_fitness] = ABC(numSN, D, Xmax, Xmin, maxIter, t_ini, t_accumu, smp_accumu,...
    theta, dtheta, theta_desire, x, dx,...
    M, m, L, f_max ,mu_c, mu_p, g, period, magnitude)
%% �Ѽ� Parameter
numOnlooker = numSN;
abandonCount = zeros(numSN,1); 
dimRange = [1 D];
dimRange2 = [1 1];
Cost = @(inp) Cost_function_ABC(inp, t_ini, t_accumu, smp_accumu,...
        theta, dtheta,theta_desire, x, dx,...
        M, m, L, f_max ,mu_c, mu_p, g, period, magnitude);  % cost cunction ²�ƩI�s
% �i�հѼ�
limit = numSN * D; % limit for abandon
frac_1 = 0.9; frac_2 = 0.1; % �]�w�ӫ]���W�U��
% for data saving
costt = zeros(maxIter, 1);
it_fitness = zeros(maxIter, 1);

% record time
tic
%% STEP 1�G��l�ڸs Initialization - �o��̪쪺 Kp, Ki, Kd
SN.Position = []; SN.Profit = [];
BestSol.Profit = inf;  % �D�̤j�ȡA�ҥH�_��]�Ȭ� -inf
colony = repmat(SN,numSN,1);
for i = 1:numSN
    for d = 1:D
         colony(i).Position(d) = Xmin(d) + (Xmax(d)-Xmin(d)) * unifrnd(0, 1,dimRange2);
    end
    colony(i).Profit = Cost(colony(i).Position); 
    if colony(i).Profit <= BestSol.Profit 
        BestSol = colony(i);
    end
end

%% Iteration
for it = 1:maxIter
%% Generate the Nectar    
    for i = 1:numSN
        % Random k (not equal to i)
        K = [1:i-1 i+1:numSN];
        k = K(randi([1 length(K)]));
        % Random phi
        phi = unifrnd((-1), 1,dimRange);
        % new information formula(2.2)
        newBee.Position = colony(i).Position + phi.*(colony(i).Position - colony(k).Position);
        % keep in range
        for d = 1:D
            if newBee.Position(d) > Xmax(d)
                newBee.Position(d) = unifrnd((Xmin(d)+frac_1*(Xmax(d)-Xmin(d))), Xmax(d));
            elseif newBee.Position(d) < Xmin(d)
                newBee.Position(d) = unifrnd(Xmin(d), (Xmin(d)+frac_2*(Xmax(d)-Xmin(d))));
            end
        end
        newBee.Profit = Cost(newBee.Position);
        % Compare
        if newBee.Profit <= colony(i).Profit
            colony(i) = newBee;
        else
            abandonCount(i) = abandonCount(i) + 1;
        end
    end
    
 %% STEP 2: Onlooker
    % selection probability
    [p, fit_mean] = fitness(numSN, colony);
    for j = 1:numOnlooker 
        % Select Source Site
        i = Roulette(p);
        % Random k
        K = [1:i-1 i+1:numSN]; 
        k = K(randi([1 length(K)]));
        % Random phi
        phi = unifrnd((-1), 1,dimRange);
        % new information formula(2.2)
        newBee.Position = colony(i).Position + phi.*(colony(i).Position - colony(k).Position);
        % keep in range
        for d = 1:D 
            if newBee.Position(d) > Xmax(d)
                newBee.Position(d) = unifrnd((Xmin(d)+frac_1*(Xmax(d)-Xmin(d))), Xmax(d));
            elseif newBee.Position(d) < Xmin(d)
                newBee.Position(d) = unifrnd(Xmin(d), (Xmin(d)+frac_2*(Xmax(d)-Xmin(d))));
            end
        end
        newBee.Profit = Cost(newBee.Position);
        % Compare
        if newBee.Profit <= colony(i).Profit
            colony(i) = newBee;
        else
            abandonCount(i) = abandonCount(i) + 1; 
        end
    end
 %% STEP 3:  Scout
 % Nectar/ Profitability �������ƶW�L limit�Aabandon �ôM��s food source �Ӵ��N
    for i = 1:numSN
        if abandonCount(i) >= limit
            for d = 1:D
                colony(i).Position(d) = Xmin(d) + (Xmax(d)-Xmin(d)) * unifrnd(0, 1,dimRange2);
            end
            colony(i).Profit = Cost(colony(i).Position); 
            abandonCount(i) = 0;
        end
    end
%% the Best Solution�F�� generation ���̨θ�
    for i = 1:numSN
        if colony(i).Profit <= BestSol.Profit % reciprocal => choose the largest one
            BestSol = colony(i);
        end
    end
    % save data
    costt(it) = BestSol.Profit;
    it_fitness(it) = fit_mean;
    % show result each iteration
    disp(['ABC: iteration ' num2str(it)  ': [Kp] = ' num2str(BestSol.Position(1)) ', [Ki] = ' num2str(BestSol.Position(2)) ', [Kd] = ' num2str(BestSol.Position(3)) ',[Kp2] = ' num2str(BestSol.Position(4)) ', [Ki2] = ' num2str(BestSol.Position(5)) ', [Kd2] = ' num2str(BestSol.Position(6))]);
end % end itration
time_use = toc;
mean_fitness = mean(it_fitness);
K = BestSol.Position;
end