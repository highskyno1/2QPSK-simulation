function res = detector(phase,SamplePoint)
    len = length(phase)/SamplePoint-1;
    res = [-1,zeros(1,len)];
    for i = 1:len
       foo = sum(phase((i-1)*SamplePoint+1:i*SamplePoint));
       if foo > 0
           res(i+1) = -1;
       else
           res(i+1) = 1;
       end
    end
end