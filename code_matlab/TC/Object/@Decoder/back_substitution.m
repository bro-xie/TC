% src_sequence : 1 * K * L
% label : false means decoding failed, and true means decoding succeeded.
function [label] = back_substitution (obj)
    % initialize.
    label = false;
    %graph_enc_index = graph_enc_index (1 : length (enc_sequence));
    
    enc_d_1_set = [];
    degree_enc = zeros (1, length (obj.enc_sequence));
    for index = 1 : length (degree_enc)
        tmp = obj.graph_enc_index {index};
        degree_enc (index) = length (tmp);
        if (degree_enc (index) == 1)
            enc_d_1_set = [enc_d_1_set, index];
        end
    end
%     if (isempty (enc_d_1_set))
%         disp ("this time is useless.");
%     else
%         disp ("this time is useful.");
%     end
    
    %decoding.
    while (~isempty (enc_d_1_set))
        start_enc_bit_ID = enc_d_1_set (1);
        middle_src_bit_ID = obj.graph_enc_index {start_enc_bit_ID};
        
        % update src_sequence, decoded_src_num.
        obj.src_sequence (middle_src_bit_ID) = obj.enc_sequence (start_enc_bit_ID);
        obj.src_known (middle_src_bit_ID) = true;

        % update graph_enc_index, degree_enc, enc_sequence.
        end_enc_bit_set = obj.graph_src_index {middle_src_bit_ID};
        for index = 1 : length (end_enc_bit_set)
            end_enc_bit_ID = end_enc_bit_set (index);
            % delete middle_src_bit_ID in graph_enc_index {end_enc_bit_ID}.
            tmp = obj.graph_enc_index{end_enc_bit_ID};
            obj.graph_enc_index{end_enc_bit_ID} = tmp (~ismember (tmp, middle_src_bit_ID));

            % set end_enc_bit = end_enc_bit xor middle_src_bit.
            obj.enc_sequence (end_enc_bit_ID) = xor (obj.enc_sequence (end_enc_bit_ID), obj.src_sequence (middle_src_bit_ID));

            %degree_enc minus one.
            degree_enc (end_enc_bit_ID) = degree_enc (end_enc_bit_ID) - 1;

            %update enc_d_1_set
            if (degree_enc (end_enc_bit_ID) == 1)
                enc_d_1_set = [enc_d_1_set, end_enc_bit_ID];
            end
            if (degree_enc (end_enc_bit_ID) == 0)
                % enc_d_1_set (enc_d_1_set == degree_enc (end_enc_bit_ID)) = [];
                enc_d_1_set = enc_d_1_set (~ismember (enc_d_1_set, end_enc_bit_ID));
            end
        end
        % update graph_src_index, degree_src.
        obj.graph_src_index {middle_src_bit_ID} = [];
    end

    if (sum (obj.src_known) == length (obj.src_sequence))
        label = true;
    end
end

