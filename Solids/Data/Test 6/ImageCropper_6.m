% Batch image cropper, N. Boechler (1/2023)
% put this in a folder with your photograps (and only your photographs)
% create a subfolder called 'cropped'
%%
clc;
clear all;
close all;

% test on one file
myfile='DSC_3343.JPG';

myimg=imread(myfile);
imshow(myimg);

croparea = [2400 750 800 2600];
cropimg=imcrop(myimg,croparea);
imshow(cropimg);

%% apply to all files in folder

myfiles=dir('*.jpg');
myfolder=pwd;

for i=1:length(myfiles)

    myimg=imread(myfiles(i).name);
    imshow(myimg);

    cropimg=imcrop(myimg,croparea);
    %imshow(cropimg);

    imwrite(cropimg,[pwd '/cropped/crop_' myfiles(i).name]);

end