function y = Roulette(x)
    k = rand;
    colSum = cumsum(x);
    y = find( k <= colSum,1,'first');
end