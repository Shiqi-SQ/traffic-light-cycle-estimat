data = readtable('A1.csv');  % 加载数据

% 计算每个车辆在每个时间点的速度
unique_vehicles = unique(data.vehicle_id);
stop_intervals = [];

% 遍历每个车辆
for vid = unique_vehicles'
    v_data = data(data.vehicle_id == vid, :);
    v_data = sortrows(v_data, 'time');  % 按时间排序
    speeds = sqrt([0; diff(v_data.x)].^2 + [0; diff(v_data.y)].^2);  % 计算速度

    % 寻找连续的低速状态作为停车的证据
    low_speed_threshold = 1;  % 低速阈值，可以调整
    min_stop_duration = 8;  % 最小停车时间，单位为秒
    stop_times = find(speeds < low_speed_threshold);
    if ~isempty(stop_times)
        % 找出连续停车时间
        stop_diffs = diff(stop_times);
        stop_blocks = find([1; stop_diffs] > 1);
        stop_durations = diff([stop_blocks; length(stop_times)+1]);
        long_stops = stop_times(stop_blocks(stop_durations >= min_stop_duration));
        
        % 如果存在长时间停车，记录其开始和结束时间
        if ~isempty(long_stops)
            start_times = v_data.time(long_stops);
            stop_intervals = [stop_intervals; start_times];
        end
    end
end

% 分析停车时间的间隔
if length(stop_intervals) > 1
    stop_intervals = sort(stop_intervals);
    time_diffs = diff(stop_intervals);  % 时间差

    % 找到最常见的时间间隔
    [mode_val, mode_freq] = mode(time_diffs);  % 计算众数（最常见的周期）

    % 输出估计的周期
    fprintf('Estimated signal period: %d seconds (most frequent stopping interval)\n', mode_val);
else
    fprintf('Not enough data to estimate the signal period.\n');
end
