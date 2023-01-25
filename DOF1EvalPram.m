function [k_val, m_val, d_val] = DOF1evalPram(t0, t1, y0, y1, y_ss, U, n)
%{
Takes two points, steday state value, step input, and wavelength between
points and returns k,m,d values of a 1DOF system.
%}
    len = length(y_ss);
    k = zeros(len, 1);
    m = zeros(len, 1);
    d = zeros(len, 1);
    for i = 1:length(y_ss)
        
        C = y_ss(i) / U;
        
        w_d = 2 * pi * n(i) / (t1(i) - t0(i));
        b_wn = 1 / (t1(i) - t0(i)) * log((y0(i) - y_ss(i)) / (y1(i) - y_ss(i)));
        w_n = sqrt(w_d^2 + b_wn^2);
        
        b = b_wn / w_n; 
    
        k(i) = 1 / C;
        m(i) = 1 / (C * w_n^2);
        d(i) = 2 * b / C / w_n;
    end

    k_val.avg = mean(k(:));
    m_val.avg = mean(m(:));
    d_val.avg = mean(d(:));

    k_val.std = std(k(:));
    m_val.std = std(m(:));
    d_val.std = std(d(:));
end