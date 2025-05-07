function [P_pred, x_hat_pred] = EKF_pred(P_prev, x_hat_prev, F, Q)
    % EKF_PRED  Prediction step for EKF
    % Inputs:
    %   P_prev: Previous covariance matrix
    %   x_hat_prev: Previous state estimate
    %   F: State transition matrix
    %   Q: Process noise covariance

    x_hat_pred = F * x_hat_prev;
    P_pred = F * P_prev * F' + Q;

end