clc, clear, close all;

%dbstop if all error
%% initialization
K = 400;
L = 40 * 8;
G_s = 8;
p_e = 0.1;
pk_src_set = false (K, L);

transmitting_num = 0;
receiving_num = 0;
src_sequence = false (1, K * L);
src_known = false (1, K * L);
src_opacity = ones (1, K) * K;
enc_sequence = [];
pk_enc_len = [];
graph_enc_index = cell (round (K * L * 1.5), 1); % every item records the index of src bits related to current item in src_sequence.
%graph_enc_index = cell (0);
graph_src_index = cell (K * L, 1); % every item records the index of enc bits related to current item in enc_sequence.

pk_src_set = rand (K, L) < 0.5;

while (1)
    %% transmitter
    [pk_enc, info_enc, src_opacity] = gen_pk_enc (pk_src_set, G_s, src_opacity);
    transmitting_num = transmitting_num + 1;
    
    %% receiver
%     if (receiving_num > K)
%         disp ("info_enc:");
%         disp (info_enc);
%     end
    % erasure.
    uniform_0_1 = rand;
    if (uniform_0_1 < p_e)
        continue;
    end
    
    receiving_num = receiving_num + 1;
    
    enc_sequence = [enc_sequence, pk_enc];
    tmp = length (pk_enc);
    pk_enc_len = [pk_enc_len, tmp];
    
    % update graph_enc_index and graph_src_index.
    for bit_enc_index = 1 : length (pk_enc)
        bit_enc_ID = bit_enc_index + length (enc_sequence) - length (pk_enc);
        item_of_enc_bit = [];
        for pk_src_index = 1 : size (info_enc, 2)
            pk_src_ID = info_enc (1, pk_src_index);
            shifting_num = info_enc(2, pk_src_index);
            if (bit_enc_index > shifting_num && bit_enc_index <= shifting_num + L)
                %update graph_src_index
                bit_src_index = bit_enc_index - shifting_num;
                bit_src_ID = (pk_src_ID - 1) * L + bit_src_index;
                if (isempty (graph_src_index {bit_src_ID}))
                    graph_src_index {bit_src_ID} = bit_enc_ID;
                else
                    tmp = graph_src_index {bit_src_ID};
                    graph_src_index {bit_src_ID} = [tmp, bit_enc_ID];
                end

                %update graph_enc_index
                item_of_enc_bit = [item_of_enc_bit, bit_src_ID];
            end
        end
        graph_enc_index {bit_enc_ID} = item_of_enc_bit;
    end
    
    
    % check if receiving_num achieves K.
    if (receiving_num < K)
        continue;
    end
    
    for bit_enc_ID = length (enc_sequence) - length (pk_enc) + 1 : length (enc_sequence)
        tmp = graph_enc_index {bit_enc_ID};
        new_tmp = graph_enc_index {bit_enc_ID};
        for index_tmp = 1 : length (tmp)
            bit_src_ID = tmp (index_tmp);
            if (src_known (bit_src_ID) == true)
                new_tmp = new_tmp (~(new_tmp == bit_src_ID));
                tmp_2 = graph_src_index{bit_src_ID};
                graph_src_index{bit_src_ID} = tmp_2(~(tmp_2 == bit_enc_ID));
                enc_sequence (bit_enc_ID) = xor (enc_sequence (bit_enc_ID), src_sequence (bit_src_ID));
            end
        end
        graph_enc_index {bit_enc_ID} = new_tmp;
    end

    % back-substitution.
    
    %[src_sequence, src_known, graph_enc_index, graph_src_index, label] = back_substitution (enc_sequence, src_sequence, src_known, graph_enc_index, graph_src_index);
    [src_sequence, src_known, enc_sequence, graph_enc_index, graph_src_index, label] = back_substitution (enc_sequence, src_sequence, src_known, graph_enc_index, graph_src_index);
    check_sum = 0;
    for tmp = 0 : K - 1
        tmp_1 = src_sequence (tmp * L + 1 : tmp * L + L) == pk_src_set (tmp + 1, :);
        check_sum = check_sum + sum (tmp_1);
    end
    

    disp ("check_sum : " + string(check_sum));
    %disp ("src_known" + string(sum (src_known)));
    if (label == true || check_sum == K * L)
        break;
    end
end
disp ("check_sum : " + string(check_sum));
disp ("number of transmitted packets : " + string (transmitting_num));
disp ("number of received packets : " + string (receiving_num));
disp ("length of source data : " + string(length (src_sequence)));
disp ("length of encoded data : " + string (length (enc_sequence)));