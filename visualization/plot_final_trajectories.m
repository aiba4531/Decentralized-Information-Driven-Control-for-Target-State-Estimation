function plot_final_trajectories(agents, target_state, params)
% PLOT_FINAL_TRAJECTORIES
%   Plots agent trajectories at the end of the simulation
    figure; clf; hold on; grid on; axis equal;
    xlabel('X Position [m]');
    ylabel('Y Position [m]');
    
    comm_freq = params.comm.freq;
    title(sprintf('Final Agent Trajectories (Comm Every %.2f sec)', comm_freq))

    % Colors
    ground_colors = ['b', 'c'];
    air_color = 'm';

    % Plot true target
    plot(target_state(1,:), target_state(2,:), 'r--')
    plot(target_state(1,end), target_state(2,end), 'rx', 'MarkerSize', 12, 'LineWidth', 2);

    % Store agent color mapping
    agent_colors = cell(1, params.num_agents);

    % Plot each agent
    for j = 1:params.num_agents
        agent = agents(j);

        % Assign color based on agent type and index
        if agent.type == "ground"
            color = ground_colors(mod(j-1, length(ground_colors)) + 1);
        elseif agent.type == "air"
            color = air_color;
        else
            color = 'k';
        end
        agent_colors{j} = color;

        % Extract trajectory
        traj_x = agent.state_history(1, :);
        traj_y = agent.state_history(2, :);

        % Plot trajectory line
        plot(traj_x, traj_y, '-', 'Color', color, 'LineWidth', 1.2);

        % Directional markers 
        skip = 5;
        marker_size = 1.0;
        s = marker_size;
        h = sqrt(3)/2 * s;
        base_shape = [ -s/2, -s/2,  s;
                       -h/3,  h/3,   0 ];
        for i = 2:skip:(length(traj_x)-1)
            dx = traj_x(i+1) - traj_x(i);
            dy = traj_y(i+1) - traj_y(i);
            theta = atan2(dy, dx);
            R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
            rotated_shape = R * base_shape;
            rotated_shape(1, :) = rotated_shape(1, :) + traj_x(i);
            rotated_shape(2, :) = rotated_shape(2, :) + traj_y(i);
            fill(rotated_shape(1, :), rotated_shape(2, :), color, 'EdgeColor', 'none');
        end

        % Start and stop markers
        plot(traj_x(1), traj_y(1), '*', 'Color', color, 'MarkerSize', 6);
        plot(traj_x(end), traj_y(end), 'o', 'Color', color, 'MarkerSize', 6);
    end


    h_target = plot(nan, nan, 'rx', 'MarkerSize', 12, 'LineWidth', 2);
    agent_handles = gobjects(params.num_agents, 1);
    for j = 1:params.num_agents
        agent_handles(j) = plot(nan, nan, '-', 'Color', agent_colors{j}, 'LineWidth', 1.5);
    end

    h_start = plot(nan, nan, '*k', 'MarkerSize', 6);
    h_stop  = plot(nan, nan, 'ok', 'MarkerSize', 6);
    agent_labels = arrayfun(@(j) sprintf('Agent %d', j), 1:params.num_agents, 'UniformOutput', false);
    legend([h_target; agent_handles; h_start; h_stop], ...
           ['True Target', agent_labels, {'Start Location', 'Stop Location'}], ...
           'Location', 'bestoutside');

    xlim([-10, 50]);
    ylim([-10, 50]);
end
