cycle_length = 105; % 手动输入
first_cycle_start = 105; % 手动输入

data = readtable('A1.csv');

times = data.time;
vehicle_ids = data.vehicle_id;
x_coords = data.x;
y_coords = data.y;

unique_times = unique(times);
unique_vehicles = unique(vehicle_ids);

figure;
axis equal;
xlim([min(x_coords), max(x_coords)]);
ylim([min(y_coords), max(y_coords)]);
hold on;

vehicle_plots = containers.Map('KeyType', 'int32', 'ValueType', 'any');

cycle_text = text(mean(xlim), max(ylim), 'Cycle: Initializing...', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', 'FontSize', 12, 'BackgroundColor', 'white');

current_cycle_start = first_cycle_start;
current_cycle_end = current_cycle_start + cycle_length;

for t = unique_times'
    if t >= current_cycle_end
        current_cycle_start = current_cycle_end;
        current_cycle_end = current_cycle_start + cycle_length;
    end
    
    set(cycle_text, 'String', sprintf('当前时：%d s, 下个绿灯：%d s', t, current_cycle_start + cycle_length));
    
    current_time_mask = (times == t);
    current_x = x_coords(current_time_mask);
    current_y = y_coords(current_time_mask);
    current_ids = vehicle_ids(current_time_mask);
    
    for i = 1:length(current_ids)
        id = current_ids(i);
        if isKey(vehicle_plots, id)
            plot_handle = vehicle_plots(id);
            set(plot_handle, 'XData', current_x(i), 'YData', current_y(i));
        else
            plot_handle = plot(current_x(i), current_y(i), 'o', 'MarkerSize', 10);
            vehicle_plots(id) = plot_handle;
        end
    end
    
    pause(0.03);
end

hold off;
