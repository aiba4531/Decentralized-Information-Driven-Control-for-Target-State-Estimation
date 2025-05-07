function z = sensor_model_air(agent_pos, target_pos, params)
    % SENSOR_MODEL_AIR  Simulates air-based sensor measurements
    
    dx = target_pos(1) - agent_pos(1);
    dy = target_pos(2) - agent_pos(2);
    range = sqrt(dx^2 + dy^2) + randn() * params.sensor_air.sigma_range;
    bearing = atan2(dy, dx) + randn() * params.sensor_air.sigma_bearing;
    z = [range; bearing];
end
