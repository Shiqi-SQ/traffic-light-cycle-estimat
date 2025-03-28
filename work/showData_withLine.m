data = readtable('D.csv');

times = data.time;
vehicle_ids = data.vehicle_id;
x_coords = data.x;
y_coords = data.y;

unique_times = unique(times);

fig = figure;
axis equal;
xlim([min(x_coords), max(x_coords)]);
ylim([min(y_coords), max(y_coords)]);
hold on;

vehicle_trails = containers.Map('KeyType', 'int32', 'ValueType', 'any');

for id = unique(vehicle_ids)'
    vehicle_trails(id) = line('XData', [], 'YData', [], 'Color', [0 0 1], 'LineWidth', 2);
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

    % drawnow;
end
