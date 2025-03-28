% 读取数据
data = readtable('A1.csv');

% 获取唯一的车辆ID
vehicle_ids = unique(data.vehicle_id);

% 为了存储结果
all_stop_durations = [];

% 对每个车辆ID进行循环处理
for vid = vehicle_ids'
    % 选取当前车辆的数据
    vehicle_data = data(data.vehicle_id == vid, :);
    times = vehicle_data.time;
    xs = vehicle_data.x;
    ys = vehicle_data.y;

    % 模拟定位误差
    sigma = 5;
    n_data = height(vehicle_data);
    err_x = normrnd(0, sigma, n_data, 1);
    err_y = normrnd(0, sigma, n_data, 1);
    xs = xs + err_x;
    ys = ys + err_y;

    % 计算速度
    delta_xs = diff(xs);
    delta_ys = diff(ys);
    delta_ts = diff(times);
    velocities = sqrt(delta_xs.^2 + delta_ys.^2) ./ delta_ts;
    fprintf('Vehicle ID %d, Number of calculated velocities: %d\n', vid, length(velocities));

    % 识别停车时刻
    epsilon = 1.5;  % 调整速度阈值
    stop_indices = find(velocities < epsilon) + 1;

    % 分析停车时间
    stop_times = times(stop_indices);
    stop_durations = diff(stop_times);
    fprintf('Vehicle ID %d, Number of stop durations before filter: %d\n', vid, length(stop_durations));
    stop_durations = stop_durations(stop_durations < 30);  % 调整停车时间过滤条件

    % 汇总所有车辆的停车持续时间
    all_stop_durations = [all_stop_durations; stop_durations];
end

fprintf('Total number of stop durations after all processing: %d\n', length(all_stop_durations));

% 傅里叶变换估计周期
n = length(all_stop_durations);
if n < 2
    fprintf('Not enough data points to perform FFT.\n');
else
    yf = fft(all_stop_durations);
    Fs = 1 / mean(diff(times));  % 假设所有车辆的时间间隔大致相同
    xf = Fs * (0:(n/2-1)) / n;
    yf_abs = abs(yf(1:n/2)) * 2 / n;

    % 找到峰值频率对应的周期
    [~, peak_index] = max(yf_abs);
    frequency = xf(peak_index);

    if frequency == 0
        fprintf('No valid frequency found. Cannot compute period.\n');
    else
        period = 1 / frequency;
        fprintf('Estimated traffic light cycle: %.2f seconds\n', period);
    end
end
