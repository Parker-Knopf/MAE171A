function p = plotStressFieldDesign(test, frame, dim , l0, e)

if (frame < 10)
        frame = "0"+ num2str(frame);
    else
        frame = num2str(frame);
end


    dir = sprintf("Data/Test %d/results/DICe_solution_%s.csv", test, frame);
    data = readmatrix(dir);

    if (dim == 'x')
         p.strain_xx = data(:,11);
         p.strain_avg = mean(p.strain_xx);
         p.stress_xx = e .* p.strain_xx;
         p.x = data(:,2);
         p.y = data(:,3);
         
        scatter(p.y,p.x,[],p.stress_xx,'filled')
        colorbar
        xlabel('y')
        ylabel('x')


    elseif (dim == 'y')
         p.strain_yy = data(:,12);
         p.strain_avg = mean(p.strain_yy);
         p.stress_yy = e .* p.strain_yy;
         p.x = data(:,2);
         p.y = data(:,3);

        scatter(p.y,p.x,[],p.stress_yy,'filled')
        colorbar
        xlabel('y')
        ylabel('x')

    else
        p = NaN;
    end
end
