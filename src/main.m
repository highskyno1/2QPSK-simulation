%{
    本代码用于延迟差分鉴相通信系统的仿真
%}
%仿真码元数量
codeSize = 1e5;
%载波频率
carrier_freq = 1e3;
%载波采样率
SampleRate = 25*1e3;
%载波采样点数
SamplePoint = 25;
%用户码元
source = bipolarGen(codeSize);
%码元差分处理
source_diff = diffSource(source); 
%载波
carrier = carrierGen(carrier_freq,SampleRate,SamplePoint);
%调制
modulate = modulation(source_diff,carrier);

%接收滤波器
fcuts = [0 500 1500 2000]; %定义通带和阻带的频率
mags = [0 1 0];             %定义通带和阻带
devs = [0.1 0.1 0.1];      %定义通带或阻带的纹波系数
send_filter = getFilter(fcuts,mags,devs,SampleRate);

%鉴相滤波器
fcuts = [1500 2000]; %定义通带和阻带的频率
mags = [1 0];             %定义通带和阻带
devs = [0.1 0.1];      %定义通带或阻带的纹波系数
phase_filter = getFilter(fcuts,mags,devs,SampleRate);

snr_start = -20;
snr_end = 20;
snr_div = 0.1;
snr_size = floor((snr_end-snr_start)/snr_div);
errorRate = zeros(1,snr_size);
parfor snr_index = 1:snr_size
    snr = snr_start + (snr_index-1) * snr_div;
    %加噪
    send = awgn(modulate,snr,powerCnt(modulate)/length(modulate)*SamplePoint);
    %接收端
    %接收滤波
    len = length(send);
    send = conv(send_filter,send);
    send = arrayCut(send,len);
    %延迟一个码元周期
    delay = [send(SamplePoint+1:end),zeros(1,SamplePoint)];
    %相乘
    phase = delay.*send;
    %鉴相滤波
    len = length(phase);
    phase = conv(phase,phase_filter);
    phase = arrayCut(phase,len);
    %鉴相
    res = detector(phase,SamplePoint);
    rightR = rightRateCnt(res,source);
    errorRate(snr_index) = 1-rightR;
    disp([num2str(snr),'dB:',num2str(rightR)]);
end
foo_x = linspace(snr_start,snr_end,snr_size);
figure
semilogy(foo_x,errorRate);
xlabel('信噪比dB')
ylabel('误码率%')
title('误码率与信噪比的关系')