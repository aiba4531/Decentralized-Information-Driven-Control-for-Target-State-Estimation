function plot_mi_contour_frame(fig, agent, omega_opt, R, params, t)
    % PLOT_MI_CONTOUR_FRAME  Plots one MI contour frame and agent position

    figure(fig); clf; hold on; grid on; axis manual;
    xlim([-10, 30]);
    ylim([-10, 30]);
    axis equal;
    view(2);

    % Grid
    x_range = linspace(-10, 30, 100);
    y_range = linspace(-10, 30, 100);
    [X, Ygrid] = meshgrid(x_range, y_range);

    % Agent info
    Y = agent.Y;
    x_hat = agent.x_hat;
    state = agent.state;

    R_inv = invert_matrix(R);

    % MI map
    MI_map = zeros(size(X));
    for i = 1:numel(X)
        test_state = [X(i); Ygrid(i); 0; 0];
        H_test = compute_H(x_hat, test_state);
        I_gain = H_test' * R_inv * H_test;
        MI_map(i) = log(det(Y + I_gain)) - log(det(Y));
    end

    % Contour plot
    contourf(X, Ygrid, MI_map, 20, 'LineColor', 'none');
    colormap('parula');
    cb = colorbar;
    ylabel(cb, "Mutual Information Gain")

    
    % Plot agent position
    plot(state(1), state(2), 'ro', 'MarkerFaceColor', 'r');

    % Plot estimated target position
    plot(x_hat(1), x_hat(2), 'kx', 'MarkerSize', 12, 'LineWidth', 2);

    % Plot predicted trajectory based on optimal controls
    predict_state = @(s, u) ground_agent_model(s, u, params.dt);
    pred_state = state;
    v_nom = params.ground_control.v_nom;

    for k = 1:length(omega_opt)
        u_vec = [v_nom, omega_opt(k)];
        pred_state = predict_state(pred_state, u_vec);
        plot(pred_state(1), pred_state(2), 'mo', 'MarkerSize', 5, 'MarkerFaceColor', 'm');
    end

    xlabel('X Position [m]');
    ylabel('Y Position [m]');
    title(sprintf('MI Contours + Optimal Path for Agent %d at t = %d.00', agent.id, t));
    % Create handles for legend
    h1 = plot(nan, nan, 'ro', 'MarkerFaceColor', 'r');             % Agent position
    h2 = plot(nan, nan, 'kx', 'MarkerSize', 12, 'LineWidth', 2);   % Estimated target
    h3 = plot(nan, nan, 'mo', 'MarkerSize', 5, 'MarkerFaceColor', 'm');  % Predicted path
    
    legend([h1, h2, h3], {'Agent Position', 'Estimated Target', 'Optimal Path'}, ...
           'Location', 'northeastoutside');

end
