% 读取CSV文件
data = readtable('A1.csv');

% 提取列，使用实际列名
times = data.time;
vehicle_ids = data.vehicle_id;
x_coords = data.x;
y_coords = data.y;

% 确定唯一的时间点和车辆ID
unique_times = unique(times);
unique_vehicles = unique(vehicle_ids);

% 初始化视频文件路径和VideoWriter对象
outputVideo = VideoWriter('traffic_animation.mp4', 'MPEG-4');
outputVideo.FrameRate = 10;  % 设置视频的帧率
open(outputVideo);

% 创建无边框的图形窗口
fig = figure('visible', 'off');
axis equal;
xlim([min(x_coords), max(x_coords)]);
ylim([min(y_coords), max(y_coords)]);
hold on;

% 用于保存每个车辆的图形句柄
vehicle_plots = containers.Map('KeyType', 'int32', 'ValueType', 'any');

% 循环通过每个时间点绘制车辆位置
for t = unique_times'
    current_time_mask = (times == t);
    current_x = x_coords(current_time_mask);
    current_y = y_coords(current_time_mask);
    current_ids = vehicle_ids(current_time_mask);

    % 清除之前的绘制内容
    cla;
    vehicle_plots = containers.Map('KeyType', 'int32', 'ValueType', 'any');  % 重置Map

    for i = 1:length(current_ids)
        id = current_ids(i);
        % 为每个车辆创建一个新的图形对象
        plot_handle = plot(current_x(i), current_y(i), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
        vehicle_plots(id) = plot_handle;
    end

    % 绘制当前帧并添加到视频
    drawnow;
    frame = getframe(fig);
    writeVideo(outputVideo, frame);
end

% 关闭VideoWriter对象
close(outputVideo);
close(fig); % 关闭图形窗口
