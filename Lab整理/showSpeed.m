data = readtable('A1_speed.csv');

unique_vehicles = unique(data.vehicle_id);
unique_times = unique(data.time);

figure;
hold on;

colormap(flipud(gray));
clim([0 20]);

for i = 1:length(unique_vehicles)
    vehicle_id = unique_vehicles(i);

    vehicle_data = data(data.vehicle_id == vehicle_id, :);

    scatter(vehicle_data.time, repmat(i, size(vehicle_data.time)), 20, vehicle_data.speed, 'filled');

    % drawnow;
end

xlabel('时间刻 (s)');
ylabel('车辆ID');
yticks(1:length(unique_vehicles));
yticklabels(unique_vehicles);
title('每辆车在各个时间点的速度');
colorbar;

ylim([0 length(unique_vehicles)+1]);

hold off;
