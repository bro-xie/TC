function [label] = receiving(obj, pk_enc, info_enc)
    uniform_0_1 = rand;
    if (uniform_0_1 < obj.p_e)
        label = false;
    else
        obj.pk_enc = pk_enc;
        obj.info_enc = info_enc;
        obj.enc_sequence = [obj.enc_sequence, obj.pk_enc];
        obj.receiving_num = obj.receiving_num + 1;
        label = true;
    end
end

