clear; clc;
%% Interface
% COLLATZ CONJECTURE SIMULATOR
% Finds number of iterations to convergence and maximum number reached
% along the whole range.
%
% Jeremiah Rhys Wimer, 2/8/2024

% Settings
num_span = 10000;
take_n_logs_of_x = 0;
take_n_logs_of_y = 1;
outlier_filter_on = true;
filter_n_times_std_threshold = 2;

% Program
num_range = linspace(1,num_span,num_span);
iterations = zeros(length(num_range),1);
maximums = zeros(length(num_range),1);
for m = 1:length(num_range)
    [iterations(m),maximums(m)] = fun_collatz(num_range(m));
end

% Apply outlier filter
if outlier_filter_on
    std_iters = std(iterations);
    std_maxes = std(maximums);
    outliers_iters = abs(iterations - mean(iterations)) > filter_n_times_std_threshold * std_iters;
    outliers_maxes = abs(maximums - mean(maximums)) > filter_n_times_std_threshold * std_maxes;
    iterations(outliers_iters) = NaN;
    maximums(outliers_maxes) = NaN;
end

% Apply logs of data
log_num_range = num_range;
log_iterations = iterations;
log_maximums = maximums;
if take_n_logs_of_x > 0
    flag = true;
    count = 0;
    while flag
        count = count + 1;
        log_num_range = log10(log_num_range);
        if count == take_n_logs_of_x
            flag = false;
        end
    end
end
if take_n_logs_of_y > 0
    flag = true;
    count = 0;
    while flag
        count = count + 1;
        log_iterations = log10(log_iterations);
        log_maximums = log10(log_maximums);
        if count == take_n_logs_of_y
            flag = false;
        end
    end
end

% Plot
subplot(2,2,1);
plot(num_range,iterations,".")
subplot(2,2,2);
plot(num_range,maximums,".")
subplot(2,2,3);
plot(log_num_range,log_iterations,".")
subplot(2,2,4);
plot(log_num_range,log_maximums,".")

%% Actual function
function [iters,max_num] = fun_collatz(num)
% This function finds the number of iterations before hitting a [1 2 4]
% wall. Change number of checks as needed.
% 
% Jeremiah Rhys Wimer, 2/8/2024

checks  = 1;

flag = true;
num_mem = zeros(1,3*checks);
test_vec = [1,2,4];
test_vec = repmat(test_vec, 1, checks);
iters = 0;
max_num = 0;
while flag
    iters = iters + 1;
    if mod(num,2) == 0
        num = num / 2;
    else
        num = 3 * num + 1;
    end

    if num > max_num
        max_num = num;
    end

    num_mem = circshift(num_mem,1);
    num_mem(1) = num;

    if num_mem == test_vec
        flag = false;
    end
end

end