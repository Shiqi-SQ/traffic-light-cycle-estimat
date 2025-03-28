data = readtable('A1_speed.csv');

active_vehicles = containers.Map('KeyType', 'double', 'ValueType', 'any');
red_light_durations = [];

zero_speed_threshold = 8;

for i = 1:height(data)
    current_time = data.time(i);
    vehicle_id = data.vehicle_id(i);
    speed = data.speed(i);

    if ~isKey(active_vehicles, vehicle_id)
        active_vehicles(vehicle_id) = struct('zero_time_start', NaN, 'zero_duration', 0, 'waiting_for_red', false, 'red_start_time', NaN);
    end

    vehicle_info = active_vehicles(vehicle_id);
    
    if speed <= 0.5
        if isnan(vehicle_info.zero_time_start)
            vehicle_info.zero_time_start = current_time;
            vehicle_info.zero_duration = 1;
        else
            if current_time == data.time(i-1) + 1
                vehicle_info.zero_duration = vehicle_info.zero_duration + 1;
            else
                vehicle_info.zero_time_start = current_time;
                vehicle_info.zero_duration = 1;
            end
        end
    else
        if vehicle_info.zero_duration >= zero_speed_threshold && vehicle_info.waiting_for_red
            red_light_durations = [red_light_durations, current_time - vehicle_info.red_start_time];
            vehicle_info.waiting_for_red = false;
        end
        vehicle_info.zero_time_start = NaN;
        vehicle_info.zero_duration = 0;
    end

    if vehicle_info.zero_duration >= zero_speed_threshold && ~vehicle_info.waiting_for_red
        vehicle_info.waiting_for_red = true;
        vehicle_info.red_start_time = vehicle_info.zero_time_start;
    end

    active_vehicles(vehicle_id) = vehicle_info;
end

if ~isempty(red_light_durations)
    average_red_duration = mean(red_light_durations);
    max_red_duration = max(red_light_durations);
    fprintf('平均红灯长度：%.2f 秒\n', average_red_duration);
    fprintf('红灯最长长度：%.2f 秒\n', max_red_duration);
    
else
    fprintf('没有足够的数据计算红灯长度。\n');
end
