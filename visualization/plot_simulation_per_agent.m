function plot_simulation_per_agent(target_state, agents, params, t)
    % PLOT_SIMULATION  Visualize agents, measurements, estimates, and covariances

    if ~(params.vis.show_live && mod(t, params.vis.plot_interval) == 0)
        return;  % Skip plotting if conditions not met
    end


    
    % Loop over all agents
    for i = 1:params.num_agents

        figure(i); cla; hold on;

        hold on;
        grid on;
        xlim([-10, 30]);
        ylim([-10, 30]);
        zlim([0, 15]);
        axis manual;
        view(2);

        % Plot the true target
        plot(target_state(1,t), target_state(2,t), 'rx', 'MarkerSize', 12, 'LineWidth', 2);
    
        % Number of Points to plot from history
        num_hist = 5;
    
        if t > num_hist
            target_hist = target_state(1:2, end-num_hist:end);
            plot(target_hist(1,:), target_hist(2, :), 'r--')
        end
    
        % Define colors and markers
        ground_colors = ['b', 'c'];  % blue, cyan for ground agents
        air_color = 'm';             % magenta for aerial agent

        pos = [agents(i).state(1:2); agents(i).altitude];
        
        xy_meas = agents(i).z_transformed;
        x_hat = agents(i).x_hat;
        P_2d = agents(i).P(1:2, 1:2);

        % Choose color based on agent type
        if agents(i).type == "ground"
            color = ground_colors(mod(i-1, length(ground_colors)) + 1);
        elseif agents(i).type == "air"
            color = air_color;
        else
            color = 'k';  % default/fallback
        end

        % Plot current position
        plot3(pos(1), pos(2), pos(3), 'o', 'MarkerFaceColor', color, 'MarkerEdgeColor', color, 'MarkerSize', 6);

        % Plot measurement
        plot(xy_meas(1), xy_meas(2), '*', 'Color', color, 'MarkerSize', 6);

        % Plot estimate
        plot(x_hat(1), x_hat(2), '+', 'Color', color, 'MarkerSize', 8, 'LineWidth', 1.5);

        % Plot covariance ellipse
        plot_covariance(x_hat(1:2), P_2d, 'Color', color);

        % Plot Agent Motion History
        if t > num_hist
            pos_hist = [agents(i).state_history(1, end-num_hist:end); agents(i).state_history(2, end-num_hist:end); ones(1,num_hist+1)*agents(i).altitude];
            plot3(pos_hist(1,:), pos_hist(2,:), pos_hist(3,:), '--', 'Color', color)
        end



        % Legend handles with matching colors
        h_target   = plot(nan, nan, 'rx', 'MarkerSize', 12, 'LineWidth', 2);     % True target
        h_meas     = plot(nan, nan, '*', 'Color', 'k', 'MarkerSize', 6);           % Measurement
        h_estimate = plot(nan, nan, '+', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 1.5);  % Estimate
        h_cov      = plot(nan, nan, '-', 'Color', 'k');                            % Covariance ellipse
        
        if i == 1
            h_ground1  = plot3(nan, nan, nan, 'o', 'MarkerFaceColor', ground_colors(1), ...
                                        'MarkerEdgeColor', ground_colors(1), 'MarkerSize', 6);  % Ground agent 1
            legend([h_target, h_ground1, h_meas, h_estimate, h_cov], ...
                   {'True Target', 'Ground Agent 1', ...
                    'Measurement', 'Estimate', 'Covariance Ellipse'}, ...
                   'Location', 'bestoutside');

        elseif i == 2
            h_ground2  = plot3(nan, nan, nan, 'o', 'MarkerFaceColor', ground_colors(2), ...
                                    'MarkerEdgeColor', ground_colors(2), 'MarkerSize', 6);  % Ground agent 2
            legend([h_target, h_ground2, h_meas, h_estimate, h_cov], ...
                   {'True Target', 'Ground Agent 2', ...
                    'Measurement', 'Estimate', 'Covariance Ellipse'}, ...
                   'Location', 'bestoutside');

        elseif i == 3
            h_air      = plot3(nan, nan, nan, 'o', 'MarkerFaceColor', air_color, ...
                                    'MarkerEdgeColor', air_color, 'MarkerSize', 6);  % Aerial agent
            legend([h_target,  h_air, h_meas, h_estimate, h_cov], ...
                   {'True Target', 'Aerial Agent', ...
                    'Measurement', 'Estimate', 'Covariance Ellipse'}, ...
                   'Location', 'bestoutside');

        end
        

        xlabel('X Position [m]');
        ylabel('Y Position [m]');
        title(sprintf('Simulation at t = %.2f', t * params.dt));
        drawnow;
    end

end
