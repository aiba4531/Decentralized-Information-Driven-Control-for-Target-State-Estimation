function params = parameters()
    % PARAMETERS  Define global simulation parameters
    
        %% General Simulation Settings
        params.T = 100;                 % Total time steps
        params.dt = 1.0;                % Time step duration (seconds)
        params.num_ground_agents = 2;   % Two ground agents
        params.num_air_agents = 1;      % One aerial agent
        params.num_agents = params.num_ground_agents + params.num_air_agents;
        
        %% Target Model
        %params.target.initial_state = [10; 10; 0; 0];       % [x, y, vx, vy]
        params.target.initial_state = [10; 10; 0.25; 0.25];  % [x, y, vx, vy]
        params.target.motion = true;                         % Set false for static target
        if params.target.motion
            dt = params.dt;
            params.target.F = ...
               [1 0 dt 0;
                0 1 0 dt;
                0 0 1 0;
                0 0 0 1];
        else
            params.target.F = eye(4);
        end
        
        %% Sensor Noise (Ground)
        params.sensor_ground.sigma_range = 5;                % Std dev in range (m)
        params.sensor_ground.sigma_bearing = deg2rad(2.5);   % Std dev in bearing (radians)
    
        %% Sensor Noise (Aerial)
        params.sensor_air.sigma_range = 1.25;               % Std dev in range (m)
        params.sensor_air.sigma_bearing = deg2rad(8);       % Std dev in bearing (radians)
    
        %% Information Filter Parameters
        params.filter.x_hat = [8; 8; 0; 0];               % Initial state estimate
        params.filter.P0 = diag([50, 50, 5, 5]);          % Initial covariance
        params.filter.Q = diag([2.5, 2.5, 0.25, 0.25]);   % Process noise
        %params.filter.Q = diag([1, 1, 0.1, 0.1]);        % Process noise

        params.filter.R_ground = diag([...                % Measurement Covariance (ground)
            params.sensor_ground.sigma_range^2, ...
            params.sensor_ground.sigma_bearing^2]);
        params.filter.R_air = diag([...                   % Measurement Covariance (aerial)
            params.sensor_air.sigma_range^2, ...
            params.sensor_air.sigma_bearing^2]);
    
        %% Ground Agent Control Settings
        params.ground_control.v_nom = 1;                % Nominal speed (m/s)
        params.ground_control.v_max = 2;                % Max speed (m/s)
        params.ground_control.omega_max = pi/4;         % Max angular speed (rad/s)
        params.ground_control.range_limit = 20;         % Max sensing range (m)
        params.ground_control.standoff = 5;             % Standoff distance (m)

        %% Aerial Agent Control Settings
        params.air_control.v_nom = 5;                % Nominal speed (m/s)
        params.air_control.v_max = 10;               % Max speed (m/s)
        params.air_control.omega_max = pi/4;         % Max angular speed (rad/s)
        params.air_control.range_limit = 20;         % Max sensing range (m)
        params.air_control.standoff = 5;             % Standoff distance (m)
    
        %% Communication
        params.comm.freq = 1;           % Frequency of updates (steps)
        params.comm.range = 30;         % Comm range (m)
    
        %% Visualization
        params.vis.show_live = true;
        params.vis.show_mi = true;
        params.vis.plot_interval = 1;

    
end
    