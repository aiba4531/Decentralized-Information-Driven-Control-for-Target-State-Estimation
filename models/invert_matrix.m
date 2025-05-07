function M_inv = invert_matrix(M)
    % Invert the matrix M using Cholesky decomposition for numerical stability.
    % Inputs:
    %   M: Matrix to be inverted

    [L, flag] = chol(M, 'lower');
    if flag == 0
        M_inv = L'\(L\eye(size(M)));
    else
        warning('Matrix is not positive definite, using pseudo-inverse.');
        M_inv = pinv(M);
    end
end