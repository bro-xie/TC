classdef Decoder < handle
    properties (Access = public)
        K;
        L;
        p_e;
        G_s;
        pk_enc;
        info_enc;
        receiving_num;
        graph_enc_index;
        graph_src_index;
        enc_sequence;
        src_sequence;
        src_known;
    end
    
    methods
        function obj = Decoder (K, L, G_s, p_e)
            obj.K = 400;
            obj.L = 8 * 40;
            obj.p_e = 0.1;
            obj.G_s = 8;
            if nargin > 0
                obj.K = K;
            end
            if nargin > 1
                obj.L = L;
            end
            if nargin > 2
                obj.G_s = G_s;
            end
            if nargin > 3
                obj.p_e = p_e;
            end
            obj.pk_enc = [];
            obj.info_enc = [];
            obj.receiving_num = 0;
            obj.graph_enc_index = cell (round (obj.K * obj.L * 1.5), 1);
            obj.graph_src_index = cell (obj.K * obj.L, 1);
            obj.enc_sequence = [];
            obj.src_sequence = false (1, obj.K * obj.L);
            obj.src_known = false (1, obj.K * obj.L);
        end 
        [label] = receiving (obj, pk_enc, info_enc);
        update_graph_less_K (obj);
        update_graph_more_K (obj);
        [label] = back_substitution (obj);
    end
end