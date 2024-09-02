classdef Encoder < handle
    properties (Access = public)
        K;
        L;
        G_s;
        data_src;
        pk_enc;
        info_enc;
        src_opacity;
        transmitting_num;
        shifting_num_set;
    end
    
    methods
        function obj = Encoder (K, L, G_s, data_src, src_opacity)
            obj.K = 400;
            obj.G_s = 8;
            obj.L = 40 * 8;
            obj.pk_enc = [];
            obj.info_enc = [];
            obj.transmitting_num = 0;
            obj.shifting_num_set = [];
            
            if nargin > 0
                obj.K = K;
            end
            if nargin > 1
                obj.L = L;
            end
            if nargin > 2
                obj.G_s = G_s;
            end
            obj.data_src = rand (1, obj.K * obj.L) < 0.5;
            obj.src_opacity = ones (1, obj.K) * obj.K;

            if nargin > 3
                obj.data_src = data_src;
            end
            if nargin > 4
                obj.src_opacity = src_opacity;
            end
        end
        gen_pk_enc (obj);
        gen_shifting_num_set (obj);
        [pk_enc, info_enc] = transmitting (obj);
    end
end