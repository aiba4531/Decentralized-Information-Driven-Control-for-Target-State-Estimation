function H = compute_H(agent_pos, x_hat)
    % COMPUTE_H  Measurement Jacobian wrt state [x, y, vx, vy]
    % Inputs:
    %   agent_pos: [x, y] position of the agent
    %   x_hat: [x, y, vx, vy] state estimate of the target
    
        dx = x_hat(1) - agent_pos(1);
        dy = x_hat(2) - agent_pos(2);

        r2 = dx^2 + dy^2;
        r = sqrt(r2);
    
        % Partial derivatives of [range; bearing] wrt [x, y, vx, vy]
        H = zeros(2, 4);
        H(1,1) = dx / r;       % drange/dx
        H(1,2) = dy / r;       % drange/dy
        H(2,1) = -dy / r2;     % dbearing/dx
        H(2,2) = dx / r2;      % dbearing/dy
    end
    