clc, clear, close all;

Encoder_0 = Encoder ();
Decoder_0 = Decoder ();
decoding_label = false;
while (~decoding_label)
    Encoder_0.gen_pk_enc ();
    [pk_enc, info_enc] = Encoder_0.transmitting ();

    receiving_label = Decoder_0.receiving (pk_enc, info_enc);
    if (~receiving_label)
        continue;
    end


    Decoder_0.update_graph_less_K ();
    if (Decoder_0.receiving_num >= Decoder_0.K)
        Decoder_0.update_graph_more_K ();
        decoding_label = Decoder_0.back_substitution ();
        disp (sum (Encoder_0.data_src == Decoder_0.src_sequence));
    end
    disp (Decoder_0.receiving_num);
end