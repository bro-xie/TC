function [redundancy] = simulation(K, L, p_e, type_of_degree)
    %% initialization
    transmitting_num = 0;
    receiving_num = 0;
    want_src_set = false (K, L);
    src_known = false (1, K);
    pk_enc_set = [];
    graph_enc_index = cell (round (K * 3), 1); % every item records the index of src bits related to current item in src_sequence.
    graph_src_index = cell (K, 1); % every item records the index of enc bits related to current item in enc_sequence.
    pk_src_set = rand (K, L) < 0.5;

    while (1)
        %% transmitter
        [pk_enc, info_enc] = gen_pk_enc(pk_src_set, type_of_degree);
        transmitting_num = transmitting_num + 1;
        
        %% channel
        uniform_0_1 = rand;
        if (uniform_0_1 < p_e)
            continue;
        end
        
        %% receiver
        receiving_num = receiving_num + 1;
        pk_enc_set = [pk_enc_set; pk_enc];

        [graph_src_index, graph_enc_index] = update_graph (receiving_num, info_enc, graph_src_index, graph_enc_index);
    
        % check if receiving_num achieves K.
        if (receiving_num < K)
            continue;
        end
        
        [pk_enc_set, graph_src_index, graph_enc_index] = ...
            correct_graph_after_K(receiving_num, pk_enc_set, want_src_set, src_known, graph_src_index, graph_enc_index);
    
        % BP.
        [pk_enc_set, want_src_set, graph_enc_index, graph_src_index, src_known, label] = ...
            BP (pk_enc_set, want_src_set, graph_enc_index, graph_src_index, src_known);
        
        check_sum = sum (pk_src_set == want_src_set, "all");
        disp (check_sum);
        if (label == true || check_sum == K * L)
            break;
        end
    end
    redundancy = size (pk_enc_set, 1) / K - 1;
end