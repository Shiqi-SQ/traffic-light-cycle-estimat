data = readtable('D.csv');

times = data.time;
vehicle_ids = data.vehicle_id;
x_coords = data.x;
y_coords = data.y;

unique_times = unique(times);
unique_vehicles = unique(vehicle_ids);

fig = figure;
axis equal;
xlim([min(x_coords), max(x_coords)]);
ylim([min(y_coords), max(y_coords)]);
hold on;

colors = lines(numel(unique_vehicles)) * 0.9;

vehicle_trails = containers.Map('KeyType', 'int32', 'ValueType', 'any');
color_index = 1;

for id = unique_vehicles'
    vehicle_trails(id) = line('XData', [], 'YData', [], 'Color', colors(color_index, :), 'LineWidth', 2);
    if color_index < size(colors, 1)
        color_index = color_index + 1;
    else
        color_index = 1;
    end
end

for t = unique_times'
    current_time_mask = (times == t);
    current_x = x_coords(current_time_mask);
    current_y = y_coords(current_time_mask);
    current_ids = vehicle_ids(current_time_mask);
    
    for i = 1:length(current_ids)
        id = current_ids(i);
        plot_handle = vehicle_trails(id);
        existingX = get(plot_handle, 'XData');
        existingY = get(plot_handle, 'YData');
        updatedX = [existingX, current_x(i)];
        updatedY = [existingY, current_y(i)];
        set(plot_handle, 'XData', updatedX, 'YData', updatedY);
    end
    
    drawnow;
end
