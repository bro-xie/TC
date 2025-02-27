% clc, clear, close all;
% addpath ("utils\");
% %dbstop if all error
% % simulation : 1000.
% % epsilon = zeros (1, 500);
% sum = 0;
% balance_redundancy = zeros (3000, 2);
% for cnt = 1 : 500
%     [redundancy, balance] = simulation (768, 40 * 8, 32, 0, 3, 2, 1);
%     disp (redundancy);
%     sum = sum + redundancy;
%     exp_redundancy = sum / cnt;
%     balance_redundancy (cnt, 1) = balance;
%     balance_redundancy (cnt, 2) = redundancy;
% end


%% 4.2节实验数据记录
% K = 16 
    % G_s = 4  : 0.0543
    % G_s = 8  : 0.0443
    % G_s = 16 : 0.0494
    % G_s = 32 : 0.0690

% K = 64
    % G_s = 4  : 0.0348
    % G_s = 8  : 0.0282
    % G_s = 16 : 0.0362
    % G_s = 32 : 0.0593

% K = 128
    % G_s = 4  : 0.0308
    % G_s = 8  : 0.0265
    % G_s = 16 : 0.0334
    % G_s = 32 : 0.0585

% K = 256
    % G_s = 4  : 0.0268
    % G_s = 8  : 0.0243
    % G_s = 16 : 0.033
    % G_s = 32 : 0.057

% K = 512
    % G_s = 4  : 0.0228(95) 0.0230(177) 0.0230(268)
    % G_s = 8  : 0.0210(69) 0.0213(129) 0.0214(176) 0.0217(227)
    % G_s = 16 : 0.0321(54) 0.0320(101) 0.0319(184)
    % G_s = 32 : 0.0569(78) 0.0568(111)

% K = 768
    % G_s = 4  : 0.0191
    % G_s = 8  : 0.0208
    % G_s = 16 : 0.0313
    % G_s = 32 : 0.0562
    
% K = 1024
    % G_s = 4  : 0.0176(47) 0.0176(61) 0.0176(123)
    % G_s = 8  : 0.0203
    % G_s = 16 : 0.0304(100)
    % G_s = 32 : 0.0562

%% K =128 G_s = 8 L = 40 * 8

% 3 2 2
% c = 0.1 epsilon = 0.5 : 0.029 (opacity一次减20%)

%% K = 400 G_s = 8 L = 40 * 8
% 仿真记录 (c = 0.3 epsilon = 0.5)

% 3 2 2 : 0.078 (opacity一次减1 )
% 3 2 2 : 0.054 (opacity一次减2%)
% 3 2 2 : 0.040 (opacity一次减5%)
% 3 2 2 : 0.028 (opacity一次减10%)
% 3 2 2 : 0.0262 (opacity一次减15%)

% 测试最优robust soliton参数 (3 2 2 opacity一次减15%)
% c = 0.3 epsilon = 0.5 : 0.0262
% c = 0.2 epsilon = 0.5 : 0.0242

%% K = 500 G_s = 8 L = 40 * 8

% 测试最优robust soliton参数 (3 1 1) 
% c = 0.15 epsilon = 0.5 : 0.037
% c = 0.1 epsilon = 0.5 : 0.026        √
% c = 0.07 epsilon = 0.5 : 0.032
% c = 0.1 epsilon = 0.4 : 
% c = 0.07 epsilon = 0.7 : 0.0416
% c = 0.1 epsilon = 0.3 : 0.035 0.027 0.027

% 3 2 2
% c = 0.1 epsilon = 0.5 : 0.0226    （opacity一次减%15）
% c = 0.1 epsilon = 0.5 : 0.0212    （opacity一次减%40）



%% figure part. 
clc,clear, close all;
load ("numerical results\relation_redundancy_and_var\balance_redundancy_128_320_3000.mat");

subplot (1, 2, 1)
plot (balance_redundancy (:, 1), balance_redundancy (:, 2), 'rx', LineWidth=1.3);
xlabel ("$v$","Interpreter","latex", "FontSize",15);
ylabel ("$\epsilon$","Interpreter","latex", "FontSize",15);

grid on
[sorted_redundancy, index] = sort (balance_redundancy (:, 2));
sorted_balance = balance_redundancy (index, 1);

% save ("balance_redundancy_128_320_3000.mat", "balance_redundancy");


subplot (1, 2, 2)


discrete_redundancy = cell (1, 18);
discrete_balance = cell (1, 18);
discrete_cnt = zeros (1, 18);
for cnt = 1 : 3000
    balance =balance_redundancy (cnt, 1);
    redundancy =balance_redundancy (cnt, 2);
    index = floor (redundancy * 10) + 1;
    tmp = discrete_balance {index};
    tmp = [tmp; balance];
    discrete_balance {index} = tmp;
    discrete_redundancy {index} = [discrete_redundancy {index}, redundancy];
    discrete_cnt = discrete_cnt + 1;
end

for cnt = 1 : 18
    tmp = discrete_balance {index};
    tmp = mean (tmp);
    discrete_balance {index} = tmp;
    tmp = discrete_redundancy {index};
    tmp = mean (tmp);
    discrete_redundancy {index} = tmp;
end

% for gap_redanduncy = 0 : 0.1 : sorted_redundancy (end)
%     index_start = bi_search (sorted_redundancy, gap_redanduncy) - 1;
%     index_end = bi_search (sorted_redundancy, gap_redanduncy + 0.1) - 1;
% 
%     while (sorted_redundancy (index_end) < gap_redanduncy)
%         index_end = index_end + 1;
%     end
%     tmp = mean (sorted_redundancy (index_start : index_end));
%     discrete_redundancy = [discrete_redundancy, tmp];
%     tmp = mean (sorted_balance (index_start : index_end));
%     discrete_balance = [discrete_balance, tmp];
% end

plot (discrete_balance, discrete_redundancy, 'xr', LineWidth=1.3);

xlabel ("$\overline{v}$","Interpreter","latex", "FontSize",15);
ylabel ("$\overline{\epsilon}$","Interpreter","latex", "FontSize",15);
grid on


