% matrix flatten code

function [o_x_cur, o_p_cur]= KF_Calc_FUnit_S22(i_Q, i_R, i_x_cur, i_p_cur, i_u, i_z)
    
    x_cur = i_x_cur;
    p_cur = i_p_cur;
    u = i_u;
    z = i_z;
    
    % x_cur_ = i_x_cur;
    % p_cur_ = i_p_cur;
    % u_ = i_u;
    % z_ = i_z;

    mat_Q = eye(2).*i_Q;
    mat_R = eye(1).*i_R;
    mat_I = eye(2);
    mat_B = eye(2);
    mat_F = [1 1; 0 1];
    mat_H = [1 0];
    
    % predict
    % % x_nxt_ = mat_F*x_cur_ + mat_B*u_;
    x_nxt_pos(1,1) = (mat_B(1,1)*u(1,1) + mat_B(1,2)*u(2,1));
    x_nxt_pos(2,1) = (mat_B(2,1)*u(1,1) + mat_B(2,2)*u(2,1));

    x_nxt_pre(1,1) = (mat_F(1,1)*x_cur(1,1) + mat_F(1,2)*x_cur(2,1));
    x_nxt_pre(2,1) = (mat_F(2,1)*x_cur(1,1) + mat_F(2,2)*x_cur(2,1));

    x_nxt(1,1) = (x_nxt_pre(1,1) - x_nxt_pos(1,1));
    x_nxt(2,1) = (x_nxt_pre(2,1) - x_nxt_pos(2,1));

    % % p_nxt_ = mat_F*p_cur_*mat_F' + mat_Q;
    p_nxt(1,1) = (mat_F(1,1)*p_cur(1,1) + mat_F(1,2)*p_cur(2,1))*mat_F(1,1) + ...
                 (mat_F(1,1)*p_cur(1,2) + mat_F(1,2)*p_cur(2,2))*mat_F(1,2) + mat_Q(1,1);

    p_nxt(1,2) = (mat_F(1,1)*p_cur(1,1) + mat_F(1,2)*p_cur(2,1))*mat_F(2,1) + ...
                 (mat_F(1,1)*p_cur(1,2) + mat_F(1,2)*p_cur(2,2))*mat_F(2,2) + mat_Q(1,2);

    p_nxt(2,1) = (mat_F(2,1)*p_cur(1,1) + mat_F(2,2)*p_cur(2,1))*mat_F(1,1) + ...
                 (mat_F(2,1)*p_cur(1,2) + mat_F(2,2)*p_cur(2,2))*mat_F(1,2) + mat_Q(2,1);

    p_nxt(2,2) = (mat_F(2,1)*p_cur(1,1) + mat_F(2,2)*p_cur(2,1))*mat_F(2,1) + ...
                 (mat_F(2,1)*p_cur(1,2) + mat_F(2,2)*p_cur(2,2))*mat_F(2,2) + mat_Q(2,2);

    % update
    % % k_cur_ = p_nxt_*mat_H'*(mat_H*p_nxt_*mat_H' + mat_R)^(-1);
    k_cur_pre(1,1) = (p_nxt(1,1)*mat_H(1,1) + p_nxt(1,2)*mat_H(1,2));
    k_cur_pre(2,1) = (p_nxt(2,1)*mat_H(1,1) + p_nxt(2,2)*mat_H(1,2));

    k_cur_pos(1,1) = (mat_H(1,1)*p_nxt(1,1) + mat_H(1,2)*p_nxt(2,1))*mat_H(1,1) + ...
                     (mat_H(1,1)*p_nxt(1,2) + mat_H(1,2)*p_nxt(2,2))*mat_H(1,2) + ...
                     mat_R(1,1);

    k_cur_pos_inv(1,1) = 1/k_cur_pos(1,1);

    k_cur(1,1) = (k_cur_pre(1,1)*k_cur_pos_inv(1,1));
    k_cur(2,1) = (k_cur_pre(2,1)*k_cur_pos_inv(1,1));

    % % x_cur_ = x_nxt_ + k_cur_*(z_ - mat_H*x_nxt_);
    x_cur_pos(1,1) = (z(1,1) - (mat_H(1,1)*x_nxt(1,1) + mat_H(1,2)*x_nxt(2,1)));

    x_cur(1,1) = (x_nxt(1,1) + (k_cur(1,1)*x_cur_pos(1,1)));
    x_cur(2,1) = (x_nxt(2,1) + (k_cur(2,1)*x_cur_pos(1,1)));

    % % p_cur_ = (mat_I - k_cur_*mat_H)*p_nxt_;
    p_cur_pre(1,1) = (mat_I(1,1) - (k_cur(1,1)*mat_H(1,1)));
    p_cur_pre(1,2) = (mat_I(1,2) - (k_cur(1,1)*mat_H(1,2)));
    p_cur_pre(2,1) = (mat_I(2,1) - (k_cur(2,1)*mat_H(1,1)));
    p_cur_pre(2,2) = (mat_I(2,2) - (k_cur(2,1)*mat_H(1,2)));

    p_cur(1,1) = (p_cur_pre(1,1)*p_nxt(1,1) + p_cur_pre(1,2)*p_nxt(2,1));
    p_cur(1,2) = (p_cur_pre(1,1)*p_nxt(1,2) + p_cur_pre(1,2)*p_nxt(2,2));
    p_cur(2,1) = (p_cur_pre(2,1)*p_nxt(1,1) + p_cur_pre(2,2)*p_nxt(2,1));
    p_cur(2,2) = (p_cur_pre(2,1)*p_nxt(1,2) + p_cur_pre(2,2)*p_nxt(2,2));

    o_x_cur = x_cur;
    o_p_cur = p_cur;
end