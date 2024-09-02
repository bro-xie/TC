function [pk_enc, info_enc] = gen_pk_enc(pk_src_set, type_of_degree)
    K = size (pk_src_set, 1);
    L = size (pk_src_set, 2);
    pk_enc = false (1, L);

    degree_of_pk_enc = [];
    if (type_of_degree == 1)
        degree_of_pk_enc = round (log (K));
    elseif (type_of_degree == 2)
        uniform_0_1 = rand;
        ideal_soliton_distrib = gen_ideal_solition_distrib (K);
        degree_of_pk_enc = bi_search (ideal_soliton_distrib, uniform_0_1);
    else
        uniform_0_1 = rand;
        robust_soliton_distrib = gen_robust_soliton_distrib (K, 0.3, 0.5);
        degree_of_pk_enc = bi_search (robust_soliton_distrib, uniform_0_1);
    end

    %select src_ID uniformly.
    info_enc = zeros (1, degree_of_pk_enc);
    for index = 1 : degree_of_pk_enc
        pk_src_ID = round (rand * (K - 1) + 1);
        while (~isempty (find (info_enc (1, :) == pk_src_ID, 1)))
            pk_src_ID = round (rand * (K - 1) + 1);
        end
        info_enc (index) = pk_src_ID;
    end
    
    % get xor_sum.
    for index = 1 : degree_of_pk_enc
        pk_src_ID = info_enc (index);
        pk_enc = xor (pk_enc, pk_src_set (pk_src_ID, :));
    end
end

