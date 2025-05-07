function plot_information(agents, params)
% PLOT_INFORMATION  Plot log(det(Y)) and delta log(det(Y)) over time for each agent

        colors = lines(params.num_agents); 

        figure(5); clf;

        % Plot total info
        subplot(2,1,1); hold on; grid on;
        xlabel('Time Steps');
        ylabel('Information Gain log(|Y|)');
        comm_freq = params.comm.freq; % every time step, every 20 timestep
        title(sprintf('Information Growth Across Agents (Comm Every %.2f sec)', comm_freq))

        % Centralized agent
        agent = agents(end);
        Y_hist = agent.Y_history;
        num_steps = size(Y_hist, 3);
        det_values = zeros(1, num_steps);
        for k = 1:num_steps
            det_values(k) = log(det(Y_hist(:,:,k)));
        end
        T = 1:num_steps;
        plot(T, det_values, 'k', 'LineWidth', 2);

        for i = 1:params.num_agents
            Y_hist = agents(i).Y_history;
            num_steps = size(Y_hist, 3);
            det_values = zeros(1, num_steps);
            for k = 1:num_steps
                det_values(k) = log(det(Y_hist(:,:,k)));
            end

            T = 1:num_steps;
            plot(T, det_values, 'Color', colors(i,:), 'LineWidth', 1.5);
        end

        legend([{'Centralized Estimator'}, arrayfun(@(i) sprintf('Agent %d', i), 1:params.num_agents, 'UniformOutput', false)], 'location', 'southeast', 'FontSize', 4);

        % Plot delta info gain
        subplot(2,1,2); hold on; grid on;
        xlabel('Time Steps');
        ylabel('Δ Information Gain');
        title(sprintf('Per-Step Information Gain Across Agents (Comm Every %.2f sec)', comm_freq))

        % Centralized agent's delta
        for k = 1:num_steps
            det_values(k) = log(det(agent.Y_history(:,:,k)));
        end
        delta_info = diff(det_values);
        T_delta = 2:num_steps;
        plot(T_delta, delta_info, 'k', 'LineWidth', 2);

        for i = 1:params.num_agents
            Y_hist = agents(i).Y_history;
            num_steps = size(Y_hist, 3);
            det_values = zeros(1, num_steps);
            for k = 1:num_steps
                det_values(k) = log(det(Y_hist(:,:,k)));
            end
            delta_info = diff(det_values);
            T_delta = 2:num_steps;
            plot(T_delta, delta_info, 'Color', colors(i,:), 'LineWidth', 1.5);
        end

        legend([{'Centralized Estimator'}, arrayfun(@(i) sprintf('Agent %d', i), 1:params.num_agents, 'UniformOutput', false)], 'FontSize', 4);

end

