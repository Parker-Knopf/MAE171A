function p = plotStressField(test, frame, dim , l0, a)

if (frame < 10)
        frame = "0"+ num2str(frame);
    else
        frame = num2str(frame);
end


    dir = sprintf("Data/Test %d/results/DICe_solution_%s.csv", test, frame);
    data = readmatrix(dir);

    if (dim == 'x')
         p.strain_xx = data(:,11);
         p.stress_xx = charStressStrain(test, l0, a).e .* p.strain_xx;
         p.x = data(:,2);
         p.y = data(:,3);
         

        figure(02)
        scatter(p.x,p.y,[],p.stress_xx,'filled')
        colorbar
        xlabel('x')
        ylabel('y')
        set(gca, 'fontsize',20,'linewidth',2)


    elseif (dim == 'y')
         p.strain_yy = data(:,12);
         p.stress_yy = charStressStrain(test, l0, a).e .* p.strain_yy;
         p.x = data(:,2);
         p.y = data(:,3);

        figure(02)
        scatter(p.x,p.y,[],p.stress_yy,'filled')
        colorbar
        xlabel('x')
        ylabel('y')
        set(gca, 'fontsize',20,'linewidth',2)

    else
        p = NaN;
    end
end
