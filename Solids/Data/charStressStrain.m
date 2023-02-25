function params = charStressStrain(test, l0, a)
    % test ID, intial length, area of interest

    offset = .002;

    dir = sprintf("PMMA_dogbone_test%d", test);
    table = table2array(readtable(dir));
    data = table(4:end, 2:end);

    stress = data(:, 3) .* 1000 ./ a;
    strain = data(:, 2) ./ 1000 ./ l0;

    error = max(stress) / 1500;
    for i = 1:length(strain)
        p = polyfit(strain(1:i+3), stress(1:i+3), 1);
        if (leastSquares(strain(1:i+3), stress(1:i+3), i, p) > error)
            params.sy = stress(i);
            break
        end
    end
    params.e = p(1);
    params.sut = max(stress);
end

function e = leastSquares(strain, stress, i, p)
    p = @(x) p(1)*x + p(2);
    s = sum((stress(:) - p(strain(:))).^2);

    e = sqrt(s/(i+1));
end