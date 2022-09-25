%使用梯形積分法
function [sum] = integral(previous_sum ,previous_value,value, sampling_time)     
  sum = previous_sum + 0.5 * (previous_value + value) * sampling_time;  
end