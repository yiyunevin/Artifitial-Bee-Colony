%% ���L�k�G��J PSi (fitness �� rank selection)
% �o�� index
function y = Roulette(x)
    colSum = cumsum(x);
    k = rand;
    y = find( k <= colSum,1,'first');
end