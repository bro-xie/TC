function update_graph_less_K(obj)
    for bit_enc_index = 1 : length (obj.pk_enc)
        bit_enc_ID = bit_enc_index + length (obj.enc_sequence) - length (obj.pk_enc);
        item_of_enc_bit = [];

        for pk_src_index = 1 : size (obj.info_enc, 2)
            pk_src_ID = obj.info_enc (1, pk_src_index);
            shifting_num = obj.info_enc(2, pk_src_index);
            if (bit_enc_index > shifting_num && bit_enc_index <= shifting_num + obj.L)
                %update graph_src_index
                bit_src_index = bit_enc_index - shifting_num;
                bit_src_ID = (pk_src_ID - 1) * obj.L + bit_src_index;
                if (isempty (obj.graph_src_index {bit_src_ID}))
                    obj.graph_src_index {bit_src_ID} = bit_enc_ID;
                else
                    tmp = obj.graph_src_index {bit_src_ID};
                    obj.graph_src_index {bit_src_ID} = [tmp, bit_enc_ID];
                end

                %update graph_enc_index
                item_of_enc_bit = [item_of_enc_bit, bit_src_ID];
            end
        end
        obj.graph_enc_index {bit_enc_ID} = item_of_enc_bit;
    end
end