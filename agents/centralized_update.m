function [agents] = centralized_update(agents, F, Q, params)
    % CENTRALIZED_UPDATE Perform centralized info fusion 

    % Get the centralized agent
    agent = agents(end);
    Y_centralized = agent.Y;
    y_centralized = agent.y;

    % Predict forward
    [Y_pred_centralized, y_pred_centralized] = info_filter_pred(Y_centralized, y_centralized, F, Q);

    % Store prediction
    Y_centralized = Y_pred_centralized;
    y_centralized = y_pred_centralized;

    % Update centralized agent with all agents' information
    for i = 1:params.num_agents
        agent = agents(i);
        Y_centralized = Y_centralized + agent.Info_M; 
        y_centralized = y_centralized + agent.Info_V;
    end
    
    % Convert back into state space estimate
    P = invert_matrix(Y_centralized);
    x_hat = P * y_centralized;

    % Save centralized agent
    agent = agents(end);

    % Update Current Centralized Estimate
    agent.Y = Y_centralized;
    agent.y = y_centralized;
    agent.P = P;
    agent.x_hat = x_hat;

    % Update centralized history
    agent.Y_history(:, :, end+1) = Y_centralized;
    agent.y_history(:, end+1) = y_centralized;
    agent.P_history(:, :, end+1) = P;
    agent.x_hat_history(:, end+1) = x_hat;

    % Save back
    agents(end) = agent;

end

