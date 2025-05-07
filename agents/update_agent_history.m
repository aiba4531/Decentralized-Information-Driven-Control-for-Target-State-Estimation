function [agent] = update_agent_history(agent, new_state, control, z, z_transformed, Info_M, Info_V, Y_new, y_new, x_hat, P, P_EKF, x_hat_EKF) 
%UPDATE_AGENT_HISTORY Summary of this function goes here


        % ----- Update agent struct -----
        
        % Update Agent Fields
        agent.state = new_state;                % [x,y,psi]

        agent.z = z;                            % [range, bearings]
        agent.z_transformed = z_transformed;    %[x,y]

        agent.Info_M = Info_M;                  % Information matrix up
        agent.Info_V = Info_V;                  % Information vector up

        agent.Y = Y_new;                        % Information matrix
        agent.y = y_new;                        % Information vector

        agent.x_hat = x_hat;                    % Estimate
        agent.P = P;                            % Covariance

        agent.P_EKF = P_EKF;                    % EKF Covariance
        agent.x_hat_EKF = x_hat_EKF;            % EKF Estimate


        % Update Agent History
        agent.state_history(:, end+1) = new_state;

        agent.control_history(:, end+1) = control;

        agent.z_history(:, end+1) = z;
        agent.z_transformed_history(:, end+1) = z_transformed;

        agent.Info_M_history(:,:,end+1) = Info_M;
        agent.Info_V_history(:,end+1) = Info_V;
        
        agent.Y_history(:, :, end+1) = Y_new;
        agent.y_history(:, end+1) = y_new;

        agent.x_hat_history(:, end+1) = x_hat;
        agent.P_history(:, :, end+1) = P;

        agent.P_EKF_history(:, :, end+1) = P_EKF;
        agent.x_hat_EKF_history(:, end+1) = x_hat_EKF;
end

