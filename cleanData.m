function [x_cleaned, i_cleaned] = cleanData(x,cutoff_sigma)
    
    mu = mean(x);
    sigma = sqrt(var(x));    
   
    i_cleaned = (abs(x - mu) < cutoff_sigma * sigma);
    x_cleaned = x(i_cleaned);

end