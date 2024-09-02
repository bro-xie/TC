% pk_enc : logical array
% obj.info_enc : obj.info_enc (1, i) -> ith encoded src_pk's ID ; obj.info_enc (2, i)
% -> ith encoded src_pk's shifting number.
function gen_pk_enc(obj)
    K = obj.K;
    L = obj.L;
    obj.pk_enc = false (1, obj.L + obj.G_s);

    %% get the degree of current encoded packet.(the distribution of degree : robust soliton distribution.)
    uniform_0_1 = rand;
    ideal_soliton_distrib = gen_ideal_solition_distrib (K);
    degree_of_pk_enc = bi_search (ideal_soliton_distrib, uniform_0_1);
    degree_of_pk_enc = round (log (K));

    obj.info_enc = zeros (2, degree_of_pk_enc);
    
    %% get ID and shifting number of each pk_src selected randomly, and get pk_enc. (uniform distribution)
    
    % determine pk_srcs' ID first.
    for index = 1 : degree_of_pk_enc
        opacity_distrib = cumsum (obj.src_opacity);
        opacity_distrib = opacity_distrib / opacity_distrib (end);

        uniform_0_1 = rand;
        pk_src_ID = bi_search (opacity_distrib, uniform_0_1);
        %pk_src_ID = obj.gen_ID_of_pk_src (K, "opacity", cumsum_opacity);
        while (~isempty (find (obj.info_enc (1, :) == pk_src_ID, 1)))
            uniform_0_1 = rand;
            pk_src_ID = bi_search (opacity_distrib, uniform_0_1);
        end
        obj.info_enc (1, index) = pk_src_ID;
    end

    % get the opacity vector in current encoding process.
    cur_opacity = zeros (1, degree_of_pk_enc);
    for index = 1 : degree_of_pk_enc
        cur_opacity (index) = obj.src_opacity (obj.info_enc (1, index));
    end

    obj.gen_shifting_num_set ();
    %set = obj.shifting_num_set;
    %shifting_num_set = gen_shifting_num_set (400, 8);
    shifting_num_vector = obj.shifting_num_set{degree_of_pk_enc};
    %shifting_num_vector = shifting_num_set {degree_of_pk_enc};
    [~, I] = sort (cur_opacity, "descend");
    l = 1;
    for index = 1 : 2 : degree_of_pk_enc
        obj.info_enc (2, I(index)) = shifting_num_vector (l);
        if (index + 1 <= degree_of_pk_enc)
            obj.info_enc (2, I(index + 1)) = shifting_num_vector (degree_of_pk_enc - l + 1);
        end
        l = l + 1;
    end

    % update opacity of pk_srcs related to the encoding process.
    for index = 1 : size (obj.info_enc, 2)
        obj.src_opacity (obj.info_enc (1, index)) = obj.src_opacity (obj.info_enc (1, index)) - 1;
    end

    % get the xor sum namely pk_enc at last.
    for index = 1 : degree_of_pk_enc
        pk_src_ID = obj.info_enc (1, index);
        shifting_num = obj.info_enc (2, index);
        shifted_pk_src = false (1, L + obj.G_s);
        %shifted_pk_src (1 + shifting_num : L + shifting_num) = obj.pk_src_set (pk_src_ID, :);
        shifted_pk_src (1 + shifting_num : L + shifting_num) = obj.data_src (1 + (pk_src_ID - 1) * obj.L : pk_src_ID * obj.L);
        obj.pk_enc = xor (obj.pk_enc, shifted_pk_src);
    end

    %% clear useless pre-zeros and suf-zeros.
    max_shifting_num = max (obj.info_enc (2, :));
    min_shifting_num = min (obj.info_enc (2, :));
    obj.pk_enc = obj.pk_enc (1, 1 + min_shifting_num : L + max_shifting_num);
    obj.info_enc (2, :) = obj.info_enc (2, :) - min_shifting_num;
end