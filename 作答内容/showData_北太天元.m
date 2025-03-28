轨迹数据 = csvread('A1.csv');

表列_time = 轨迹数据(:, 1);
表列_ID = 轨迹数据(:, 2);
表列_X = 轨迹数据(:, 3);
表列_Y = 轨迹数据(:, 4);

i_time = unique(表列_time);
唯一车辆ID = unique(表列_ID);

figure;
axis equal;
xlim([min(表列_X), max(表列_X)]);
ylim([min(表列_Y), max(表列_Y)]);
hold on;

数组_车辆ID = [];
车辆图形数组 = [];

for t = i_time'
    当前_time = (表列_time == t);
    当前_X = 表列_X(当前_time);
    当前_y = 表列_Y(当前_time);
    当前_ID = 表列_ID(当前_time);

    for i = 1:length(当前_ID)
        id = 当前_ID(i);
        index = find(数组_车辆ID == id);
        if isempty(index)
            图形句柄 = plot(当前_X(i), 当前_y(i), 'o', 'MarkerSize', 10);
            数组_车辆ID = [数组_车辆ID, id];
            车辆图形数组 = [车辆图形数组, 图形句柄];
        else
            图形句柄 = 车辆图形数组(index);
            set(图形句柄, 'XData', 当前_X(i), 'YData', 当前_y(i));
        end
    end
    
    pause(0.03);
end
