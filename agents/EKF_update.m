function [P_new, x_hat_new] = EKF_update(P_pred, x_hat_pred, H, R, innovation)
    % EKF_UPDATE    Update step for EKF
    % Inputs:
    %   P_pred: Predicted covariance matrix
    %   x_hat_pred: Predicted state estimate
    %   H: Measurement Jacobian evaluated at predicted state
    %   R: Measurement noise covariance
    %   innovation: Measurement residual

    S = H * P_pred * H' + R;
    K = P_pred * H' * invert_matrix(S);
    
    x_hat_new = x_hat_pred + K * innovation;
    P_new = (eye(size(P_pred)) - K * H) * P_pred;
   
end
