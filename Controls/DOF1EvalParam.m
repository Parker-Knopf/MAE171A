function [k_val, m_val, d_val] = DOF1EvalParam(t0, tn, y0, yn, y_ss, U_ar, n)
%{
Takes two points, steday state value, step input, and wavelength between
points and returns k,m,d values of a 1DOF system.
%}
    len = length(y_ss);
    k = zeros(len, 1);
    m = zeros(len, 1);
    d = zeros(len, 1);
    for i = 1:length(y_ss)
        U = U_ar(i);
        
        w_d = 2 * pi * n(i) / (tn(i) - t0(i));
        b_wn = 1 / (tn(i) - t0(i)) * log((y0(i) - y_ss(i)) / (yn(i) - y_ss(i)));
        w_n = sqrt(w_d^2 + b_wn^2);
        
        b = b_wn / w_n;

        k(i) = U / y_ss(i);
        m(i) = k(i) / w_n^2;
        d(i) = 2 * b * sqrt(k(i)*m(i));
    end

    k_val.avg = mean(k(:));
    m_val.avg = mean(m(:));
    d_val.avg = mean(d(:));

    k_val.std = std(k(:));
    m_val.std = std(m(:));
    d_val.std = std(d(:));
end