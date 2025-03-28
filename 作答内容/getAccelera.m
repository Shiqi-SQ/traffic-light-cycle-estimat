data = readtable('A1_speed.csv');

unique_vehicles = unique(data.vehicle_id);

acc_data = table([], [], [], 'VariableNames', {'time', 'vehicle_id', 'acc'});

for i = 1:length(unique_vehicles)
    vehicle_id = unique_vehicles(i);

    vehicle_data = data(data.vehicle_id == vehicle_id, :);

    vehicle_acc = diff(vehicle_data.speed);
    vehicle_acc = [NaN; vehicle_acc];

    vehicle_acc_table = table(vehicle_data.time, vehicle_data.vehicle_id, vehicle_acc, 'VariableNames', {'time', 'vehicle_id', 'acc'});
    acc_data = [acc_data; vehicle_acc_table];
end

writetable(acc_data, 'A1_acc.csv');
