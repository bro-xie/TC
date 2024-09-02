function update_graph_more_K(obj)
    for bit_enc_ID = length (obj.enc_sequence) - length (obj.pk_enc) + 1 : length (obj.enc_sequence)
        tmp = obj.graph_enc_index {bit_enc_ID};
        new_tmp = obj.graph_enc_index {bit_enc_ID};
        for index_tmp = 1 : length (tmp)
            bit_src_ID = tmp (index_tmp);
            if (obj.src_known (bit_src_ID) == true)
                new_tmp = new_tmp (~(new_tmp == bit_src_ID));
                tmp_2 = obj.graph_src_index{bit_src_ID};
                obj.graph_src_index{bit_src_ID} = tmp_2(~(tmp_2 == bit_enc_ID));
                obj.enc_sequence (bit_enc_ID) = xor (obj.enc_sequence (bit_enc_ID), obj.src_sequence (bit_src_ID));
            end
        end
        obj.graph_enc_index {bit_enc_ID} = new_tmp;
    end
end