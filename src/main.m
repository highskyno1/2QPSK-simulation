%{
    �����������ӳٲ�ּ���ͨ��ϵͳ�ķ���
%}
%������Ԫ����
codeSize = 1e5;
%�ز�Ƶ��
carrier_freq = 1e3;
%�ز�������
SampleRate = 25*1e3;
%�ز���������
SamplePoint = 25;
%�û���Ԫ
source = bipolarGen(codeSize);
%��Ԫ��ִ���
source_diff = diffSource(source); 
%�ز�
carrier = carrierGen(carrier_freq,SampleRate,SamplePoint);
%����
modulate = modulation(source_diff,carrier);

%�����˲���
fcuts = [0 500 1500 2000]; %����ͨ���������Ƶ��
mags = [0 1 0];             %����ͨ�������
devs = [0.1 0.1 0.1];      %����ͨ����������Ʋ�ϵ��
send_filter = getFilter(fcuts,mags,devs,SampleRate);

%�����˲���
fcuts = [1500 2000]; %����ͨ���������Ƶ��
mags = [1 0];             %����ͨ�������
devs = [0.1 0.1];      %����ͨ����������Ʋ�ϵ��
phase_filter = getFilter(fcuts,mags,devs,SampleRate);

snr_start = -20;
snr_end = 20;
snr_div = 0.1;
snr_size = floor((snr_end-snr_start)/snr_div);
errorRate = zeros(1,snr_size);
parfor snr_index = 1:snr_size
    snr = snr_start + (snr_index-1) * snr_div;
    %����
    send = awgn(modulate,snr,powerCnt(modulate)/length(modulate)*SamplePoint);
    %���ն�
    %�����˲�
    len = length(send);
    send = conv(send_filter,send);
    send = arrayCut(send,len);
    %�ӳ�һ����Ԫ����
    delay = [send(SamplePoint+1:end),zeros(1,SamplePoint)];
    %���
    phase = delay.*send;
    %�����˲�
    len = length(phase);
    phase = conv(phase,phase_filter);
    phase = arrayCut(phase,len);
    %����
    res = detector(phase,SamplePoint);
    rightR = rightRateCnt(res,source);
    errorRate(snr_index) = 1-rightR;
    disp([num2str(snr),'dB:',num2str(rightR)]);
end
foo_x = linspace(snr_start,snr_end,snr_size);
figure
semilogy(foo_x,errorRate);
xlabel('�����dB')
ylabel('������%')
title('������������ȵĹ�ϵ')