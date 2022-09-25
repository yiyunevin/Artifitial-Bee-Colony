%% fitness function base on fitness selection
% 來自許多 paper 共同的 fitness function
function [p, fit_mean] = fitness(numSN, colony)
    fit = zeros(numSN, 1);
    for i = 1:numSN
        if(colony(i).Profit < 0)
            fit_each = 1 + abs(colony(i).Profit);
        else
            fit_each = 1/(1 + colony(i).Profit);
        end
        fit(i) = fit_each;
    end
    fit_mean = mean(fit);
    p = fit/sum(fit);  % selection probability
end