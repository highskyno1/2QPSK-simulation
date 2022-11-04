function res = diffSource(source)
%{
本函数用于把绝对码转换成差分码,
差分方法：输出结果第一个必须为-1，如果码元是-1，那么输出结果与上一个相同；
    如果码元是1，那么输出结果为对上一个输出取反。
示例：输入[-1 -1 1 -1 -1 1 1]
示例：输出[-1 -1 1 1 1 -1 1]
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