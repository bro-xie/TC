function [enc_sequence, graph_src_index, graph_enc_index] = ...
            correct_graph_after_K (enc_sequence, src_sequence, src_known, pk_enc, graph_src_index, graph_enc_index)
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
end

