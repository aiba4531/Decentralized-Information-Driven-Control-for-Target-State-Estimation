function [agents, target_state] = initialize_simulation()
    % INITIALIZE_SIMULATION  Loads params and sets up agents and target
    
        % Load parameters
        params = parameters();
    
        % Initialize agents
        agents = initialize_agents(params);
    
        % Initialize target
        target_state = params.target.initial_state;
    
    end
    