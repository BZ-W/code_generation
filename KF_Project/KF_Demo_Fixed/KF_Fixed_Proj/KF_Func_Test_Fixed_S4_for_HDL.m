% % KF Function Demo Fixed Compare
% system clear

clc; clear all;

% step 0: config parameters
load("KF_Calc_SUnit_Fixed_Src.m", '-mat');

[~, ~, END_T] = size(x);
DELTA_T = 1;

LEN = length(1:DELTA_T:END_T);

% step 1: set init
k_cur = zeros(2,1,LEN);
x_cur = zeros(2,1,LEN);
p_cur = zeros(2,2,LEN);

x_cur_fix = zeros(2,1,LEN);
p_cur_fix = zeros(2,2,LEN);

% step 2: predict
% step 3: update
for idx_i = 1:LEN

    [o_x_cur, o_p_cur]= KF_Calc_SUnit_Fixed_S3(i_Q(1,idx_i), i_R(1,idx_i), i_z(1,idx_i));
    % [o_x_cur_fix, o_p_cur_fix]= KF_Calc_SUnit_Fixed_S3_wrapper_fixpt(i_Q(1,idx_i), i_R(1,idx_i), i_z(1,idx_i));

    % x_cur_fix(:,:,idx_i) = o_x_cur_fix;
    % p_cur_fix(:,:,idx_i) = o_p_cur_fix;

    x_cur(:,:,idx_i) = o_x_cur;
    p_cur(:,:,idx_i) = o_p_cur;
end

% step 4: disp
% hold off; hold on;
% 
% axis([0 LEN 0 LEN]);
% title('Position Estimation');
% xlabel('time/s');
% ylabel('distance/m');
% 
% y_plot(:) = (1:LEN)-1;
% 
% x_cur_plot(:) = x_cur(1,1,:);
% plot(x_cur_plot, y_plot, 'm-*');
% 
% x_cur_fix_plot(:) = x_cur_fix(1,1,:);
% plot(x_cur_fix_plot, y_plot, 'g-+');
% 
% legend('x\_cur', 'x\_fix', 'Location','northwest');
