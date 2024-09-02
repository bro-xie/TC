function [pk_enc_set, graph_src_index, graph_enc_index] = ...
            correct_graph_after_K(M, pk_enc_set, want_src_set, src_known, graph_src_index, graph_enc_index)
    item_of_enc = graph_enc_index {M};
    new_item_of_enc = graph_enc_index {M};
    for index = 1 : length (item_of_enc)
        pk_src_ID = item_of_enc (index);
        if (src_known (pk_src_ID) == true)
            new_item_of_enc = new_item_of_enc (~(new_item_of_enc == pk_src_ID));
            item_of_src = graph_src_index{pk_src_ID};
            graph_src_index{pk_src_ID} = item_of_src(~(item_of_src == M));
            pk_enc_set (M, :) = xor (pk_enc_set (M, :), want_src_set (pk_src_ID, :));
        end
    end
    graph_enc_index {M} = new_item_of_enc;
end

