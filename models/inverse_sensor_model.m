function z_transformed = inverse_sensor_model(agent_pos, z)
    % INVERSE_SENSOR_MODEL_GROUND  Inverts sensor measurements
    
    x = agent_pos(1);
    y = agent_pos(2);

    range = z(1);
    bearings = z(2);

    x_meas = x + range*cos(bearings);
    y_meas = y + range*sin(bearings);

    z_transformed = [x_meas; y_meas];
end
