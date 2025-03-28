% 假设已加载数据
data=readtable('A1.csv');% 数据文件名 data.csv
times = data.time;
xs = data.x;
ys = data.y;

% 模拟定位误差
sigma=5;% 定位误差标准差
n_data = size(data,1);
err_x=sigma *randn(n_data, 1);
err_y=sigma *randn(n_data, 1);
xs = xs + err_x;
ys = ys + err_y;

% 计算速度
velocities=zeros(n_data-1, 1);
for i=2:n_data
    delta_x=xs(i)-xs(i-1);
    delta_y= ys(i) - ys(i-1);
    delta_t=times(i)-times(i-1);
    velocities(i-1)= sqrt(delta_x^2 + delta_y^2)/ delta_t;
end

% 识别停车时刻
epsilon=0.5; % 速度阈值
stop_indices = find(velocities < epsilon);

% 分析停车时间
stop_times = times(stop_indices);
stop_durations = diff(stop_times);
stop_durations = stop_durations(stop_durations<10);% 排除非红灯引起的短暂停车

% 傅里叶变换估计周期
Fs=1;% 采样频率为1Hz
nfft = length(stop_durations);
f= Fs*(0:(nfft/2))/nfft;
Y=fft(stop_durations, nfft);
P= abs(Y/nfft);

% 找到峰值频率对应的周期
[~,peak_index]= max(P(1:nfft/2+1));
frequency=f(peak_index);
period =1 /frequency;

% 输出周期
fprintf('Estimated traffie light cycle: %.2f seconds\n', period);

% 绘制停车时间和傅里叶变换结果
figure;
subplot(2,1,1);
plot(stop_times(l:end-l), stop_durations, 'b.-');
title('Detected Stop Durations');
xlabel('Time (s)');
ylabel('Duration (s)');

subplot(2,1,2);
plot(f, P(1:nfft/2+1), 'r.-');
title('Magnitude of FFT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');