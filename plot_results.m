%-----------------------------------------------------------------------------%

% this script plots the raw measurements

path_in  = "data_ana002";
path_out = "figures";

fontsize = 22;

%-----------------------------------------------------------------------------%


load(strcat(path_in,"/data_ana002.mat"));

red = [0.9608    0.6392    0.4235];
green = [0.7137    0.8902    0.6863];
gray = [0.6510    0.6510    0.651];


% ENCODING
close all
figure('Color','white')
tiledlayout(1,3)

titles = ["Spies","Criminals","Neutral"];


% reaction time
for type = 1:3
    nexttile
    box on
    title(titles(type))
    hold on
    set(gca,'FontSize',fontsize)
    
    
    y = cell(9,1);
    for i = 1:height(data_ana002)
        if data_ana002.type(i) == type
            %             y{1} = [y{1}; data_ana001(i).encoding1.face.RT_cleaned];
            %             y{2} = [y{2}; data_ana001(i).encoding1.space.RT_cleaned];
            %             y{3} = [y{3}; data_ana001(i).encoding1.object.RT_cleaned];
            %
            %             y{4} = [y{4}; data_ana001(i).encoding2.face.RT_cleaned];
            %             y{5} = [y{5}; data_ana001(i).encoding2.space.RT_cleaned];
            %             y{6} = [y{6}; data_ana001(i).encoding2.object.RT_cleaned];
            %
            %             y{7} = [y{7}; data_ana001(i).encoding3.face.RT_cleaned];
            %             y{8} = [y{8}; data_ana001(i).encoding3.space.RT_cleaned];
            %             y{9} = [y{9}; data_ana001(i).encoding3.object.RT_cleaned];
            
            y{1} = [y{1}; data_ana002.RT_face_encoding1(i)];
            y{2} = [y{2}; data_ana002.RT_space_encoding1(i)];
            y{3} = [y{3}; data_ana002.RT_object_encoding1(i)];
            
            y{4} = [y{4}; data_ana002.RT_face_encoding2(i)];
            y{5} = [y{5}; data_ana002.RT_space_encoding2(i)];
            y{6} = [y{6}; data_ana002.RT_object_encoding2(i)];
            
            y{7} = [y{7}; data_ana002.RT_face_encoding3(i)];
            y{8} = [y{8}; data_ana002.RT_space_encoding3(i)];
            y{9} = [y{9}; data_ana002.RT_object_encoding3(i)];
            
        end
    end
    
    colors = repmat([red;green;gray],3,1);
    plot([1 4 7],[mean(y{1}) mean(y{4}) mean(y{7})],'.-','Color',red,'LineWidth',1)
    plot([2 5 8],[mean(y{2}) mean(y{5}) mean(y{8})],'.-','Color',green, 'LineWidth',1)
    plot([3 6 9],[mean(y{3}) mean(y{6}) mean(y{9})],'.-','Color',gray,'LineWidth',1)
    for j=1:9
        if ~isempty(y{j})
            swarmchart(j*ones(length(y{j}),1),y{j},50,colors(j,:),'filled')
            violin(y(j),'facecolor',colors(j,:),'edgecolor',colors(j,:),'x',[j Inf],'plotlegend',0)
        end
    end
    set(gca,'xtick',[2,5,8],'xticklabel',{'block1'; 'block2'; 'block3'})
    ylabel('reaction time [s]')
    ylim([0.3 0.9])
    
    if type == 3
        legend("face","place","object")
    end
end



% accuracy
figure('Color','white')
tiledlayout(1,3)

