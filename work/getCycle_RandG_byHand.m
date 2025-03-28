first_green_start = 175;
red_duration = 40;
green_duration = 135;
% 86 89 - 88

% 读取数据
data = readtable('A2_speed.csv');

unique_vehicles = unique(data.vehicle_id);
unique_times = unique(data.time);

figure;
hold on;

colormap(flipud(gray));
caxis([0 20]);

for i = 1:length(unique_vehicles)
    vehicle_id = unique_vehicles(i);
    vehicle_data = data(data.vehicle_id == vehicle_id, :);
    scatter(vehicle_data.time, repmat(i, size(vehicle_data.time)), 20, vehicle_data.speed, 'filled');
end

% 标记红绿灯周期
cycle_length = red_duration + green_duration;
current_time = first_green_start;
while current_time <= max(unique_times)
    % 画绿灯开始的绿线
    line([current_time, current_time], ylim, 'Color', 'green', 'LineWidth', 2);
    % 计算绿灯结束时间
    green_end_time = current_time + green_duration;
    if green_end_time <= max(unique_times)
        % 画红灯开始的红线
        line([green_end_time, green_end_time], ylim, 'Color', 'red', 'LineWidth', 2);
    end
    % 更新下一个周期的开始时间
    current_time = current_time + cycle_length;
end

xlabel('Time (s)');
ylabel('Vehicle ID');
yticks(1:length(unique_vehicles));
yticklabels(unique_vehicles);
title('Vehicle Speed Visualization');
colorbar;

ylim([0 length(unique_vehicles)+1]);

hold off;
