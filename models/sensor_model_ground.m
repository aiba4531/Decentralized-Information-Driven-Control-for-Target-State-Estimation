function z = sensor_model_ground(agent_pos, target_pos, params)
    % SENSOR_MODEL_GROUND  Simulates ground-based sensor measurements
    % Input:
    %   agent_pos: [x, y] position of the agent
    %   target_pos: [x, y] position of the target
    %   params: parameters for the simulation
    
    dx = target_pos(1) - agent_pos(1);
    dy = target_pos(2) - agent_pos(2);

    range = sqrt(dx^2 + dy^2) + randn() * params.sensor_ground.sigma_range;
    bearing = atan2(dy, dx) + randn() * params.sensor_ground.sigma_bearing;
    
    z = [range; bearing];
end
