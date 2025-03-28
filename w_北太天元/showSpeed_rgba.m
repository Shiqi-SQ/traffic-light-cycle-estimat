data = readtable('A1_speed.csv');

unique_vehicles = unique(data.vehicle_id);
unique_times = unique(data.time);

figure;
hold on;

for i = 1:length(unique_vehicles)
    vehicle_id = unique_vehicles(i);

    vehicle_data = data(data.vehicle_id == vehicle_id, :);

    for j = 1:length(vehicle_data.time)
        alpha = max(0, min(1, vehicle_data.speed(j) / 10));
        
        scatter(vehicle_data.time(j), i, 20, 'k', 'filled', 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', alpha, 'Marker', 'o');

    end
end

xlabel('Time (s)');
ylabel('Vehicle ID');
yticks(1:length(unique_vehicles));
yticklabels(unique_vehicles);
title('Vehicle Speed Visualization');
xlim([min(unique_times) max(unique_times)]);
ylim([0 length(unique_vehicles)+1]);

hold off;
