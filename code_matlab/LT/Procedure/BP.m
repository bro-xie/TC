function [pk_enc_set, want_src_set, graph_enc_index, graph_src_index, src_known, label] = ...
            BP (pk_enc_set, want_src_set, graph_enc_index, graph_src_index, src_known)
    
    % initialize.
    label = false;
    M = size (pk_enc_set, 1);
    
    % get pk_enc whose degree is 1.
    enc_d_1_set = [];
    degree_enc = zeros (1, M);
    for index = 1 : M
        tmp = graph_enc_index {index};
        degree_enc (index) = length (tmp);
        if (degree_enc (index) == 1)
            enc_d_1_set = [enc_d_1_set, index];
        end
    end

    % decoding.
    while (~isempty (enc_d_1_set))
        start_enc_ID = enc_d_1_set (1);
        middle_src_ID = graph_enc_index {start_enc_ID};
        
        % update src_sequence, decoded_src_num.
        want_src_set (middle_src_ID, :) = pk_enc_set (start_enc_ID, :);
        src_known (middle_src_ID) = true;

        % update graph_enc_index, degree_enc, enc_sequence.
        end_enc_set = graph_src_index {middle_src_ID};
        for index = 1 : length (end_enc_set)
            end_enc_ID = end_enc_set (index);
            % delete middle_src_bit_ID in graph_enc_index {end_enc_bit_ID}.
            tmp = graph_enc_index{end_enc_ID};
            graph_enc_index{end_enc_ID} = tmp (~ismember (tmp, middle_src_ID));

            % set end_enc_bit = end_enc_bit xor middle_src_bit.
            pk_enc_set (end_enc_ID, :) = xor (pk_enc_set (end_enc_ID, :), want_src_set (middle_src_ID, :));

            %degree_enc minus one.
            degree_enc (end_enc_ID) = degree_enc (end_enc_ID) - 1;

            %update enc_d_1_set
            if (degree_enc (end_enc_ID) == 1)
                enc_d_1_set = [enc_d_1_set, end_enc_ID];
            end
            if (degree_enc (end_enc_ID) == 0)
                % enc_d_1_set (enc_d_1_set == degree_enc (end_enc_bit_ID)) = [];
                enc_d_1_set = enc_d_1_set (~ismember (enc_d_1_set, end_enc_ID));
            end
        end
        % update graph_src_index, degree_src.
        graph_src_index {middle_src_ID} = [];
    end

    if (sum (src_known) == size (want_src_set, 1))
        label = true;
    end
end

