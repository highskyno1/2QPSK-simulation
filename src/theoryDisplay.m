%{
    本代码用于仿真原理展示，
    仿真代码放到了main.m
%}
carrier_freq = 1e3;
SampleRate = 25*1e3;
SamplePoint = 25;

close all;
%用户码元
source = [-1 1 1 -1 -1];
figure;
stairs(source);
hold on;
%码元差分处理
source_diff = diffSource(source);
stairs(source_diff.*2);
title('用户码元')
legend('差分前','差分后');
set(gca,'YLim',[-3 3]);%Y轴的数据显示范围
%载波
carrier = carrierGen(carrier_freq,SampleRate,SamplePoint);
figure;
plot(carrier);
title('载波')
%调制
modulate = modulation(source_diff,carrier);
figure;
plot(modulate);
title('调制结果')

%接收滤波器
fcuts = [0 500 1500 2000]; %定义通带和阻带的频率
mags = [0 1 0];             %定义通带和阻带
devs = [0.1 0.1 0.1];      %定义通带或阻带的纹波系数
receive_filter = getFilter(fcuts,mags,devs,SampleRate);
figure;
freqz(modulate);
title('接收滤波器分析')

%鉴相滤波器
fcuts = [1500 2000]; %定义通带和阻带的频率
mags = [1 0];             %定义通带和阻带
devs = [0.1 0.1];      %定义通带或阻带的纹波系数
phase_filter = getFilter(fcuts,mags,devs,SampleRate);
figure;
freqz(phase_filter);
title('鉴相滤波器分析')

snr = 2;
%加噪
receive = awgn(modulate,snr,powerCnt(modulate)/length(modulate)*SamplePoint);
figure;
plot(receive);
title('加噪结果')

%接收端

%接收滤波
figure;
len = length(receive);
plot(abs(fft(receive)))
title('滤波频谱图');
hold on;
receive2 = conv(receive_filter,receive);
receive2 = arrayCut(receive2,len);
plot(abs(fft(receive2)));
legend('滤波前','滤波后');
figure;
plot(receive);
hold on;
plot(receive2);
title('接收滤波结果')
legend('滤波前','滤波后');

%延迟一个码元周期
delay = [receive2(SamplePoint+1:end),zeros(1,SamplePoint)];
%相乘
phase = delay.*receive2;
figure;
subplot(3,1,1);
plot(receive2);
title('相乘前')
subplot(3,1,2);
plot(delay);
title('相乘前延迟一拍')
subplot(3,1,3);
plot(phase);
title('相乘后')

%鉴相滤波
len = length(phase);
phase2 = conv(phase,phase_filter);
phase2 = arrayCut(phase2,len);
figure;
plot(phase);
hold on;
plot(phase2);
title('鉴相滤波');
legend('滤波前','滤波后');
figure;
plot(abs(fft(phase)));
hold on;
plot(abs(fft(phase2)));
title('鉴相滤波频谱图');
legend('滤波前','滤波后');

%鉴相
res = detector(phase2,SamplePoint);
figure;
subplot(2,1,1);
stairs(res);
title('鉴相结果')
set(gca,'YLim',[-2 2]);%Y轴的数据显示范围
subplot(2,1,2);
stairs(source);
title('用户码元')
set(gca,'YLim',[-2 2]);%Y轴的数据显示范围