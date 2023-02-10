% Converts data in Open Loop and Closed Loop folders form .csv to .mat files

clear all; clc; close all;

files_ol = dir('Data\Open_Loop\*.csv');

for file = files_ol'
    file_name = ['Data\Open_Loop\' file.name];
    data = readecp(file_name);
    mat_file_name = file.name;
    mat_file_name = mat_file_name(1:end-4);
    save(['Data\Open_Loop\' mat_file_name],'data');
end

files_cl = dir('Data\Closed_Loop\*.csv');

for file = files_cl'
    file_name = ['Data\Closed_Loop\' file.name];
    data = readecp(file_name);
    mat_file_name = file.name;
    mat_file_name = mat_file_name(1:end-4);
    save(['Data\Closed_Loop\' mat_file_name],'data');
end