for type = 1:3
    nexttile
    box on
    title(titles(type))
    hold on
    set(gca,'FontSize',fontsize)
    
    
    y = cell(9,1);
    for i = 1:height(data_ana002)
        if data_ana002.type(i) == type
            
            y{1} = [y{1}; data_ana002.acc_face_encoding1(i)];
            y{2} = [y{2}; data_ana002.acc_space_encoding1(i)];
            y{3} = [y{3}; data_ana002.acc_object_encoding1(i)];
            
            y{4} = [y{4}; data_ana002.acc_face_encoding2(i)];
            y{5} = [y{5}; data_ana002.acc_space_encoding2(i)];
            y{6} = [y{6}; data_ana002.acc_object_encoding2(i)];
            
            y{7} = [y{7}; data_ana002.acc_face_encoding3(i)];
            y{8} = [y{8}; data_ana002.acc_space_encoding3(i)];
            y{9} = [y{9}; data_ana002.acc_object_encoding3(i)];
            
        end
    end
    
    colors = repmat([red;green;gray],3,1);
    plot([1 4 7],[mean(y{1}) mean(y{4}) mean(y{7})],'.-','Color',red)
    plot([2 5 8],[mean(y{2}) mean(y{5}) mean(y{8})],'.-','Color',green)
    plot([3 6 9],[mean(y{3}) mean(y{6}) mean(y{9})],'.-','Color',gray)
    for j=1:9
        if ~isempty(y{j})
            swarmchart(j*ones(length(y{j}),1),y{j},50,colors(j,:),'filled')
            violin(y(j),'facecolor',colors(j,:),'edgecolor',colors(j,:),'x',[j Inf],'plotlegend',0)
        end
    end
    set(gca,'xtick',[2,5,8],'xticklabel',{'block1'; 'block2'; 'block3'})
    ylabel('accuracy')
    ylim([0.2 1.2])
    if type == 3
        legend("face","place","object")
    end
    
    
end


% RETRIEVAL
figure('Color','white')
tiledlayout(1,3)

% precision
for type = 1:3
    nexttile
    box on
    title(titles(type))
    hold on
    set(gca,'FontSize',fontsize)
    
    
    y = cell(9,1);
    for i = 1:height(data_ana002)
        if data_ana002.type(i) == type
            
            y{1} = [y{1}; data_ana002.acc_face_retrieval(i)];
            y{2} = [y{2}; data_ana002.acc_space_retrieval(i)];
            y{3} = [y{3}; data_ana002.acc_object_retrieval(i)];
            
            
        end
    end
    
    colors = [red;green;gray];
    for j=1:3
        if ~isempty(y{j})
            swarmchart(j*ones(length(y{j}),1),y{j},50,colors(j,:),'filled')
        end
    end
    for j=1:3
        if ~isempty(y{j})
            violin(y(j),'facecolor',colors(j,:),'edgecolor',colors(j,:),'x',[j Inf],'plotlegend',0)
        end
    end
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    ylabel('L2 precision [pixel]')
    ylim([1 1000])
    if type == 3
        legend("face","place","object")
    end
    
end



% SECRET JOB
figure('Color','white')
box on
hold on
set(gca,'FontSize',fontsize)

% precision
for type = 1:3
    y = cell(3,1);
    for i = 1:height(data_ana002)
        if data_ana002.type(i) == type
            
            y{1} = [y{1}; data_ana002.acc_face_secretjob(i)];
            y{2} = [y{2}; data_ana002.acc_space_secretjob(i)];
            y{3} = [y{3}; data_ana002.acc_object_secretjob(i)];
            
            
        end
    end
    
    colors = [red;green;gray];
    for j=1:3
        if ~isempty(y{j})
            
            y_temp = sum(y{j},'omitnan')/sum(~isnan(y{j}));
            if type == 2 && j ~= 3
                x_temp = type-0.02+(j-1)*0.04; % special case: overlap of two values
            else
                x_temp = type;
            end
            scatter(x_temp,y_temp,50,colors(j,:),'filled')
        end
    end
    
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    ylabel('mean accuracy')
    if type == 3
        legend("face","place","object")
    end
    set(gca,'xtick',[1,2,3],'xticklabel',{'spies'; 'criminals'; 'neutral'})
    xlim([0.8 3.2])
    ylim([0 1])
    
    
    
end



