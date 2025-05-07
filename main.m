% main.m
clear; clc; close all

%% Add Paths
addpath('agents')
addpath('config')
addpath('models')
addpath('visualization')

%% Load parameters and initialize everything
params = parameters();
[agents, target_state] = initialize_simulation();

%% Set up time vector
dt = params.dt;
time = 0:dt:params.T*dt;

%% Set up simulation figure
if (params.vis.show_live == true)
    figure(1);
    hold on;
    grid on;
    xlim([-10, 30]);
    ylim([-10, 30]);
    zlim([0, 15]);
    axis manual;
    view(2);
end


%% Set up mutual information writer 
if params.vis.show_mi
    figs = gobjects(1, params.num_agents);
    videos = cell(1, params.num_agents);  % To hold video writers
    for i = 1:params.num_agents
        figs(i) = figure(100*i);
        hold on; grid on; axis manual;
        xlim([-10, 30]); ylim([-10, 30]);
        axis equal;
        view(2);

        % Set up video writer
        videos{i} = VideoWriter(sprintf('Agent%d_MI.mp4', i), 'MPEG-4');
        videos{i}.Quality = 100;  % High quality
        videos{i}.FrameRate = 1; % Choose frame rate you want
        open(videos{i});
    end
end


%% Simulation loop
for t = 1:params.T
    fprintf('Time Step %d\n', t);

    %--- Target Dynamics ---
    target_state(:,t+1) = target_model(target_state(:,t), dt, params);

    %--- Agent Loop ---
    for i = 1:params.num_agents
        agent = agents(i);

        % ----- Estimation Step -----
        F = params.target.F;   % State transition matrix
        Q = params.filter.Q;   % Process noise

        % Info filter prediction
        [Y_pred, y_pred] = info_filter_pred(agent.Y, agent.y, F, Q);

        % Save off for channel filtering later
        agent.Y_pred = Y_pred;
        agent.y_pred = y_pred;

        % Convert to mean + covariance
        P_pred = invert_matrix(Y_pred);
        x_hat_pred = P_pred * y_pred;

        % EKF Prediction
        [P_pred_EKF, x_hat_pred_EKF] = EKF_pred(agent.P_EKF, agent.x_hat_EKF, F, Q);

        % Measurement from sensor
        if strcmp(agent.type, 'ground')
            z = sensor_model_ground(agent.state, target_state(:,t+1), params);
            z_transformed = inverse_sensor_model(agent.state, z);
            R = params.filter.R_ground;
        else
            z = sensor_model_air(agent.state, target_state(:,t+1), params);
            z_transformed = inverse_sensor_model(agent.state, z);
            R = params.filter.R_air;
        end

        % Linearize measurement model
        H = compute_H(agent.state, x_hat_pred); 
        H_EKF = compute_H(agent.state, x_hat_pred_EKF);

        % Compute Innovation
        innovation = z - sensor_model_no_noise(agent.state, x_hat_pred);
        innovation(2) = wrapToPi(innovation(2)); % angle wrap

        innovation_EKF = z - sensor_model_no_noise(agent.state, x_hat_pred_EKF);
        innovation_EKF(2) = wrapToPi(innovation_EKF(2)); % angle wrap

        % Info filter update
        [Info_M, Info_V] = info_filter_update(Y_pred, y_pred, H, R, innovation, x_hat_pred);

        % Update previous information
        y_new = y_pred + Info_V;
        Y_new = Y_pred + Info_M;

        % Convert to mean + covariance
        P = invert_matrix(Y_new);
        x_hat = P * y_new;

        % EKF Filter Update
        [P_EKF, x_hat_EKF] = EKF_update(P_pred_EKF, x_hat_pred_EKF, H_EKF, R, innovation_EKF);
        
        % ----- Control Step -----
        [omega, omega_opt] = compute_control(Y_new, x_hat, agent.state, dt, R, params);
        control = [params.ground_control.v_nom, omega];

        % Propagate agent dynamics with optimal control
        new_state = ground_agent_model(agent.state, control, dt);

        % Plot Mutual Information Contours
        plot_mi_contour_frame(figs(i), agent, omega_opt, R, params, t);
    
        % Save frame to video
        if params.vis.show_mi
            frame = getframe(figs(i));
            writeVideo(videos{i}, frame);
        end

        % ----- Update agent struct -----
        agent = update_agent_history(agent, new_state, control, z, ...
                                     z_transformed, Info_M, Info_V, ...
                                     Y_new, y_new, x_hat, P, ...
                                     P_EKF, x_hat_EKF);
        % Save back
        agents(i) = agent;
    end

    %--- Centralized Agent ---
    agents = centralized_update(agents, F, Q, params);

    %--- Communication Step ---
    if mod(t, params.comm.freq) == 0
        agents = channel_filter_update(agents, params);
    end

    %--- Visualization ---
    plot_simulation(target_state, agents, params, t);
%   plot_simulation_per_agent(target_state, agents, params, t)

end

% --- Plot Results --
plot_estimation(agents, target_state, params, true, false);   % normal estimator, separate
plot_information(agents, params);  % same plot
plot_final_trajectories(agents, target_state, params)

if params.vis.show_mi
    for i = 1:params.num_agents
        close(videos{i});
    end
end

