function data = histoacu(u)
    num = 1:256;
    acc = 0;
    histoac = zeros(1,256);
    for x = 1:256
        histac(x) = acc + u(u);
        acc = histac(x);
    end
    val = 210-(histac * 200);
    data(:,1) = num;
    data(:,2) = val;

end