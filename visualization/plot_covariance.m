function plot_covariance(mu, Sigma, varargin)
    theta = linspace(0, 2*pi, 100);
    unit_circle = [cos(theta); sin(theta)];
    [V, D] = eig(Sigma);
    ell = V * sqrt(D) * unit_circle;
    ell = ell + mu(:);
    plot(ell(1, :), ell(2, :), varargin{:});
end
