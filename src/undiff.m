%{
    �����ǵ�һ����룬�Ǵ����
��Ϊû��ʹ�ò�ּ��ࡣ
����
����
����
%}
codeSize = 1e5;
carrier_freq = 1e3;
SampleRate = 4e4;
SamplePoint = 80;

%�û���Ԫ
%�涨������Ԫ������-1��ʼ
source = [-1,bipolarGen(codeSize)];
%�ز�
carrier = carrierGen(carrier_freq,SampleRate,SamplePoint);
%����
modulate = modulation(source,carrier);

snr_start = -10;
snr_end = 10;
snr_div = 0.1;
snr_size = floor((snr_end-snr_start)/snr_div);
rightRate = zeros(1,snr_size);
parfor snr_index = 1:snr_size
    snr = snr_start + (snr_index-1) * snr_div;
    %����
    send = awgn(modulate,snr,powerCnt(modulate)/length(modulate)*SamplePoint);
    %���ն�
    %�ӳ�һ����Ԫ����
    delay = [send(SamplePoint+1:end),zeros(1,SamplePoint)];
    %���
    phase = delay.*send;
    %����
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