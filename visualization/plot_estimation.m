function plot_estimation(agents, target_state, params, plot_individual, use_EKF)
    % PLOT_ESTIMATION_ERRORS  Plot estimation errors with ±2 sigma bounds (shaded regions)
    %
    % Inputs:
    %   agents - array of agent structures
    %   target_state - true target state [x; y; vx; vy]
    %   params - struct with params.num_agents
    %   plot_individual - (bool) true = separate figure per agent, false = all agents together
    %   use_EKF - (bool) true = plot EKF estimate, false = plot normal estimate

    states = {'X', 'Y', 'Vx', 'Vy'};
    n_states = numel(states);

    colors = lines(params.num_agents); % distinct colors for each agent

    if plot_individual
        % Plot each agent in its own figure
        for i = 1:params.num_agents
            figure(i+10); clf;
            for j = 1:n_states
                subplot(n_states,1,j); hold on; grid on;
                xlabel('Time Steps');
                ylabel(sprintf('%s Error', states{j}));

                if use_EKF
                    x_hat_hist = agents(i).x_hat_history_EKF;
                    cov_hist = agents(i).P_history_EKF;
                else
                    x_hat_hist = agents(i).x_hat_history;
                    cov_hist = agents(i).P_history;
                end

                target_val = target_state(j,:);
                error = x_hat_hist(j,:) - target_val;
                sigma = sqrt(squeeze(cov_hist(j,j,:)));

                T = 1:length(error);

                % Plot shaded 2-sigma bounds
                fill([T, fliplr(T)], [2*sigma', fliplr((-2*sigma'))], ...
                     colors(i,:), 'FaceAlpha', 0.2, 'EdgeColor', 'none');

                % Plot error line
                plot(T, error, 'Color', colors(i,:), 'LineWidth', 1.5);
            end
            if use_EKF
                sgtitle(sprintf('EKF Estimation Error: Agent %d', i));
            else
                 comm_freq = params.comm.freq; % every time step, every 20 timestep
                 sgtitle(sprintf('Estimation Error: Agent %d (Comm Every %.2f sec)', i, comm_freq));
                 filename = sprintf('plots\\MA_TT_Error_Agent_%d_f%d', i, comm_freq);
                 saveas(gcf, filename, 'png')
            end
        end
    else
        % Plot all agents on the same subplots
        figure(3); clf;
        for j = 1:n_states
            subplot(n_states,1,j); hold on; grid on;
            xlabel('Time Steps');
            ylabel(sprintf('%s Error', states{j}));

            for i = 1:params.num_agents
                if use_EKF
                    x_hat_hist = agents(i).x_hat_history_EKF;
                    cov_hist = agents(i).P_history_EKF;
                else
                    x_hat_hist = agents(i).x_hat_history;
                    cov_hist = agents(i).P_history;
                end

                target_val = target_state(j, :);
                error = x_hat_hist(j,:) - target_val;
                sigma = sqrt(squeeze(cov_hist(j,j,:)));

                T = 1:length(error);

                % Plot shaded 2-sigma bounds
                fill([T, fliplr(T)], [2*sigma', fliplr((-2*sigma'))], ...
                     colors(i,:), 'FaceAlpha', 0.2, 'EdgeColor', 'none');

                % Plot error line
                plot(T, error, 'Color', colors(i,:), 'LineWidth', 1.5);
            end
        end
        if use_EKF
            sgtitle('EKF Estimation Errors Across Agents');
        else
            sgtitle('Estimation Errors Across Agents');
        end
        legend(arrayfun(@(i) sprintf('Agent %d', i), 1:params.num_agents, 'UniformOutput', false));
    end


    % Plot centralzied error
    figure(4); clf;
    agent = agents(end);
    for j = 1:n_states
        subplot(n_states,1,j); hold on; grid on;
        xlabel('Time Steps');
        ylabel(sprintf('%s Error', states{j}));

        % Centralized estimate
        x_hat_centralized = agent.x_hat_history(j,:);
        cov_centralized = agent.P_history(j,j,:);

        target_val = target_state(j);
        error = x_hat_centralized - target_val;
        sigma = sqrt(squeeze(cov_centralized));
        T = 1:length(error);

        % Plot shaded 2-sigma bounds
        fill([T, fliplr(T)], [2*sigma', fliplr((-2*sigma'))], ...
             'k', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
        % Plot error line
        plot(T, error, 'k', 'LineWidth', 1.5);

    end
    comm_freq = params.comm.freq; % every time step, every 20 timestep
    sgtitle(sprintf('Centralized Estimation Error (Comm Every %.2f sec)', comm_freq));
    filename = sprintf('plots\\MA_TT_Error_Central_f%d', comm_freq);
    saveas(gcf, filename, 'png')
end
