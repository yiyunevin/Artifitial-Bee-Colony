clc; clear; close all;
%% Artificial Bee Colony Algorithm
index = [6 7 8 11 12 16 22 24];   
dim = [30 30 30 30 30 2 4 30];
Xmax = [10 30 500 600 50 5 10 32.768];
Xmin = [-10 -30 -500 -600 -50 -5 0 -32.768];
limit = [2000 2000 1 600 5000 100 250 2000];
round = 50;
id = 1; % benchmark no.
iter = 2500;  
numSN = 50; % Number of Food Source = Population Size
numOnlooker = numSN; % Number of Onlookers
abandonLimit = limit(id); % Abandonment: Limit Cycle about Remainning at a Same Food Source
dimRange = [1 dim(id)];
%% data
ABSF_all = zeros(8,iter);
ABSF_last = zeros(8);
MBSF_last = zeros(8);
AVGT = zeros(8);
AMF = zeros(8);
LastMean = zeros(8);
LastSTDEV = zeros(8);
% load('ABC500.mat');
% load('record500.mat');
%% Each Rounds
% record
BestProfit = zeros(iter,round); 
MeanFit = zeros(iter, round); 
time = zeros(1, round); 
for r = 1:round
    tic
    abandonCount = zeros(numSN,1);    % Abandonment Counter (compared to limit)
       %% STEP1: Initialization
    % Food Source Struct 
    SN.Position = [];
    SN.Profit = [];
    % Initialize Best Solution Ever Found: want to find as small as possible
    BestSol.Profit = inf;
    % Initial Population
    colony = repmat(SN,numSN,1);
    for i = 1:numSN
        colony(i).Position = Xmin(id) + (Xmax(id)-Xmin(id))*unifrnd(0, 1,dimRange);
        colony(i).Profit = test_function(colony(i).Position, index(id), dim(id));
        if colony(i).Profit <= BestSol.Profit
            BestSol = colony(i);
        end
    end
%% Each iterations / generations
    for it = 1:iter
       %%  Generate Food Sources
        for i = 1:numSN
            % Random k 
            K = [1:i-1 i+1:numSN];   % range of k(not equal to i)
            k = K(randi([1 length(K)]));
            % Random phi
            phi = unifrnd(-1,+1,dimRange);
            % new information (2.2)
            newBee.Position = colony(i).Position + phi.*(colony(i).Position - colony(k).Position);
            if newBee.Position > Xmax(id)
                newBee.Position = Xmax(id);
            end
            if newBee.Position < Xmin(id)
                newBee.Position = Xmin(id);
            end
            newBee.Profit = test_function(newBee.Position, index(id), dim(id));
            % Compare
            if newBee.Profit <= colony(i).Profit
                colony(i)=newBee;
            else
                abandonCount(i)=abandonCount(i) + 1;    % the source doesn't be betterthe turn
            end
        end
%%  STEP2: Fitness Values
        fit = zeros(numSN,1);
        meanProfit = mean([colony.Profit]);
        for i = 1:numSN
            if(colony(i).Profit < 0)
                fit(i) = 1 + abs(colony(i).Profit);
            else
                fit(i) = 1/(1 + colony(i).Profit);
            end
           MeanFit(it, r) = mean(fit);
        end
        p = fit/sum(fit);  % selection probability
%% STEP3: Onlooker
        for j = 1:numOnlooker
            % Select Source Site
            i = Roulette(p);
            % (2.2)
            K = [1:i-1 i+1:numSN];
            k = K(randi([1 length(K)]));
            phi = unifrnd(-1,+1,dimRange);
            newBee.Position = colony(i).Position + phi.*(colony(i).Position - colony(k).Position);
            if newBee.Position > Xmax(id)
                newBee.Position = Xmax(id);
            end
            if newBee.Position < Xmin(id)
                newBee.Position = Xmin(id);
            end
            newBee.Profit = test_function(newBee.Position, index(id), dim(id));
            if newBee.Profit <= colony(i).Profit
                colony(i)=newBee;
            else
                abandonCount(i)=abandonCount(i) + 1;
            end
        end
%% STEP4:  Scout
        for i=1:numSN
            if abandonCount(i) >= abandonLimit
                % abandon the i th food source and find a new source instead
                colony(i).Position = Xmin(id) + (Xmax(id)-Xmin(id))*unifrnd(0, 1,dimRange);
                colony(i).Profit = test_function(colony(i).Position, index(id), dim(id));
                abandonCount(i)=0;
            end
        end
%% the Best Solution
        for i = 1:numSN
            if colony(i).Profit <= BestSol.Profit
                BestSol = colony(i);
            end
        end
        BestProfit(it, r) = BestSol.Profit;
        disp(['f: ' num2str(index(id)) '; Round ' num2str(r) '; Iteration ' num2str(it) ': Best Profitability = ' num2str(BestProfit(it, r))]);
    end % end itration
    time(r) = toc;
end % end round

Meann = mean(BestProfit, 2);
ABSF_all(id,:) = transpose(Meann); 
ABSF_last(id) = Meann(iter);
Medd = median(BestProfit, 2);
MBSF_last(id) = Medd(iter);
AVGT(id) = mean(time, 2);
AMF(id) = mean(mean(MeanFit));
LastMean(id) = mean(BestProfit(iter, :));
LastSTDEV(id) = std(BestProfit(iter, :));
% save('ABC500.mat', 'ABSF_all');
% save('record500.mat' , 'ABSF_last', 'MBSF_last', 'AVGT', 'AMF', 'LastMean', 'LastSTDEV');
% figure;
% plot(Meann,'LineWidth',2);
% xlabel('Iteration');
% ylabel('average best-so-far');
% grid on;

