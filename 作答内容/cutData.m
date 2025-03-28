files = 'A1.csv';
calc_ratio = 0.8;

data = readtable(files);
data = sortrows(data, 'time');

n_rows = size(data, 1);
n_calc = floor(n_rows * calc_ratio);

calc_data = data(1:n_calc, :);
vefy_data = data(n_calc+1:end, :);
calc_filename = strrep(files, '.csv', '_calc.csv');
vefy_filename = strrep(files, '.csv', '_vefy.csv');
writetable(calc_data, calc_filename);
writetable(vefy_data, vefy_filename);
