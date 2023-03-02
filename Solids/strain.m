function e = strain(test, frame, dim)
    % Pull cordinate and displacement data from DICe

    % Frame to string for Directory
    if (frame < 10)
        frame = "0"+ num2str(frame);
    else
        frame = num2str(frame);
    end

    dir = sprintf("Data/Test %d/results/DICe_solution_%s.csv", test, frame);
    data = importdata(dir);
    if (dim == 'x')
        e.cord = data.data(:,2);
        e.disp = data.data(:,4);
    elseif (dim == 'y')
        e.cord = data.data(:,3);
        e.disp = data.data(:,5);
    else
        e = NaN;
    end

end


