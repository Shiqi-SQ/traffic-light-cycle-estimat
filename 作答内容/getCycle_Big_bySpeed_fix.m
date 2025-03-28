data = readtable('A1_speed.csv');

active_vehicles = containers.Map('KeyType', 'double', 'ValueType', 'any');
red_light_waiting = containers.Map('KeyType', 'double', 'ValueType', 'any');
green_starts = [];

zero_speed_threshold = 8;

last_time = data.time(1);
last_speeds = containers.Map('KeyType', 'double', 'ValueType', 'double');

for i = 1:height(data)
    current_time = data.time(i);
    vehicle_id = data.vehicle_id(i);
    speed = data.speed(i);

    if ~isKey(active_vehicles, vehicle_id) && speed > 0
        active_vehicles(vehicle_id) = struct('zero_time_start', NaN, 'zero_duration', 0);
        continue;
    end

    if isKey(active_vehicles, vehicle_id)
        vehicle_info = active_vehicles(vehicle_id);
        if speed <= 0.5
            if isnan(vehicle_info.zero_time_start)
                vehicle_info.zero_time_start = current_time;
                vehicle_info.zero_duration = 1;
            else
                if current_time == last_time + 1
                    vehicle_info.zero_duration = vehicle_info.zero_duration + 1;
                else
                    vehicle_info.zero_duration = 1;
                end
            end
        else
            if vehicle_info.zero_duration >= zero_speed_threshold
                red_light_waiting(vehicle_id) = vehicle_info.zero_time_start;
            end
            vehicle_info.zero_time_start = NaN;
            vehicle_info.zero_duration = 0;

            if isKey(red_light_waiting, vehicle_id)
                green_starts = [green_starts; current_time];
                remove(red_light_waiting, vehicle_id);
            end
        end
        active_vehicles(vehicle_id) = vehicle_info;
    end

    last_time = current_time;
    last_speeds(vehicle_id) = speed;
end

green_starts

if length(green_starts) > 1
    cycles = diff(green_starts);

    median_cycle = median(cycles);
    acceptable_range = median_cycle * 0.5;
    filtered_cycles = cycles(abs(cycles - median_cycle) <= acceptable_range);

    if ~isempty(filtered_cycles)
        average_cycle = mean(filtered_cycles);
        fprintf('平均周期：%.2f 秒\n', average_cycle);
    else
        fprintf('没有足够的数据计算平均周期。\n');
    end
else
    fprintf('未能检测到足够的绿灯启动时以计算周期。\n');
end
