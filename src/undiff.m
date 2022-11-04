%{
    以下是第一版代码，是错误的
因为没有使用差分鉴相。
错误！
错误！
错误！
%}
codeSize = 1e5;
carrier_freq = 1e3;
SampleRate = 4e4;
SamplePoint = 80;

%用户码元
%规定发送码元必须以-1开始
source = [-1,bipolarGen(codeSize)];
%载波
carrier = carrierGen(carrier_freq,SampleRate,SamplePoint);
%调制
modulate = modulation(source,carrier);

snr_start = -10;
snr_end = 10;
snr_div = 0.1;
snr_size = floor((snr_end-snr_start)/snr_div);
rightRate = zeros(1,snr_size);
parfor snr_index = 1:snr_size
    snr = snr_start + (snr_index-1) * snr_div;
    %加噪
    send = awgn(modulate,snr,powerCnt(modulate)/length(modulate)*SamplePoint);
    %接收端
    %延迟一个码元周期
    delay = [send(SamplePoint+1:end),zeros(1,SamplePoint)];
    %相乘
    phase = delay.*send;
    %鉴相
    len = length(phase)/SamplePoint-1;
    res = [-1,zeros(1,len)];
    for i = 1:len
        foo = sum(phase((i-1)*SamplePoint+1:i*SamplePoint));
        if foo > 0
            res(i+1) = res(i);
        else
            res(i+1) = -res(i);
        end
    end
    rightR = rightRateCnt(res,source);
    rightRate(snr_index) = 1-rightR;
    disp([num2str(snr),'dB:',num2str(rightR)]);
end
plot(linspace(snr_start,snr_end,snr_size),rightRate);