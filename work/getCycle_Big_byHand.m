% 给定的变量
first_green_start = 175;  % 第一次绿灯的时间刻，单位秒
cycle_duration = 175;    % 红绿灯的大周期，单位秒

% 读取数据
data = readtable('A2_speed.csv');

unique_vehicles = unique(data.vehicle_id);
unique_times = unique(data.time);

figure;
hold on;

colormap(flipud(gray));
clim([0 20]);  % 设置颜色轴的范围

for i = 1:length(unique_vehicles)
    vehicle_id = unique_vehicles(i);
    vehicle_data = data(data.vehicle_id == vehicle_id, :);

    % 绘制散点图
    scatter(vehicle_data.time, repmat(i, size(vehicle_data.time)), 20, vehicle_data.speed, 'filled');
end

% 标记红绿灯周期
current_time = first_green_start;
while current_time <= max(unique_times)
    % 画黄线表示周期
    line([current_time, current_time], ylim, 'Color', 'yellow', 'LineWidth', 2);
    current_time = current_time + cycle_duration;  % 更新时间到下一个周期
end

xlabel('Time (s)');
ylabel('Vehicle ID');
yticks(1:length(unique_vehicles));
yticklabels(unique_vehicles);
title('Vehicle Speed Visualization');
colorbar;  % 显示颜色条

ylim([0 length(unique_vehicles)+1]);  % 设置y轴的范围

hold off;
