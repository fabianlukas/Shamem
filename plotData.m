function plotData(x, x_cleaned, participant_id, var_name, structfield, type, path_out)
    figure
    scatter(ones(1,length(x)),x,50,'filled')
    hold on
    scatter(ones(1,length(x_cleaned)),x_cleaned,50,'filled')
    legend('excluded data','cleaned data') 
    figure_name = strcat(sprintf('%03d',participant_id),"_",var_name,"_", structfield, "_", type);
    title(figure_name, 'Interpreter', 'none')
    savefig(strcat(path_out,'/figures/', figure_name))
end

