% matrix simple code

function [o_x_cur, o_p_cur, o_k_cur_pos]= KF_Calc_SUnit_Fixed_S3(i_Q, i_R, i_z) %#codegen
    
    % input is wire but hold as reg
    z = i_z;
    Q = i_Q;
    R = i_R;

    % reg define start
    persistent x_cur p_cur
    % reg define end
    
    if isempty(x_cur)
        x_cur = [0; 1];
    end
    
    if isempty(p_cur)
        p_cur = eye(2).*10;
    end
    
    % wire define start
    x_nxt_pre = zeros(2,1);
    x_nxt = zeros(2,1);
    p_nxt = zeros(2,2);
    k_cur_pre = zeros(2,1);
    k_cur_pos = zeros(1,1);
    k_cur_pos_inv = zeros(1,1);
    k_cur = zeros(2,1);
    x_cur_pos = zeros(1,1);
    p_cur_pre = zeros(2,2);
    % wire define end
    
    % predict
    x_nxt_pre(1,1) = (x_cur(1,1) + x_cur(2,1));
    x_nxt_pre(2,1) = x_cur(2,1);

    x_nxt(1,1) = x_nxt_pre(1,1);
    x_nxt(2,1) = x_nxt_pre(2,1);

    p_nxt(1,1) = (p_cur(1,1) + p_cur(2,1)) + ...
                 (p_cur(1,2) + p_cur(2,2)) + Q;
    p_nxt(1,2) = (p_cur(1,2) + p_cur(2,2));
    p_nxt(2,1) = (p_cur(2,1) + p_cur(2,2));
    p_nxt(2,2) = (p_cur(2,2) + Q);

    % update
    k_cur_pre(1,1) = p_nxt(1,1);
    k_cur_pre(2,1) = p_nxt(2,1);

    k_cur_pos(1,1) = (p_nxt(1,1) + R);

    if k_cur_pos(1,1) < .2e-1
        k_cur_pos(1,1) = .2e-1;
    end

    o_k_cur_pos = k_cur_pos(1,1); % for fixed divider
    k_cur_pos_inv(1,1) = 1/k_cur_pos(1,1);

    k_cur(1,1) = (k_cur_pre(1,1)*k_cur_pos_inv(1,1));
    k_cur(2,1) = (k_cur_pre(2,1)*k_cur_pos_inv(1,1));

    x_cur_pos(1,1) = (z(1,1) - x_nxt(1,1));

    x_cur(1,1) = (x_nxt(1,1) + (k_cur(1,1)*x_cur_pos(1,1)));
    x_cur(2,1) = (x_nxt(2,1) + (k_cur(2,1)*x_cur_pos(1,1)));

    p_cur_pre(1,1) = (1 - k_cur(1,1));
    p_cur_pre(1,2) = 0;
    p_cur_pre(2,1) = (0 - k_cur(2,1));
    p_cur_pre(2,2) = 1;

    p_cur(1,1) = (p_cur_pre(1,1)*p_nxt(1,1) + p_cur_pre(1,2)*p_nxt(2,1));
    p_cur(1,2) = (p_cur_pre(1,1)*p_nxt(1,2) + p_cur_pre(1,2)*p_nxt(2,2));
    p_cur(2,1) = (p_cur_pre(2,1)*p_nxt(1,1) + p_cur_pre(2,2)*p_nxt(2,1));
    p_cur(2,2) = (p_cur_pre(2,1)*p_nxt(1,2) + p_cur_pre(2,2)*p_nxt(2,2));

    o_x_cur = x_cur;
    o_p_cur = p_cur;
end