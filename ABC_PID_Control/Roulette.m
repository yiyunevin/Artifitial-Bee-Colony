%% 輪盤法：輸入 PSi (fitness 或 rank selection)
% 得到 index
function y = Roulette(x)
    colSum = cumsum(x);
    k = rand;
    y = find( k <= colSum,1,'first');
end