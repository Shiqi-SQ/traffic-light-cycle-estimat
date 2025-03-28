import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.fft import fft

# 读取数据
data = pd.read_csv('A1.csv') # 数据文件名 data.csv
times = data['time'].values
xs = data['x'].values
ys = data['y'].values

# 模拟定位误差
sigma = 5 # 定位误差的标准差
err_x = np.random.normal(0, sigma, len(xs))
err_y = np.random.normal(0, sigma, len(ys))
xs = xs + err_x
ys = ys + err_y

# 计算速度
velocities = np.sqrt(np.diff(xs)**2 + np.diff(ys)**2) / np.diff(times)

# 识别停车时刻
epsilon = 0.5 # 速度阈值
stop_indices = np.where(velocities < epsilon)[0] + 1 # 加 1 是因为 diff 减少了一个元素

# 分析停车时间
stop_times = times[stop_indices]
stop_durations = np.diff(stop_times)
stop_durations = stop_durations[stop_durations < 10] # 排除非红灯引起的短暂停车

# 傅里叶变换估计周期
n = len(stop_durations)
yf = fft(stop_durations)
xf = np.linspace(0.0, 1.0/(2.0 * np.mean(np.diff(times))), n//2)
yf_abs = 2.0/n * np.abs(yf[:n//2])

# 找到峰值频率对应的周期
peak_index = np.argmax(yf_abs)
frequency = xf[peak_index]
period = 1 / frequency

# 输出周期
print('Estimated traffic light cycle: {:.2f} seconds'.format(period))

# 绘制停车时间 傅里叶变换结果
plt.figure(figsize=(12,6))
plt.subplot(2,1,1)
plt.plot(stop_times[:-1], stop_durations, 'b.-')
plt.title ('title')
plt.xlabel('Times(s)')
plt.ylabel('Duration(s)')

plt.subplot(2,1,2)
plt.plot(xf,yf_abs,'r.-')
plt.title('FFT')
plt.xlabel('Frequency(HZ)')
plt.ylabel('Mag')
plt.show()