%rectangular_command用來輸出方波振福
%輸入：方波週期、大小、現在時間
%輸出：振福
function [mag]=rectangular_command(period, magnitude, time)
        scale = mod(time, period);
        if scale < period/2
            mag = magnitude;
        else
            mag = -magnitude;
        end
end