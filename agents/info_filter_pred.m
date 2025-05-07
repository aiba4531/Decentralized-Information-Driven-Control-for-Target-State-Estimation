function [Y_pred, y_pred] = info_filter_pred(Y_prev, y_prev, F, Q)
    % INFO_FILTER_PRED  Prediction step for Information filter
    % Inputs:
    %   Y_prev: Previous information matrix
    %   y_prev: Previous information vector
    %   F: State transition matrix
    %   Q: Process noise covariance

    % Go to state space
    P_prev = invert_matrix(Y_prev);
    x_hat_prev = P_prev * y_prev;

    % Standard State Space Prediction
    x_hat_pred = F * x_hat_prev;
    P_pred = F * P_prev * F' + Q;

    % Transform back to information space
    Y_pred = invert_matrix(P_pred);
    y_pred = Y_pred * x_hat_pred;

end

% --------------- Alternative Implementation ---------------
 
% function [Y_new, y_new] = info_filter_pred(Y_prev, y_prev, F, Q)
%     % INFO_FILTER_PRED  Prediction step for Information filter
% 
%     M = inv(F') * Y_prev * inv(F);
%     L = (eye(size(Y_prev)) - M * inv(M + inv(Q)) );
% 
%     y_new = L * inv(F') * y_prev;
%     Y_new = L * M;
% 
% end


