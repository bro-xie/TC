function gen_shifting_num_set(obj)
    obj.shifting_num_set = cell (obj.K, 1);
    for index_1 = 1 : obj.K
        res = ones (1, index_1);
        if (index_1 > obj.G_s)
            for index_2 = 1 : index_1
                res (index_2) = round ((index_2) / (index_1) * (obj.G_s));
            end
        else
            res = cumsum (res) - 1;
        end
        obj.shifting_num_set{index_1} = res;
    end
end