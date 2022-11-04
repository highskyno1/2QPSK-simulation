function [res] = modulation(code,carrier)
    %���������
    %code:��Ҫ�������Ԫ
    %carrier:�ز�
    res = zeros(1,length(code) * length(carrier));
    for i = 1:length(code)
        if code(i) > 0
            res((i-1)*length(carrier)+1:i*length(carrier)) = carrier;
        else
            res((i-1)*length(carrier)+1:i*length(carrier)) = -carrier;
        end
    end
end

