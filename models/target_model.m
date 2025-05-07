function x_next = target_model(x_current, dt, params)
    % TARGET_MODEL  Predicts the next state of the target based on its dynamics
    % Inputs:
    %   x_current: Current state of the target [x, y, vx, vy]
    %   dt: Time step for prediction
    %   params: Parameters for the simulation

    if params.target.motion == true
        % Constant velocity model
        A = [1 0 dt 0;
            0 1 0 dt;
            0 0 1 0;
            0 0 0 1];
        x_next = A * x_current;

    else
        % No motion model, keep the state unchanged
        x_next = x_current;
    end
end
