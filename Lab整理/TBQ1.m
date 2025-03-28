% 文件路径定义
files = {'A1.csv', 'A2.csv', 'A3.csv', 'A4.csv', 'A5.csv'};

% 循环处理每个文件
for k = 1:length(files)
    % 读取CSV文件
    data = readtable(files{k});
    
    % 确保数据按时间和车辆ID排序
    data = sortrows(data, {'vehicle_id', 'time'});
    
    % 计算每秒的位移
    data.x_diff = [0; diff(data.x)];
    data.y_diff = [0; diff(data.y)];
    data.distance = sqrt(data.x_diff.^2 + data.y_diff.^2);
    data.speed = data.distance;  % 时间间隔假设为1秒
    
    % 定义停车和启动的速度阈值
    stop_threshold = 0.5;  % m/s
    start_threshold = 2.0;  % m/s

    % 检测停止和启动点
    data.is_stopped = data.speed <= stop_threshold;
    data.is_moving = data.speed >= start_threshold;

    % 找到停止和启动的时间点
    stop_times = data.time(data.is_stopped);
    start_times = data.time(data.is_moving);

    % 计算停止和启动时间点之间的差异来估计红灯和绿灯周期
    red_light_durations = [];
    green_light_durations = [];
    
    for i = 1:length(stop_times)-1
        if any(start_times > stop_times(i) & start_times < stop_times(i + 1))
            red_light_duration = min(start_times(start_times > stop_times(i))) - stop_times(i);
            red_light_durations = [red_light_durations; red_light_duration];
            green_light_duration = stop_times(i + 1) - max(start_times(start_times < stop_times(i + 1)));
            green_light_durations = [green_light_durations; green_light_duration];
        end
    end
    
    % 显示结果
    fprintf('File: %s\n', files{k});
    fprintf('Average Red Light Duration (seconds): %.2f\n', mean(red_light_durations));
    fprintf('Average Green Light Duration (seconds): %.2f\n', mean(green_light_durations));
end
