% pk_enc : logical array
% info_enc : info_enc (1, i) -> ith encoded src_pk's ID ; info_enc (2, i)
% -> ith encoded src_pk's shifting number.
function [pk_enc, info_enc, src_opacity] = gen_pk_enc(pk_src_set, G_s, src_opacity, type_of_degree, type_of_src_ID, type_of_shifting)
    K = size (pk_src_set, 1);
    L = size (pk_src_set, 2);
    pk_enc = false (1, L + G_s);

    %% get the degree of current encoded packet.(the distribution of degree : robust soliton distribution.)
    degree_of_pk_enc = [];
    if (type_of_degree == 1)
        degree_of_pk_enc = round (log (K));
    elseif (type_of_degree == 2)
        uniform_0_1 = rand;
        ideal_soliton_distrib = gen_ideal_solition_distrib (K);
        degree_of_pk_enc = bi_search (ideal_soliton_distrib, uniform_0_1);
    else
        uniform_0_1 = rand;
        robust_soliton_distrib = gen_robust_soliton_distrib (K, 0.1, 0.5);
        degree_of_pk_enc = bi_search (robust_soliton_distrib, uniform_0_1);
    end
    
    
    info_enc = zeros (2, degree_of_pk_enc);
    
    %% get ID and shifting number of each pk_src selected randomly, and get pk_enc. (uniform distribution)
    
    % determine pk_srcs' ID first.
    if (type_of_src_ID == 1)
        for index = 1 : degree_of_pk_enc
            pk_src_ID = round (rand * (K - 1) + 1);
            while (~isempty (find (info_enc (1, :) == pk_src_ID, 1)))
                pk_src_ID = round (rand * (K - 1) + 1);
            end
            info_enc (1, index) = pk_src_ID;
        end
    elseif (type_of_src_ID == 2)
        for index = 1 : degree_of_pk_enc
            opacity_distrib = cumsum (src_opacity);
            opacity_distrib = opacity_distrib / opacity_distrib (end);
            uniform_0_1 = rand;
            pk_src_ID = bi_search (opacity_distrib, uniform_0_1);
            while (~isempty (find (info_enc (1, :) == pk_src_ID, 1)))
                uniform_0_1 = rand;
                pk_src_ID = bi_search (opacity_distrib, uniform_0_1);
            end
            info_enc (1, index) = pk_src_ID;
        end
    else
        %待定
    end
    
    if (type_of_shifting == 1)
        for index = 1 : degree_of_pk_enc
            info_enc (2, index) = round (rand * G_s);
        end
    elseif (type_of_shifting == 2)
        % get the opacity vector in current encoding process.
        cur_opacity = zeros (1, degree_of_pk_enc);
        for index = 1 : degree_of_pk_enc
            cur_opacity (index) = src_opacity (info_enc (1, index));
        end
    
        % determing pk_srcs' shifting_num then.
        shifting_num_set = gen_shifting_num_set (K, G_s);
        shifting_num_vector = shifting_num_set {degree_of_pk_enc};
        [~, I] = sort (cur_opacity, "descend");
        l = 1;
        for index = 1 : 2 : degree_of_pk_enc
            info_enc (2, I(index)) = shifting_num_vector (l);
            if (index + 1 <= degree_of_pk_enc)
                info_enc (2, I(index + 1)) = shifting_num_vector (degree_of_pk_enc - l + 1);
            end
            l = l + 1;
        end
    else
        shifting_num_set = gen_shifting_num_set (K, G_s);
        info_enc (2, :) = shifting_num_set;
    end


    % update opacity of pk_srcs related to the encoding process.
    for index = 1 : size (info_enc, 2)
        src_opacity (info_enc (1, index)) = src_opacity (info_enc (1, index)) * 0.75;
    end

    % get the xor sum namely pk_enc at last.
    for index = 1 : degree_of_pk_enc
        pk_src_ID = info_enc (1, index);
        shifting_num = info_enc (2, index);
        shifted_pk_src = false (1, L + G_s);
        shifted_pk_src (1 + shifting_num : L + shifting_num) = pk_src_set (pk_src_ID, :);
        pk_enc = xor (pk_enc, shifted_pk_src);
    end

    %% clear useless pre-zeros and suf-zeros.
    max_shifting_num = max (info_enc (2, :));
    min_shifting_num = min (info_enc (2, :));
    pk_enc = pk_enc (1, 1 + min_shifting_num : L + max_shifting_num);
    info_enc (2, :) = info_enc (2, :) - min_shifting_num;
end