%-----------------------------------------------------------------------------%
% this script reads and cleans the data in the csv files provided by the
% shamem framework

path_in  = "raw_data";
path_out = "data_ana001";

% paremeters to set by user
plot_flag = false; % set true for plotting and saving participant data each subcategory
cutoff_sigma = 3; % set cut off value for cleaning data
%-----------------------------------------------------------------------------%


close all
blocks = ["encoding1", "encoding2", "encoding3"];
types  = ["face", "space", "object"];


% get file names from all files in folder "data"
raw_data = dir(strcat(path_in,"/*.csv"));

% create empty struct data_ana001 with field participant_id (needed later)
temp.participant_id = []; 
data_ana001 = temp([]);

% main loop that loops over all files in folder "data"
for i=1:length(raw_data)
    file_name = raw_data(i).name;
    file_data = readtable(strcat(path_in,"/",file_name));  % table with all information of file
    
    configStrings = strsplit(file_name,"_");
    participant_id = str2num(configStrings{1}); % participant id
   
    % add struct entry if there is a new participant
    if ~any([data_ana001.participant_id] ==  participant_id)
        struct_id = length(data_ana001)+1;
    else
        struct_id = find([data_ana001.participant_id] == participant_id); % find current struct id
    end
    data_ana001(struct_id).participant_id = participant_id;   
    data_ana001(struct_id).condition = str2num(configStrings{3});
    data_ana001(struct_id).type = str2num(configStrings{4});
    data_ana001(struct_id).version = str2num(configStrings{5});
    
    % if experiment part is encoding then concatenate splitted strings
    % together again
    if length(configStrings) == 9
        configStrings{8} = strcat(configStrings{8}, configStrings{9});
        configStrings{9} = [];
    end
    experiment_part = convertCharsToStrings(extractBefore(configStrings{8},'.')); % experiment part (encoding, retrieval, secretjob)
    
    if any(experiment_part == blocks)
         % accuracy per category
         data_ana001(struct_id).(experiment_part).face.acc   = ~isnan(file_data.RT(file_data.cond == 1));
         data_ana001(struct_id).(experiment_part).space.acc  = ~isnan(file_data.RT(file_data.cond == 2));
         data_ana001(struct_id).(experiment_part).object.acc = ~isnan(file_data.RT(file_data.cond == 3));
                 
        % RT per category
        data_ana001(struct_id).(experiment_part).face.RT   = file_data.RT(file_data.cond ==1);
        data_ana001(struct_id).(experiment_part).space.RT  = file_data.RT(file_data.cond ==2);
        data_ana001(struct_id).(experiment_part).object.RT = file_data.RT(file_data.cond ==3);

    elseif experiment_part ==  'retrieval'    
        
        % accuracy per category
        data_ana001(struct_id).retrieval.face.acc    = file_data.L2_precision(file_data.cond == 1);
        data_ana001(struct_id).retrieval.space.acc   = file_data.L2_precision(file_data.cond == 2);
        data_ana001(struct_id).retrieval.object.acc  = file_data.L2_precision(file_data.cond == 3);            
              
        % RT  per category   
        data_ana001(struct_id).retrieval.face.RT   = file_data.RT_coin(file_data.cond == 1);
        data_ana001(struct_id).retrieval.space.RT  = file_data.RT_coin(file_data.cond == 2);
        data_ana001(struct_id).retrieval.object.RT = file_data.RT_coin(file_data.cond == 3);
        
 
    elseif experiment_part ==  'secretjob'
       
       % accuracy per category  
       data_ana001(struct_id).secretjob.face.acc   = file_data.accuracy(find(strcmp(file_data.task_type ,'face')));         
       data_ana001(struct_id).secretjob.space.acc  = file_data.accuracy(find(strcmp(file_data.task_type ,'space')));         
       data_ana001(struct_id).secretjob.object.acc = file_data.accuracy(find(strcmp(file_data.task_type ,'object')));         

       % RT per category 
       data_ana001(struct_id).secretjob.face.RT   = file_data.reaction_time(find(strcmp(file_data.task_type ,'face')));         
       data_ana001(struct_id).secretjob.space.RT  = file_data.reaction_time(find(strcmp(file_data.task_type ,'space')));         
       data_ana001(struct_id).secretjob.object.RT = file_data.reaction_time(find(strcmp(file_data.task_type ,'object')));         
    end
    
       
end

struct_fields = fieldnames(data_ana001);


% loop over all participants and process data
for struct_id = 1:size(data_ana001,2) % struct_id loops over each participant in struct
    participant_id = data_ana001(struct_id).participant_id;
    for struct_field = struct_fields'
        structfield = string(struct_field);
        if any(structfield == blocks)  
            % encoding 
                
            %loop over all types (face, space, object)
            for type = types
                acc = data_ana001(struct_id).(structfield).(type).acc;
                RT = data_ana001(struct_id).(structfield).(type).RT(acc==1);
                [RT_cleaned, i_cleaned] = cleanData(RT,cutoff_sigma); % cleanData function deletes all entries that outside mean +- cutoff_sigma*sigma 
                n_exclude = length(RT) - length(RT_cleaned);
                
                % plot and save figure if plot_flat = true
                if plot_flag
                   plotData(RT, RT_cleaned, participant_id, getVarName(RT), structfield, type ,path_out)
                end
                
                % assign cleaned RT and n_exclude to struct
                data_ana001(struct_id).(structfield).(type).RT_cleaned = RT_cleaned;
                data_ana001(struct_id).(structfield).(type).n_exclude = n_exclude;
            end          

        elseif structfield == "retrieval"
            %loop over all types (face, space, object)
            for type = types
                acc = data_ana001(struct_id).(structfield).(type).acc;
                RT = data_ana001(struct_id).(structfield).(type).RT;
                [RT_cleaned, i_cleaned] = cleanData(RT,cutoff_sigma); % cleanData function deletes all entries that outside mean +- cutoff_sigma*sigma 
                acc_cleaned = acc(i_cleaned);
                n_exclude = length(RT) - length(RT_cleaned);
              
                
                % plot and save figure if plot_flat = true
                if plot_flag
                   plotData(RT, RT_cleaned, participant_id, getVarName(RT), structfield, type ,path_out)
                end
                
                % assign cleaned RT and acc, and n_exclude to struct
                data_ana001(struct_id).(string(structfield)).(type).RT_cleaned = RT_cleaned;
                data_ana001(struct_id).(string(structfield)).(type).acc_cleaned = acc_cleaned;
                data_ana001(struct_id).(string(structfield)).(type).n_exclude = n_exclude;
            end
        end
    end
end

save(strcat(path_out,"/data_ana001.mat"), "data_ana001")
