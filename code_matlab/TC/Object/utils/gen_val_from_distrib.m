function [val] = gen_val_from_distrib(distrib)
        uniform_0_1 = rand;
        val = bi_search (distrib, uniform_0_1);
end