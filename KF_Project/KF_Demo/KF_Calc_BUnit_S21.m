% base code

function [o_x_cur, o_p_cur]= KF_Calc_BUnit_S21(i_Q, i_R, i_x_cur, i_p_cur, i_u, i_z)
    
    x_cur = i_x_cur;
    p_cur = i_p_cur;
    u = i_u;
    z = i_z;
    
    mat_Q = eye(2).*i_Q;
    mat_R = eye(1).*i_R;
    mat_I = eye(2);
    mat_B = eye(2);
    mat_F = [1 1; 0 1];
    mat_H = [1 0];
    
    % predict
    x_nxt = mat_F*x_cur + mat_B*u;
    p_nxt = mat_F*p_cur*mat_F' + mat_Q;
    
    % update
    k_cur = p_nxt*mat_H'*(mat_H*p_nxt*mat_H' + mat_R)^(-1);
    x_cur = x_nxt + k_cur*(z - mat_H*x_nxt);
    p_cur = (mat_I - k_cur*mat_H)*p_nxt;
    
    o_x_cur = x_cur;
    o_p_cur = p_cur;
end