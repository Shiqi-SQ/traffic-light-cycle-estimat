files = 'A1.csv'
calc_ratio = 0.8;

data = readtable(files);
    
n_rows = size(data, 1);
n_calc = floor(n_rows * calc_ratio);
indices = randperm(n_rows);

calc_data = data(indices(1:n_calc), :);
vefy_data = data(indices(n_calc+1:end), :);
    
calc_data = sortrows(calc_data, 'time');
vefy_data = sortrows(vefy_data, 'time');
    
calc_filename = strrep(files, '.csv', '_calc.csv');
vefy_filename = strrep(files, '.csv', '_vefy.csv');
writetable(calc_data, calc_filename);
writetable(vefy_data, vefy_filename);
