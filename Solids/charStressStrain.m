function params = charStressStrain(test, l0, a, s0, e_data)
    % test ID, intial length, area of interest
    hold on;
    offset = .002;

    dir = sprintf("Data/PMMA_dogbone_test%d", test);
    table = table2array(readtable(dir));
    data = table(4:end, 2:end);

    stress = data(:, 3) .* 1000 ./ a / 10^6;
    strain = data(:, 2) ./ 1000 ./ l0;

    error = max(stress) / e_data;
    for i = 1:length(strain)
        p = polyfit(strain(s0:i+3), stress(s0:i+3), 1);
        if (leastSquares(strain(s0:i+3), stress(s0:i+3), i, p) > error)
            params.sy = stress(i);
            params.sy_e = strain(i);
            break
        end
    end
    params.e = p(1);
    params.sut = max(stress);
    params.sut_e = strain(find(stress==max(stress), 1));

    params.strain = strain;
    params.stress = stress;
end

function e = leastSquares(strain, stress, i, p)
    p = @(x) p(1)*x + p(2);
    s = sum((stress(:) - p(strain(:))).^2);

    e = sqrt(s/(i+1));
end