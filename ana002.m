%-------------------------------------------------------------------------%
% this script averages experiment data per subcategory and saves result as
% a table

path_in  = "data_ana001";
path_out = "data_ana002";

cutoff_sigma = 2.5; % set cut off value for cleaning data
%-------------------------------------------------------------------------%


blocks = ["encoding1", "encoding2", "encoding3"];
types  = ["face", "space", "object"];

load(strcat(path_in,"/data_ana001.mat"))
n_participants = size(data_ana001,2);

% create empty table where all necessary data each participant is stored
var_names = {'participant_id', 'condition', 'type', 'version',...
    'RT_face_encoding1', 'RT_space_encoding1', 'RT_object_encoding1', ...
    'acc_face_encoding1', 'acc_space_encoding1', 'acc_object_encoding1', ...
    'RT_face_encoding2', 'RT_space_encoding2', 'RT_object_encoding2', ...
    'acc_face_encoding2', 'acc_space_encoding2', 'acc_object_encoding2', ...
    'RT_face_encoding3', 'RT_space_encoding3', 'RT_object_encoding3', ...
    'acc_face_encoding3', 'acc_space_encoding3', 'acc_object_encoding3', ...
    'RT_face_retrieval', 'RT_space_retrieval', 'RT_object_retrieval', ...
    'acc_face_retrieval', 'acc_space_retrieval', 'acc_object_retrieval', ...
    'acc_face_secretjob', 'acc_space_secretjob', 'acc_object_secretjob', ...
    'RT_face_secretjob', 'RT_space_secretjob', 'RT_object_secretjob', ...
    }; % all variables that are saved  per participant
N_var = length(var_names);
data_ana002 = array2table(NaN*ones(n_participants,N_var));
data_ana002.Properties.VariableNames = var_names;


struct_fields = fieldnames(data_ana001);


% loop over all participants and process data
for struct_id = 1:n_participants
    
    data_ana002.participant_id(struct_id) = data_ana001(struct_id).participant_id;
    data_ana002.condition(struct_id)      = data_ana001(struct_id).condition;
    data_ana002.type(struct_id)           = data_ana001(struct_id).type;
    data_ana002.version(struct_id)        = data_ana001(struct_id).version;
    
    for struct_field = struct_fields'
        structfield = string(struct_field);
        if any(structfield == blocks)
            % encoding
            
            % loop over all types (face, space, object)
            for type = types
                data_ana002.(strcat("RT","_",type,"_", structfield))(struct_id) = mean(data_ana001(struct_id).(structfield).(type).RT_cleaned);
                data_ana002.(strcat("acc","_",type,"_", structfield))(struct_id) = mean(data_ana001(struct_id).(structfield).(type).acc);
            end
            
        elseif structfield == "retrieval"
            
            % loop over all types (face, space, object)
            for type = types
                data_ana002.(strcat("RT","_",type,"_", structfield))(struct_id)  = mean(data_ana001(struct_id).(structfield).(type).RT_cleaned);
                data_ana002.(strcat("acc","_",type,"_", structfield))(struct_id) = mean(data_ana001(struct_id).(structfield).(type).acc_cleaned);
            end
            
        elseif  structfield == "secretjob"
            if ~isempty(data_ana001(struct_id).(structfield))
            % loop over all types (face, space, object)
            for type = types
                data_ana002.(strcat("RT","_",type,"_", structfield))(struct_id)  = data_ana001(struct_id).(structfield).(type).RT;
                data_ana002.(strcat("acc","_",type,"_", structfield))(struct_id) = data_ana001(struct_id).(structfield).(type).acc;
            end

            end
        end
    end
end

% % loop over all table columns and clean data -> delete participants
% % outliers
% cleaned_rows = [];
% for i=5:length(var_names)
%     var_name = var_names(i);
%     config = strsplit(var_name{1}, '_');
%     measure = config{1};
%     type = config{2};
%     experiment_part = config{3};
%     
%     
%     if any(experiment_part == blocks) && measure == "RT"
%         % encoding
%         
%         % clean mean values when over +- x sigma for RT and acc
%         RT = table2array(data_ana002(:,strcat('RT_',type,'_',experiment_part)));
%         [~,i_cleaned_RT ] = cleanData(RT,cutoff_sigma);
%         
%         acc = table2array(data_ana002(:,strcat('acc_',type,'_',experiment_part)));
%         [~,i_cleaned_acc ] = cleanData(acc,cutoff_sigma);
%         
%         i_cleaned = i_cleaned_RT & i_cleaned_acc;  % keep data just if RT AND acc is within accepted interval     
%         
%         
%         data_ana002(~i_cleaned,strcat('RT_',type,'_',experiment_part))  = {NaN};
%         data_ana002(~i_cleaned,strcat('acc_',type,'_',experiment_part)) = {NaN};
%             
%     elseif experiment_part == "retrieval" && measure == "acc"
%         % retrieval
%         
%         % clean mean values when over +- x sigma for acc
%         acc = table2array(data_ana002(:,strcat('acc_',type,'_retrieval')));
%         [~,i_cleaned ] = cleanData(acc,cutoff_sigma);
%         
%         data_ana002(~i_cleaned,strcat('acc_',type,'_retrieval'))  = {NaN};            
%     end
%       
%     
% end


% save files
save(strcat(path_out,"/data_ana002.mat"), "data_ana002")
writetable(data_ana002,strcat(path_out,"/data_ana002.csv"),'Delimiter',',') 

% create tables for ANOVAs

RT_encoding = data_ana002(:,[3,5:7,11:13,17:19]);
acc_encoding = data_ana002(:,[3,8:10, 14:16, 20:22]);
acc_retrieval = data_ana002(:,[3,26:28]);
acc_secretjob = data_ana002(:,[3,29:31]);


writetable(RT_encoding,strcat(path_out,"/RT_encoding.csv"),'Delimiter',',') 
writetable(acc_encoding,strcat(path_out,"/acc_encoding.csv"),'Delimiter',',') 
writetable(acc_retrieval,strcat(path_out,"/acc_retrieval.csv"),'Delimiter',',') 
writetable(acc_secretjob,strcat(path_out,"/acc_secretjob.csv"),'Delimiter',',') 


