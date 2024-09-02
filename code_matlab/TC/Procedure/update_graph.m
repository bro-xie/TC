function [graph_src_index, graph_enc_index] = update_graph (pk_enc, info_enc, enc_sequence, graph_src_index, graph_enc_index, L)
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
                item_of_enc_bit = [item_of_enc_bit, bit_src_ID];
            end
        end
        graph_enc_index {bit_enc_ID} = item_of_enc_bit;
    end
end

