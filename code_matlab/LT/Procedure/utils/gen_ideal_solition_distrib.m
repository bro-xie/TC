%% ideal_soliton_distrib is a probability mass function.
function [ideal_solition_distrib] = gen_ideal_solition_distrib(K)
    density = zeros (1, K);
    density (1) = 1 / K;
    for index = 2 : K
        density (index) = 1 / (index - 1) / index;
    end
    ideal_solition_distrib = zeros (1, K);
    ideal_solition_distrib (1) = density (1);
    for index = 2 : K
        ideal_solition_distrib (index) = ideal_solition_distrib (index - 1) + density (index);
    end
end

