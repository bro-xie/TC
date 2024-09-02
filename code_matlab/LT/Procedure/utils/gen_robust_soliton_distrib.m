%% robust_soliton_distrib is a probability mass function.
function [robust_soliton_distrib] = gen_robust_soliton_distrib(K, c, epsilon)
    S = c * log (K / epsilon) * sqrt (K);
    density_1 = zeros (1, K);
    for index = 1 : ceil (K / S) - 1
        density_1 (index) = S / K / index;
    end
    density_1 (ceil (K / S)) = S / K * log (S / epsilon);
    for index = ceil (K / S) + 1 : K
        density_1 (index) = 0;
    end

    density_2 = zeros (1, K);
    density_2 (1) = 1 / K;
    for index = 2 : K
        density_2 (index) = 1 / (index - 1) / index;
    end

    density_3 = density_1 + density_2;
    density_3 = density_3 / sum (density_3);

    robust_soliton_distrib = zeros (1, K);
    robust_soliton_distrib (1) = density_3 (1);
    for index = 2 : K
        robust_soliton_distrib (index) = robust_soliton_distrib (index - 1) + density_3 (index);
    end
end

