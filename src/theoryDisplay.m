%{
    ���������ڷ���ԭ��չʾ��
    �������ŵ���main.m
%}
carrier_freq = 1e3;
SampleRate = 25*1e3;
SamplePoint = 25;

close all;
%�û���Ԫ
source = [-1 1 1 -1 -1];
figure;
stairs(source);
hold on;
%��Ԫ��ִ���
source_diff = diffSource(source);
stairs(source_diff.*2);
title('�û���Ԫ')
legend('���ǰ','��ֺ�');
set(gca,'YLim',[-3 3]);%Y���������ʾ��Χ
%�ز�
carrier = carrierGen(carrier_freq,SampleRate,SamplePoint);
figure;
plot(carrier);
title('�ز�')
%����
modulate = modulation(source_diff,carrier);
figure;
plot(modulate);
title('���ƽ��')

%�����˲���
fcuts = [0 500 1500 2000]; %����ͨ���������Ƶ��
mags = [0 1 0];             %����ͨ�������
devs = [0.1 0.1 0.1];      %����ͨ����������Ʋ�ϵ��
receive_filter = getFilter(fcuts,mags,devs,SampleRate);
figure;
freqz(modulate);
title('�����˲�������')

%�����˲���
fcuts = [1500 2000]; %����ͨ���������Ƶ��
mags = [1 0];             %����ͨ�������
devs = [0.1 0.1];      %����ͨ����������Ʋ�ϵ��
phase_filter = getFilter(fcuts,mags,devs,SampleRate);
figure;
freqz(phase_filter);
title('�����˲�������')

snr = 2;
%����
receive = awgn(modulate,snr,powerCnt(modulate)/length(modulate)*SamplePoint);
figure;
plot(receive);
title('������')

%���ն�

%�����˲�
figure;
len = length(receive);
plot(abs(fft(receive)))
title('�˲�Ƶ��ͼ');
hold on;
receive2 = conv(receive_filter,receive);
receive2 = arrayCut(receive2,len);
plot(abs(fft(receive2)));
legend('�˲�ǰ','�˲���');
figure;
plot(receive);
hold on;
plot(receive2);
title('�����˲����')
legend('�˲�ǰ','�˲���');

%�ӳ�һ����Ԫ����
delay = [receive2(SamplePoint+1:end),zeros(1,SamplePoint)];
%���
phase = delay.*receive2;
figure;
subplot(3,1,1);
plot(receive2);
title('���ǰ')
subplot(3,1,2);
plot(delay);
title('���ǰ�ӳ�һ��')
subplot(3,1,3);
plot(phase);
title('��˺�')

%�����˲�
len = length(phase);
phase2 = conv(phase,phase_filter);
phase2 = arrayCut(phase2,len);
figure;
plot(phase);
hold on;
plot(phase2);
title('�����˲�');
legend('�˲�ǰ','�˲���');
figure;
plot(abs(fft(phase)));
hold on;
plot(abs(fft(phase2)));
title('�����˲�Ƶ��ͼ');
legend('�˲�ǰ','�˲���');

%����
res = detector(phase2,SamplePoint);
figure;
subplot(2,1,1);
stairs(res);
title('������')
set(gca,'YLim',[-2 2]);%Y���������ʾ��Χ
subplot(2,1,2);
stairs(source);
title('�û���Ԫ')
set(gca,'YLim',[-2 2]);%Y���������ʾ��Χ