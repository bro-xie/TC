function [graph_src_index, graph_enc_index] = update_graph (M, info_enc, graph_src_index, graph_enc_index)
% M : current pk_enc is Mth pk_enc.
    degree_of_pk_enc = length (info_enc);
    graph_enc_index {M} = info_enc;
    % update graph_src_index
    for index = 1 : degree_of_pk_enc
        pk_src_ID = info_enc (index);
        tmp = graph_src_index {pk_src_ID};
        tmp = [tmp, M];
        graph_src_index {pk_src_ID} = tmp;
    end
end