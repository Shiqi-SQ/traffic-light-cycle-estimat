data = readtable('A1.csv');

data.speed = zeros(height(data), 1);

for vid = unique(data.vehicle_id)'
    idx = data.vehicle_id == vid;
    vehicle_data = data(idx, :);
    
    diffs = [0, 0; diff(vehicle_data.x), diff(vehicle_data.y)];
    distances = sqrt(diffs(:,1).^2 + diffs(:,2).^2);
    dt = [1; diff(vehicle_data.time)];
    speeds = distances ./ dt;

    data.speed(idx) = speeds;
end

output_data = data(:, {'time', 'vehicle_id', 'speed'});
writetable(output_data, 'A1_speed.csv');