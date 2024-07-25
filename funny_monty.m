% I kinda just wanted to code to Monty Hall problem because it seemed fun
% By JRW 5/1/2024
max_tests = 1000000;

prizes_stay = 0;
prizes_change = 0;
for k = 1:max_tests
    possibilities = 1:3;
    doors = [0,0,0];
    prize_index = randi(3);
    doors(prize_index) = 1;
    duds = find(doors == 0);

    selection = randi(3);
    non_selected_duds = duds(duds ~= selection);
    if length(non_selected_duds) > 1
        non_selected_duds = non_selected_duds(randi(2));
    end

    new_selection = setdiff(possibilities, [selection non_selected_duds]);

    if doors(selection) == 1
        prizes_stay = prizes_stay + 1;
    end
    if doors(new_selection) == 1
        prizes_change = prizes_change + 1;
    end
end
success_rate_staying = prizes_stay / max_tests
success_rate_changing = prizes_change / max_tests

