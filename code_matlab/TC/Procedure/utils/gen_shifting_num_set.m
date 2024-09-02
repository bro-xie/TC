function [shifting_num_set] = gen_shifting_num_set(K, G_s)
    shifting_num_set = cell (K, 1);
    for index_1 = 1 : K
        res = ones (1, index_1);
        if (index_1 > G_s)
            for index_2 = 1 : index_1
                res (index_2) = round ((index_2) / (index_1) * (G_s));
            end
        else
            res = cumsum (res) - 1;
        end
        shifting_num_set{index_1} = res;
    end
end