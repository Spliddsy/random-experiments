clear; clc;

% User Settings
k = 100;
max_trials = 100000 * k;
take_a_picture_every_blank_frames = 10;
rate_of_growth = 0.01;
rate_cap = 1000;

% Preliminary Parameters
time_limit = k;
i = 25;
j = 13;
dim = 2;
image_index = 0;
frame_instant = take_a_picture_every_blank_frames;
growth_time = (0.2^2)*exp(4) ;

% Loop Start
P = zeros(k+1);
for trial = 1:max_trials
for time = 1:time_limit
    x = rand;

    if (x < ((i + j) / (2*k))) && (i > 0 || j > 0) % Check to move down
        x = rand;
        if x < 0.5
            if i < 1
                j = j - 1;
            else
                i = i - 1;
            end
        else
            if j < 1
                i = i - 1;
            else
                j = j - 1;
            end
        end

    elseif (i + j < k + 1) && (i < k || j < k)
        x = rand;
        if x < 0.5
            if (i+j) == k
            elseif i == k
                j = j + 1;
            else
                i = i + 1;
            end
        else
            if (i+j) == k
            elseif j == k
                i = i + 1;
            else
                j = j + 1;
            end
        end
    end
end

P(k+1-i,j+1) = P(k+1-i,j+1) + 1;

if mod(trial,frame_instant) == 0
    if frame_instant < rate_cap
        growth_time = growth_time + 1;
        frame_instant = ceil(frame_instant * log(growth_time));
    end
    figure(1);
    subplot(1,1,1);
    imagesc(P);
end
end

P = P / max_trials;


%%
% MK=zeros(10,10);
% 
% MK(1,2) = 1/2;
% MK(1,5) = 1/2;
% 
% MK(2,1) = 1/6;
% MK(2,2) = 1/6;
% MK(2,3) = 2/6;
% MK(2,6) = 2/6;
% 
% MK(3,2) = 2/6;
% MK(3,3) = 2/6;
% MK(3,4) = 1/6;
% MK(3,7) = 1/6;
% 
% MK(4,3) = 3/6;
% MK(4,4) = 3/6;
% 
% MK(5,1) = 1/6;
% MK(5,5) = 1/6;
% MK(5,6) = 2/6; 
% MK(5,8) = 2/6;
% 
% MK(6,2) = 2/6;
% MK(6,5) = 2/6;
% MK(6,7) = 1/6; 
% MK(6,9) = 1/6;
% 
% MK(7,3) = 3/6;
% MK(7,6) = 3/6;
% 
% MK(8,5) = 2/6;
% MK(8,8) = 2/6;
% MK(8,9) = 1/6;
% MK(8,10)= 1/6;
% 
% MK(9,6) = 3/6;
% MK(9,8) = 3/6;
% 
% MK(10,8)= 3/6;
% MK(10,10)=3/6;
% 
% figure(2);
% imagesc(MK);
