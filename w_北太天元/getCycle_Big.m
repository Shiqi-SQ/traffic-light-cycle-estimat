data = readtable('A1_acc.csv');

unique_vehicles = unique(data.vehicle_id);

vehicle_last_acc = containers.Map('KeyType', 'double', 'ValueType', 'double');
for v = unique_vehicles'
    vehicle_last_acc(v) = 0;
end

green_starts = [];

data = sortrows(data, 'time');

time_window = 8; % 窗口大小

t_min = min(data.time);
t_max = max(data.time);
for t = t_min:time_window:t_max
    current_data = data(data.time >= t & data.time < t + time_window, :);
    
    window_start = false;
    for i = 1:height(current_data)
        vid = current_data.vehicle_id(i);
        acc = current_data.acc(i);
        
        if vehicle_last_acc(vid) == 0 && acc >= 1.8 % 加速阈值
            window_start = true;
        end

        vehicle_last_acc(vid) = acc;
    end

    if window_start
        green_starts = [green_starts; t];
    end
end

if length(green_starts) > 1
    cycles = diff(green_starts);
    mean_cycle = mean(cycles);
    fprintf('红绿灯平均总周期（秒）: %.2f\n', mean_cycle);
    fprintf('周期和对应的开始时间:\n');
    for idx = 1:length(cycles)
        fprintf('周期: %d 秒, 开始时间: %d\n', cycles(idx), green_starts(idx) + 5);
    end
else
    fprintf('未能检测到足够的绿灯启动时以计算周期。\n');
end
