% 读取数据
data = readtable('A1.csv');
times = data.time;
x_coords = data.x;
y_coords = data.y;

% 计算每一步的距离变化（欧氏距离）
dx = diff(x_coords);
dy = diff(y_coords);
distances = sqrt(dx.^2 + dy.^2);

% 生成二进制序列（0表示停车，1表示行驶）
% 假设停车时距离变化非常小，这里设置阈值为0.1米
binary_speed = [0; distances > 0.1];  % 第一个时间点默认为停车，保证长度与times一致

% 傅里叶变换
n = length(binary_speed);
Y = fft(binary_speed);
P2 = abs(Y/n);
P1 = P2(1:floor(n/2)+1);
f = (0:(floor(n/2))) / n;  % 频率轴

% 找到主要频率成分
[~, peak_index] = max(P1);
dominant_freq = f(peak_index);
if dominant_freq == 0
    fprintf('No periodic traffic light cycle detected due to zero or near-zero frequency.\n');
else
    dominant_period = 1 / dominant_freq;
    fprintf('Estimated traffic light cycle: %.2f seconds\n', dominant_period);
end

% 可视化
figure;
subplot(2,1,1);
plot(times, binary_speed, 'b');  % 使用完整的times和binary_speed
xlabel('Time (s)');
ylabel('Binary Speed');
title('Binary Speed based on Position Change (0=Stop, 1=Move)');

subplot(2,1,2);
plot(f, P1);
xlabel('Frequency (Hz)');
ylabel('|P1(f)|');
title('Single-Sided Amplitude Spectrum of Binary Speed');
if dominant_freq > 0
    xlim([0, 2*dominant_freq]);  % 确保有有效的频率范围
else
    xlim([0, 0.1]);  % 避免频率为0时出错
end
