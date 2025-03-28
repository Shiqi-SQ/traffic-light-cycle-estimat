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

车辆轨迹数据X = cell(length(唯一车辆ID), 1);
车辆轨迹数据Y = cell(length(唯一车辆ID), 1);

for t = i_time'
    当前_time = (表列_time == t);
    当前_X = 表列_X(当前_time);
    当前_Y = 表列_Y(当前_time);
    当前_ID = 表列_ID(当前_time);

    for i = 1:length(当前_ID)
        id = 当前_ID(i);
        id_index = find(唯一车辆ID == id);
        车辆轨迹数据X{id_index} = [车辆轨迹数据X{id_index}, 当前_X(i)];
        车辆轨迹数据Y{id_index} = [车辆轨迹数据Y{id_index}, 当前_Y(i)];
    end
    
    hold on;
    for idx = 1:length(唯一车辆ID)
        plot(车辆轨迹数据X{idx}, 车辆轨迹数据Y{idx}, 'Color', [0 0 1], 'LineWidth', 2);
    end
    axis equal;
    xlim([min(表列_X), max(表列_X)]);
    ylim([min(表列_Y), max(表列_Y)]);
end
