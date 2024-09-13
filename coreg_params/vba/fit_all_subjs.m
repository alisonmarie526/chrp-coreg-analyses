
[~, me] = system('whoami');
me = strtrim(me);

addpath(genpath(strcat('/Users/', me, '/Documents/GitHub/VBA-toolbox')));
basedir = strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/');
addpath(genpath(basedir));
data_dir = strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/ibis/fourth_round/neuint_ibis/');
subjs = dir([data_dir, '/*.txt']);
nsubjs = length(subjs);
posteriors = cell(length(nsubjs), 1);
outputs = cell(length(nsubjs), 1);
ids = NaN(1,nsubjs);
for i = 1:nsubjs
ids(i) = str2double(regexprep(subjs(i).name,'(\d+)_ibis.txt','$1'));
fprintf('id: %d\n', ids(i));
filetofit = fullfile(strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/ibis/fourth_round/neuint_ibis'), subjs(i).name); 
[posteriors{i}, outputs{i}] = fitIBISystem(filetofit, 0, 1); %suppress figure (0)

end

        
save('fit_subjs_to_VAR_coreg_neuint_w_isYout_19Dec2023.mat', 'posteriors', 'outputs');


summ_info = zeros(nsubjs, 6);

for i = 1:nsubjs
    id = ids(i);
    a1 = posteriors{i}.muTheta(1); % child self reg
    a2 = posteriors{i}.muTheta(2); % child coreg
    b1 = posteriors{i}.muTheta(3); %caregiver self reg
    b2 = posteriors{i}.muTheta(4); % caregiver coreg
    r2 = outputs{i}.fit.R2;
    summ_info(i, 1) = id;
    summ_info(i, 2) = a1;
    summ_info(i, 3) = a2;
    summ_info(i, 4) = b1;
    summ_info(i, 5) = b2;
    summ_info(i, 6) = r2;

end

save('fit_subjs_to_VAR_coreg_summinfo_neuint_w_is_Yout_19Dec2023.mat', 'summ_info');

clear all
close all


[~, me] = system('whoami');
me = strtrim(me);

addpath(genpath(strcat('/Users/', me, '/Documents/GitHub/VBA-toolbox')));
basedir = strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/');
addpath(genpath(basedir));
data_dir = strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/ibis/fourth_round/neuint_ibis/');
subjs = dir([data_dir, '/*.txt']);
nsubjs = length(subjs);
posteriors = cell(length(nsubjs), 1);
outputs = cell(length(nsubjs), 1);
ids = NaN(1,nsubjs);
for i = 1:nsubjs
ids(i) = str2double(regexprep(subjs(i).name,'(\d+)_ibis.txt','$1'));
fprintf('id: %d\n', ids(i));
filetofit = fullfile(strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/ibis/fourth_round/neuint_ibis'), subjs(i).name); 
[posteriors{i}, outputs{i}] = fitIBISystem(filetofit, 0, 0); %suppress figure (0)

end

        
save('fit_subjs_to_VAR_coreg_neuint_wo_isYout_19Dec2023.mat', 'posteriors', 'outputs');


summ_info = zeros(nsubjs, 6);

for i = 1:nsubjs
    id = ids(i);
    a1 = posteriors{i}.muTheta(1); % child self reg
    a2 = posteriors{i}.muTheta(2); % child coreg
    b1 = posteriors{i}.muTheta(3); %caregiver self reg
    b2 = posteriors{i}.muTheta(4); % caregiver coreg
    r2 = outputs{i}.fit.R2;
    summ_info(i, 1) = id;
    summ_info(i, 2) = a1;
    summ_info(i, 3) = a2;
    summ_info(i, 4) = b1;
    summ_info(i, 5) = b2;
    summ_info(i, 6) = r2;

end

save('fit_subjs_to_VAR_coreg_summinfo_neuint_wo_is_Yout_19Dec2023.mat', 'summ_info');


%% neg int
close all
clear all


[~, me] = system('whoami');
me = strtrim(me);

addpath(genpath(strcat('/Users/', me, '/Documents/GitHub/VBA-toolbox')));
basedir = strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/');
addpath(genpath(basedir));
data_dir = strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/ibis/fourth_round/negint_ibis/');
subjs = dir([data_dir, '/*.txt']);
nsubjs = length(subjs);
posteriors = cell(length(nsubjs), 1);
outputs = cell(length(nsubjs), 1);
ids = NaN(1,nsubjs);
for i = 1:nsubjs
ids(i) = str2double(regexprep(subjs(i).name,'(\d+)_ibis.txt','$1'));
fprintf('id: %d\n', ids(i));
filetofit = fullfile(strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/ibis/fourth_round/negint_ibis'), subjs(i).name); 
[posteriors{i}, outputs{i}] = fitIBISystem(filetofit, 0, 1); %suppress figure (0)

end

        
save('fit_subjs_to_VAR_coreg_negint_w_isYout_19Dec2023.mat', 'posteriors', 'outputs');


summ_info = zeros(nsubjs, 6);

for i = 1:nsubjs
    id = ids(i);
    a1 = posteriors{i}.muTheta(1); % child self reg
    a2 = posteriors{i}.muTheta(2); % child coreg
    b1 = posteriors{i}.muTheta(3); %caregiver self reg
    b2 = posteriors{i}.muTheta(4); % caregiver coreg
    r2 = outputs{i}.fit.R2;
    summ_info(i, 1) = id;
    summ_info(i, 2) = a1;
    summ_info(i, 3) = a2;
    summ_info(i, 4) = b1;
    summ_info(i, 5) = b2;
    summ_info(i, 6) = r2;

end

save('fit_subjs_to_VAR_coreg_summinfo_negint_w_is_Yout_19Dec2023.mat', 'summ_info');

clear all
close all


[~, me] = system('whoami');
me = strtrim(me);

addpath(genpath(strcat('/Users/', me, '/Documents/GitHub/VBA-toolbox')));
basedir = strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/');
addpath(genpath(basedir));
data_dir = strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/ibis/fourth_round/negint_ibis/');
subjs = dir([data_dir, '/*.txt']);
nsubjs = length(subjs);
posteriors = cell(length(nsubjs), 1);
outputs = cell(length(nsubjs), 1);
ids = NaN(1,nsubjs);
for i = 1:nsubjs
ids(i) = str2double(regexprep(subjs(i).name,'(\d+)_ibis.txt','$1'));
fprintf('id: %d\n', ids(i));
filetofit = fullfile(strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/ibis/fourth_round/negint_ibis'), subjs(i).name); 
[posteriors{i}, outputs{i}] = fitIBISystem(filetofit, 0, 0); %suppress figure (0)

end

        
save('fit_subjs_to_VAR_coreg_negint_wo_isYout_19Dec2023.mat', 'posteriors', 'outputs');


summ_info = zeros(nsubjs, 6);

for i = 1:nsubjs
    id = ids(i);
    a1 = posteriors{i}.muTheta(1); % child self reg
    a2 = posteriors{i}.muTheta(2); % child coreg
    b1 = posteriors{i}.muTheta(3); %caregiver self reg
    b2 = posteriors{i}.muTheta(4); % caregiver coreg
    r2 = outputs{i}.fit.R2;
    summ_info(i, 1) = id;
    summ_info(i, 2) = a1;
    summ_info(i, 3) = a2;
    summ_info(i, 4) = b1;
    summ_info(i, 5) = b2;
    summ_info(i, 6) = r2;

end

save('fit_subjs_to_VAR_coreg_summinfo_negint_wo_is_Yout_19Dec2023.mat', 'summ_info');

 

 %% pos int

 %% neg int
close all
clear all


[~, me] = system('whoami');
me = strtrim(me);

addpath(genpath(strcat('/Users/', me, '/Documents/GitHub/VBA-toolbox')));
basedir = strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/');
addpath(genpath(basedir));
data_dir = strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/ibis/fourth_round/posint_ibis/');
subjs = dir([data_dir, '/*.txt']);
nsubjs = length(subjs);
posteriors = cell(length(nsubjs), 1);
outputs = cell(length(nsubjs), 1);
ids = NaN(1,nsubjs);
for i = 1:nsubjs
ids(i) = str2double(regexprep(subjs(i).name,'(\d+)_ibis.txt','$1'));
fprintf('id: %d\n', ids(i));
filetofit = fullfile(strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/ibis/fourth_round/posint_ibis'), subjs(i).name); 
[posteriors{i}, outputs{i}] = fitIBISystem(filetofit, 0, 1); %suppress figure (0)

end

        
save('fit_subjs_to_VAR_coreg_posint_w_isYout_19Dec2023.mat', 'posteriors', 'outputs');


summ_info = zeros(nsubjs, 6);

for i = 1:nsubjs
    id = ids(i);
    a1 = posteriors{i}.muTheta(1); % child self reg
    a2 = posteriors{i}.muTheta(2); % child coreg
    b1 = posteriors{i}.muTheta(3); %caregiver self reg
    b2 = posteriors{i}.muTheta(4); % caregiver coreg
    r2 = outputs{i}.fit.R2;
    summ_info(i, 1) = id;
    summ_info(i, 2) = a1;
    summ_info(i, 3) = a2;
    summ_info(i, 4) = b1;
    summ_info(i, 5) = b2;
    summ_info(i, 6) = r2;

end

save('fit_subjs_to_VAR_coreg_summinfo_posint_w_is_Yout_19Dec2023.mat', 'summ_info');

clear all
close all


[~, me] = system('whoami');
me = strtrim(me);

addpath(genpath(strcat('/Users/', me, '/Documents/GitHub/VBA-toolbox')));
basedir = strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/');
addpath(genpath(basedir));
data_dir = strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/ibis/fourth_round/posint_ibis/');
subjs = dir([data_dir, '/*.txt']);
nsubjs = length(subjs);
posteriors = cell(length(nsubjs), 1);
outputs = cell(length(nsubjs), 1);
ids = NaN(1,nsubjs);
for i = 1:nsubjs
ids(i) = str2double(regexprep(subjs(i).name,'(\d+)_ibis.txt','$1'));
fprintf('id: %d\n', ids(i));
filetofit = fullfile(strcat('/Users/', me, '/Documents/Projects/Adolescent Psychosis Coreg/ibis/fourth_round/posint_ibis'), subjs(i).name); 
[posteriors{i}, outputs{i}] = fitIBISystem(filetofit, 0, 0); %suppress figure (0)

end

        
save('fit_subjs_to_VAR_coreg_posint_wo_isYout_19Dec2023.mat', 'posteriors', 'outputs');


summ_info = zeros(nsubjs, 6);

for i = 1:nsubjs
    id = ids(i);
    a1 = posteriors{i}.muTheta(1); % child self reg
    a2 = posteriors{i}.muTheta(2); % child coreg
    b1 = posteriors{i}.muTheta(3); %caregiver self reg
    b2 = posteriors{i}.muTheta(4); % caregiver coreg
    r2 = outputs{i}.fit.R2;
    summ_info(i, 1) = id;
    summ_info(i, 2) = a1;
    summ_info(i, 3) = a2;
    summ_info(i, 4) = b1;
    summ_info(i, 5) = b2;
    summ_info(i, 6) = r2;

end

save('fit_subjs_to_VAR_coreg_summinfo_posint_wo_is_Yout_19Dec2023.mat', 'summ_info');

 

 