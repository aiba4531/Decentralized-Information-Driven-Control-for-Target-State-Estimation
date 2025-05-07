function [I, i] = info_filter_update(Y_pred, y_pred, H, R, innovation, x_hat_pred)
    % INFO_FILTER_UPDATE    Update step for Information filter
    % Inputs:
    %   Y_pred: Predicted information matrix
    %   y_pred: Predicted information vector
    %   H: Measurement Jacobian evaluated at predicted state
    %   R: Measurement noise covariance
    %   z: Measurement vector
    
    R_inv = invert_matrix(R);
    i = H' * R_inv * (innovation + H*x_hat_pred);
    I = H' * R_inv * H;

    y_new = y_pred + i;
    Y_new = Y_pred + I;
end


% ------------- Alternative Implementation -------------
% function [Y_new, y_new] = info_filter_update(Y_prev, y_prev, H, R, innovation)
%     % INFO_FILTER_UPDATE    Update step for Information filter

%     R_inv = inv(R);
%     y_new = y_prev + H' * R_inv * innovation;
%     Y_new = Y_prev + H' * R_inv * H;

% end
