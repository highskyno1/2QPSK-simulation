function res = diffSource(source)
%{
���������ڰѾ�����ת���ɲ����,
��ַ�������������һ������Ϊ-1�������Ԫ��-1����ô����������һ����ͬ��
    �����Ԫ��1����ô������Ϊ����һ�����ȡ����
ʾ��������[-1 -1 1 -1 -1 1 1]
ʾ�������[-1 -1 1 1 1 -1 1]
%}
    res = zeros(1,length(source));
    res(1) = -1;
    for i = 2:length(source);
        if source(i) < 0
            res(i) = res(i-1);
        else
            res(i) = -res(i-1);
        end
    end
end