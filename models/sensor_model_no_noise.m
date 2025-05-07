function z_hat = sensor_model_no_noise(agent_pos, x_hat)
    % SENSOR_MODEL_GROUND  Simulates ground-based sensor measurements no noise
    % Input:
    %   agent_pos: [x, y] position of the agent
    %   target_pos: [x, y] position of the target


    dx = x_hat(1) - agent_pos(1);
    dy = x_hat(2) - agent_pos(2);

    range = sqrt(dx^2 + dy^2);
    bearing = atan2(dy, dx);

    z_hat = [range; bearing];
end