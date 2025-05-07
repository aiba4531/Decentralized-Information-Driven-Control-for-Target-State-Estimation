function agents = initialize_agents(params)
    % INITIALIZE_AGENTS  Set up agent structures with initial state and filters
    
        agents = struct( ...
            'id', {}, ...
            'type', {}, ...
            'state', {}, ...
            'altitude', {}, ...
            'control', {}, ...
            'Y_pred', {}, ...
            'y_pred', {}, ...
            'z', {}, ...
            'z_transformed', {}, ...
            'x_hat', {}, ...
            'P', {}, ...
            'Info_M', {}, ...
            'Info_V', {}, ...
            'Y', {}, ...
            'y', {}, ...
            'x_hat_EKF', {}, ...
            'P_EKF', {}, ...
            'state_history', {}, ...
            'control_history', {}, ...
            'z_history', {}, ...
            'z_transformed_history', {}, ...
            'x_hat_history', {}, ...
            'P_history', {}, ...
            'Info_M_history', {}, ...
            'Info_V_history', {}, ...
            'Y_history', {}, ...
            'y_history', {}, ...
            'P_EKF_history', {}, ...
            'x_hat_EKF_history', {});


    
        %% Create ground agents
        initial_positions = [0, 0;...
                             0, 20; ...
                             25, 25];  % Each row is [x, y]
        agent_idx = 1; 
        for i = 1:params.num_ground_agents

            % Create a new agent structure
            agent = struct();

            % Agent ID and Type
            agent.id = agent_idx;
            agent.type = 'ground'; 

            % Agent Initial State and Control
            agent.state = [initial_positions(agent_idx,1);...
                           initial_positions(agent_idx,2);...
                           0];                                                  % [x, y, psi] (psi is heading angle)
            agent.altitude = 0;                                                 % Ground agents have zero altitude
            agent.control = [params.ground_control.v_nom; 0];                   % Control parameters;

            % Agent Current Measurement, Estimate, and Covariance
            agent.z = [0; 0];                           % Initial measurement (range, bearing)
            agent.z_transformed = [0;0];                % Transformed measurement (x, y)
            agent.x_hat = params.filter.x_hat;          % Initial state estimate
            agent.P = params.filter.P0;                 % Initial covariance
            agent.Info_M = inv(agent.P);                % Initial Information matrix
            agent.Info_V = agent.Info_M * agent.x_hat;  % Initial Information state
            agent.Y = inv(agent.P);                     % Initial Information matrix
            agent.y = agent.Y * agent.x_hat;            % Information state
            agent.Y_pred = inv(agent.P);                % Predicted Information matrix
            agent.y_pred = agent.Y * agent.x_hat;       % Predicted Information vector
            agent.x_hat_EKF = agent.x_hat;              % Initial state estimate for EKF
            agent.P_EKF = agent.P;                      % Initial covariance for EKF

            % Agent History
            agent.state_history = agent.state;
            agent.control_history = agent.control;
            agent.z_history = agent.z;
            agent.z_transformed_history = agent.z;
            agent.x_hat_history = agent.x_hat;
            agent.P_history = agent.P;
            agent.Info_M_history = agent.Info_M;
            agent.Info_V_history = agent.Info_V;
            agent.Y_history = agent.Y;
            agent.y_history = agent.y;
            agent.P_EKF_history = agent.P;
            agent.x_hat_EKF_history = agent.x_hat;

            % Add agent to the agents array 
            agents(agent_idx) = agent;

            % Increment agent index
            agent_idx = agent_idx + 1;
        end


        for i = 1:params.num_air_agents
            % Create a new agent structure
            agent = struct();

            % Agent ID and Type
            agent.id = agent_idx;
            agent.type = 'air'; 

            % Agent Initial State and Control
            agent.state = [initial_positions(agent_idx,1);...
                           initial_positions(agent_idx,2);...
                           0];                                                  % [x, y, psi] (psi is heading angle)
            agent.altitude = 0;                                                 % Ground agents have zero altitude
            agent.control = [params.ground_control.v_nom; 0];                   % Control parameters;

            % Agent Current Measurement, Estimate, and Covariance
            agent.z = [0; 0];                           % Initial measurement (range, bearing)
            agent.z_transformed = [0;0];                % Transformed measurement (x, y)
            agent.x_hat = params.filter.x_hat;          % Initial state estimate
            agent.P = params.filter.P0;                 % Initial covariance
            agent.Info_M = inv(agent.P);                % Initial Information matrix
            agent.Info_V = agent.Info_M * agent.x_hat;  % Initial Information state
            agent.Y = inv(agent.P);                     % Initial Information matrix
            agent.y = agent.Y * agent.x_hat;            % Information state
            agent.Y_pred = inv(agent.P);                % Predicted Information matrix
            agent.y_pred = agent.Y * agent.x_hat;       % Predicted Information vector
            agent.x_hat_EKF = agent.x_hat;              % Initial state estimate for EKF
            agent.P_EKF = agent.P;                      % Initial covariance for EKF
            
            % Agent History
            agent.state_history = agent.state;
            agent.control_history = agent.control;
            agent.z_history = agent.z;
            agent.z_transformed_history = agent.z;
            agent.x_hat_history = agent.x_hat;
            agent.P_history = agent.P;
            agent.Info_M_history = agent.Info_M;
            agent.Info_V_history = agent.Info_V;
            agent.Y_history = agent.Y;
            agent.y_history = agent.y;
            agent.P_EKF_history = agent.P;
            agent.x_hat_EKF_history = agent.x_hat;

            % Add agent to the agents array 
            agents(agent_idx) = agent;
            
            % Increment agent index
            agent_idx = agent_idx + 1;
        end

        %% Create a centralized estimator agent

        % Create a new agent structure
        agent = struct();

        % Agent ID and Type
        agent.id = agent_idx;               % Centralized estimator ID
        agent.type = 'centralized';         % Centralized estimator

        % Agent Initial State and Control
        agent.state = [0; 0; 0];            % Centralized estimator state (not used)
        agent.altitude = 0;                 % Centralized estimator has zero altitude
        agent.control = [0; 0];             % Control parameters (not used)

        % Agent Current Measurement, Estimate, and Covariance
        agent.z = [0; 0];                           % Initial measurement (range, bearing)
        agent.z_transformed = [0;0];                % Transformed measurement (x, y)
        agent.x_hat = params.filter.x_hat;          % Initial state estimate
        agent.P = params.filter.P0;                 % Initial covariance
        agent.Info_M = inv(agent.P);                % Initial Information matrix
        agent.Info_V = agent.Info_M * agent.x_hat;  % Initial Information state
        agent.Y = inv(agent.P);                     % Initial Information matrix
        agent.y = agent.Y * agent.x_hat;            % Information state
        agent.Y_pred = inv(agent.P);                % Predicted Information matrix
        agent.y_pred = agent.Y * agent.x_hat;       % Predicted Information vector
        agent.x_hat_EKF = agent.x_hat;              % Initial state estimate for EKF
        agent.P_EKF = agent.P;                      % Initial covariance for EKF

        % Agent History
        agent.state_history = agent.state;
        agent.control_history = agent.control;
        agent.z_history = agent.z;
        agent.z_transformed_history = agent.z;
        agent.x_hat_history = agent.x_hat;
        agent.P_history = agent.P;
        agent.Info_M_history = agent.Info_M;
        agent.Info_V_history = agent.Info_V;
        agent.Y_history = agent.Y;
        agent.y_history = agent.y;
        agent.P_EKF_history = agent.P;
        agent.x_hat_EKF_history = agent.x_hat;

        % Add agent to the agents array
        agents(agent_idx) = agent;  % Add to agents array
    end
    