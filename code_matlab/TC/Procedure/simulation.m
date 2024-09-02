function [redundancy, balance] = simulation(K, L, G_s, p_e, type_of_degree, type_of_src_ID, type_of_shifting)
    %% initialization
    record = zeros (K, K, G_s * 2 + 1);

    transmitting_num = 0;
    receiving_num = 0;
    src_sequence = false (1, K * L);
    src_known = false (1, K * L);
    src_opacity = ones (1, K) * K;
    enc_sequence = [];
    graph_enc_index = cell (round (K * L * 1.5), 1); % every item records the index of src bits related to current item in src_sequence.
    graph_src_index = cell (K * L, 1); % every item records the index of enc bits related to current item in enc_sequence.
    pk_src_set = rand (K, L) < 0.5;
    src_cnt = zeros (1, K);
    
    while (1)
        %% transmitter
        [pk_enc, info_enc, src_opacity] = ...
        gen_pk_enc (pk_src_set, G_s, src_opacity, type_of_degree, type_of_src_ID, type_of_shifting);
        transmitting_num = transmitting_num + 1;
        src_cnt (info_enc (1, :)) = src_cnt (info_enc (1, :)) + 1;

        for index_1 = 1 : size (info_enc, 2)
            for index_2 = index_1 + 1 : size (info_enc, 2)
                ID_1 = info_enc (1, index_1);
                ID_2 = info_enc (1, index_2);
                shift = info_enc (2, index_1) - info_enc (2, index_2) + G_s + 1;
                record (ID_1, ID_2, shift) = record (ID_1, ID_2, shift) + 1;
                record (ID_2, ID_1, shift) = record (ID_2, ID_1, shift) + 1;
            end
        end
        
        %% channel
        uniform_0_1 = rand;
        if (uniform_0_1 < p_e)
            continue;
        end
        
        %% receiver
        receiving_num = receiving_num + 1;
        enc_sequence = [enc_sequence, pk_enc];

        [graph_src_index, graph_enc_index] = ...
        update_graph (pk_enc, info_enc, enc_sequence, graph_src_index, graph_enc_index, L);
    
        % check if receiving_num achieves K.
        if (receiving_num < K)
            continue;
        end

        
        [enc_sequence, graph_src_index, graph_enc_index] = ...
        correct_graph_after_K (enc_sequence, src_sequence, src_known, pk_enc, graph_src_index, graph_enc_index);
    
        % back-substitution.
        [src_sequence, src_known, enc_sequence, graph_enc_index, graph_src_index, label] = ...
        back_substitution (enc_sequence, src_sequence, src_known, graph_enc_index, graph_src_index);
        
        check_sum = 0;
        for tmp = 0 : K - 1
            tmp_1 = src_sequence (tmp * L + 1 : tmp * L + L) == pk_src_set (tmp + 1, :);
            check_sum = check_sum + sum (tmp_1);
        end
        disp ("check_sum : " + string(check_sum));
        if (label == true || check_sum == K * L)
            break;
        end
    end
    redundancy = length (enc_sequence) / length (src_sequence) - 1;
    balance = var (src_cnt);
end