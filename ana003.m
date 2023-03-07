%-------------------------------------------------------------------------%
% this script averages over each type (criminal, spy, neutral) and serves
% as generating input data for the ANOVA
% 

path_in  = "data_ana002";
path_out = "data_ana003";

%-------------------------------------------------------------------------%


types  = ["face", "space", "object"];

load(strcat(path_in,"/data_ana002.mat"))


var_names = data_ana002.Properties.VariableNames;
var_names([1:2,4]) = []; % delete unnecessary variable names
data_ana003 = array2table(NaN*ones(3,length(var_names)));
data_ana003.Properties.VariableNames = var_names;

% loop over all types and average measurements per type
for type=1:3
    
data_ana003.type(type) = type;
data_ana003(type,2:end) =  array2table(mean(table2array(data_ana002(data_ana002.type == type,5:end)),'omitnan'));
    
end


% save files
save(strcat(path_out,"/data_ana003.mat"), "data_ana003")
writetable(data_ana003,strcat(path_out,"/data_ana003.csv"),'Delimiter',',') 
