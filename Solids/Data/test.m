
dir = sprintf("Test 2/results/DICe_solution_01.csv");
data = importdata(dir);

e_xx = data.data(:,11);
e_yy = data.data(:,12);

Z = meshgrid(e_xx,e_yy);

    
% F = scatteredInterpolant(e_xx,e_yy,"linear");
contour(Z)
