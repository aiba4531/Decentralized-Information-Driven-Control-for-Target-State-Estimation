function agents = channel_filter_update(agents, params)
% CHANNEL_FILTER_UPDATE  Perform decentralized info fusion via channel filter

    for i = 1:params.num_agents
        for j = i+1:params.num_agents
            % Check communication range
            dist = norm(agents(i).state(1:2) - agents(j).state(1:2));
            if dist > params.comm.range
                continue;
            end

            % Compute innovation difference
            delta_Info_M = agents(i).Info_M - agents(j).Info_M;
            delta_Info_V = agents(i).Info_V - agents(j).Info_V;

            % Compute locally fused information
            fused_Info_M_i = agents(i).Info_M - delta_Info_M;
            fused_Info_V_i = agents(i).Info_V - delta_Info_V;

            fused_Info_M_j = agents(j).Info_M + delta_Info_M;
            fused_Info_V_j = agents(j).Info_V + delta_Info_V;

            % Update Y and y based on prior + fused innovations
            agents(i).Y = agents(i).Y_pred + fused_Info_M_i;
            agents(i).y = agents(i).y_pred + fused_Info_V_i;

            agents(j).Y = agents(j).Y_pred + fused_Info_M_j;
            agents(j).y = agents(j).y_pred + fused_Info_V_j;
        end
    end
end
