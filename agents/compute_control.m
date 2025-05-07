function [u, u_opt] = compute_control(Y, x_hat, agent_state, dt, R, params)
    % COMPUTE_CONTROL   Computes control input that maximizes expected information gain

    % Function agent dynamics model
    predict_state = @(state, u) ground_agent_model(state, u, dt);

    % Precompute R inverse
    R_inv = invert_matrix(R);

    % Standoff distance and nominal speed
    v_nom = params.ground_control.v_nom;
    standoff = params.ground_control.standoff;

    % MI gain cost 
    function cost = InfoCost(u)
        cost = 0;
        state = agent_state;

        % Lookahead horizon
        for i = 1:length(u)
    
            u_vec = [v_nom, u(i)];  % fixed speed, optimizing only omega
            state = predict_state(state, u_vec);
    
            % Compute measurement Jacobian at new state
            H = compute_H(x_hat, state);
    
            % Compute expected information gain (MI)
            I_gain = H' * R_inv * H;
            cost = cost + -log(det(Y + I_gain)/det(Y));  % Negate for minimization

            % Alternative cost function
            % cost = cost + -log(det(eye(size(Y)) + inv(Y) * I_gain)); 
            % ADD Soft penality for standoff distance

        end
    end

    % Optimization bounds
    omega_bounds = repmat([-params.ground_control.omega_max, params.ground_control.omega_max], 5,1);

    % Optimization setup
    lookahead = 5;
    u0 = zeros(lookahead,1);
    options = optimoptions('fmincon', 'Display', 'off');  % or 'iter' for debugging

    % Plot cost function to visualize
    % us = linspace(omega_bounds(1), omega_bounds(2), 100);
    % costs = arrayfun(@InfoCost, us);
    % plot(us, costs); xlabel('\omega'); ylabel('Info Cost');

    % Solve
    [u_opt, ~] = fmincon(@InfoCost, u0, [], [], [], [], omega_bounds(:,1), omega_bounds(:,2), [], options);
    
    % Extract first optimal turning rate
    u = u_opt(1);
    control = [v_nom, u];

    % Does this violate the standoff distance?
    state = predict_state(agent_state, control);
    pos = state(1:2);
    est_pos = x_hat(1:2);

    est_standoff = abs(pos - est_pos);

    if est_standoff < standoff
        % Too close to target — modify control
        warning('Standoff distance violated, modifying control');
        u = 0;
    end
end
