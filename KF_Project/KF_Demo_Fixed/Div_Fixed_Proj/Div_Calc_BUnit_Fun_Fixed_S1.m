% base code
function [o_q]= Div_Calc_BUnit_Fun_Fixed_S1(i_z, i_d) %#codegen

    % input is wire
    abs_z = double(i_z);
    abs_d = double(i_d);

    % reg define start
    loop_cnt = 0;
    iter_cnt = 7;
    z = zeros(1,iter_cnt);
    d = zeros(1,iter_cnt);
    % reg define end

    % step 1: normal ensure d less than 2^-1
    loop_abs = abs_d*65536;
    bit_sel = bitget(loop_abs, 1:32, 'uint32');
    if bit_sel(22) == 1
        loop_cnt = 6;
    elseif bit_sel(21) == 1
        loop_cnt = 5;
    elseif bit_sel(20) == 1
        loop_cnt = 4;
    elseif bit_sel(19) == 1
        loop_cnt = 3;
    elseif bit_sel(18) == 1
        loop_cnt = 2;
    elseif bit_sel(17) == 1
        loop_cnt = 1;
    elseif bit_sel(16) == 1
        loop_cnt = 0;
    elseif bit_sel(15) == 1
        loop_cnt = -1;
    elseif bit_sel(14) == 1
        loop_cnt = -2;
    elseif bit_sel(13) == 1
        loop_cnt = -3;
    elseif bit_sel(12) == 1
        loop_cnt = -4;
    elseif bit_sel(11) == 1
        loop_cnt = -5;
    elseif bit_sel(10) == 1
        loop_cnt = -6;
    elseif bit_sel(9) == 1
        loop_cnt = -7;
    elseif bit_sel(8) == 1
        loop_cnt = -8;
    elseif bit_sel(7) == 1
        loop_cnt = -9;
    else
        loop_cnt = 0;
    end

    % loop_abs = abs_d;
    % while loop_abs > 1
    %     % loop_abs = loop_abs * 0.5; % bitshift
    %     loop_abs = bitsra(loop_abs, 1);
    %     loop_cnt = loop_cnt + 1;
    % end
    % 
    % while loop_abs < 0.5
    %     % loop_abs = loop_abs * 2; % bitshift
    %     loop_abs = bitsll(loop_abs, 1);
    %     loop_cnt = loop_cnt - 1;
    % end
    
    % step 2: init
    z(1,1) = abs_z;
    
    tmp_d = abs_d;
    if loop_cnt >= 0
        tmp_d = bitsra(tmp_d, abs(loop_cnt));
    else
        tmp_d = bitsll(tmp_d, abs(loop_cnt));
    end

    % for idx_i = 1:abs(loop_cnt) % bitshift
        % if loop_cnt >= 0
        %     tmp_d = tmp_d * 0.5;
        % else
        %     tmp_d = tmp_d * 2;
        % end
    % end

    % d(1,1) = abs_d*2^(-loop_cnt);
    d(1,1) = tmp_d;
    
    % step 3: iter
    mul_factor = (2 - d(1,1));
    for idx_i = 2:iter_cnt
        z(1,idx_i) = z(1,idx_i-1) * mul_factor;
        d(1,idx_i) = d(1,idx_i-1) * mul_factor;
        mul_factor = (2 - d(1,idx_i));
    end
    
    % step 4: recover
    tmp_z = z(1,iter_cnt);
    if loop_cnt >= 0
        tmp_z = bitsra(tmp_z, abs(loop_cnt));
    else
        tmp_z = bitsll(tmp_z, abs(loop_cnt));
    end

    % for idx_i = 1:abs(loop_cnt) % bitshift
        % if loop_cnt >= 0
        %     tmp_z = tmp_z * 0.5;
        % else
        %     tmp_z = tmp_z * 2;
        % end
    % end
    
    q = tmp_z;

    o_q = q;
end