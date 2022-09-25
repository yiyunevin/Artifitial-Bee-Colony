%% fitness function base on rank selection
% 來自許多 paper 共同的 fitness function
% 轉換成 rank = 1, 2, 3, ...
function [p] = fitness_rank(numSN, colony)
    fit = zeros(numSN,1);
    for i = 1:numSN
        if(colony(i).Profit < 0)
            fit(i) = 1 + abs(colony(i).Profit);
        else
            fit(i) = 1/(1 + colony(i).Profit);
        end
    end
    fit_c = cumsum(fit);
    fit_normal = fit./fit_c(10);
    fit_rank = fit_normal./min(fit_normal);
    p = fit_rank/sum(fit_rank);  % selection probability
end