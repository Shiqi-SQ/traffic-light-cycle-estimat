data = readtable('A1_acc.csv');

unique_vehicles = unique(data.vehicle_id);

figure;
hold on;

acc_levels = [-2, 0, 2];
colors = [1, 0, 0; 1, 1, 1; 0, 1, 0];

acc_range = linspace(-2, 2, 256);
R = interp1(acc_levels, colors(:,1), acc_range, 'linear');
G = interp1(acc_levels, colors(:,2), acc_range, 'linear');
B = interp1(acc_levels, colors(:,3), acc_range, 'linear');
cmap = [R' G' B'];

colormap(cmap);
clim([-2 2]);

for i = 1:length(unique_vehicles)
    vehicle_id = unique_vehicles(i);

    vehicle_data = data(data.vehicle_id == vehicle_id, :);

    scatter(vehicle_data.time, repmat(i, size(vehicle_data.time)), 36, vehicle_data.acc, 'filled');
    drawnow;
end

xlabel('Time (s)');
ylabel('Vehicle ID');
yticks(1:length(unique_vehicles));
yticklabels(unique_vehicles);
title('Vehicle Acceleration Visualization');
colorbar;

ylim([0 length(unique_vehicles)+1]);

hold off;
