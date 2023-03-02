function params = charStressStrain(test, l0, a)
    % test ID, intial length, area of interest
    hold on;
    offset = .002;

    dir = sprintf("PMMA_dogbone_test%d", test);
    table = table2array(readtable(dir));
    data = table(4:end, 2:end);

    stress = data(:, 3) .* 1000 ./ a;
    strain = data(:, 2) ./ 1000 ./ l0;

    error = max(stress) / 80;
    for i = 1:length(strain)
        p = polyfit(strain(1:i+3), stress(1:i+3), 1);
        if (leastSquares(strain(1:i+3), stress(1:i+3), i, p) > error)
            params.sy = stress(i);
            labelTxt(strain(i),stress(i), 'Sy', params.sy, .005, 0)
            plot(strain(i),stress(i), '.', 'MarkerSize', 20, 'color', 'blue')
            break
        end
    end
    params.e = p(1);
    params.sut = max(stress);
    
    plot(strain, stress,'color', 'blue')
    xlabel("Strain")
    ylabel("Stress (Pa)")
    labelTxt(strain(find(stress==max(stress), 1)), max(stress), 'Sut', params.sut, -.01, 2*10^6)
    plot(strain(find(stress==max(stress), 1)),max(stress), '.', 'MarkerSize', 20, 'color', 'blue')
end

function txt = labelTxt(x, y, param, val, dx, dy)
    text(x + dx, y + dy, sprintf('%s: %.2f MPa', param, val/10^6), 'Color','black','FontSize',14)
end

function e = leastSquares(strain, stress, i, p)
    p = @(x) p(1)*x + p(2);
    s = sum((stress(:) - p(strain(:))).^2);

    e = sqrt(s/(i+1));
end