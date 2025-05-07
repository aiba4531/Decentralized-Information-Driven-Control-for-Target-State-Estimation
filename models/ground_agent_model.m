function [agent_state_new] = ground_agent_model(agent_state, control, dt)
% GROUND_AGENT_MODEL Propagates agent state using control

    x = agent_state(1);
    y = agent_state(2);
    psi = agent_state(3);
    
    v = control(1);
    omega = control(2);
    
    agent_state_new = [x + v * cos(psi) * dt; ...
                       y + v * sin(psi) * dt; ...
                       psi + omega * dt];
end

