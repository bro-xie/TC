function [pk_enc, info_enc] = transmitting (obj)
    obj.transmitting_num = obj.transmitting_num + 1;
    pk_enc = obj.pk_enc;
    info_enc = obj.info_enc;
end

