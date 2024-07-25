function [M2,M1] = statit_precon(A,method_name,omega)
%STATIT Stationary Iteration Preconditioner
%SUPPORTED SOLVERS: Jacobi
%                   Block Jacobi
%                   Gauss-Siedel
%                   Block Gauss-Siedel
%                   Symmetric Gauss-Siedel
%                   Block Symmetric Gauss-Siedel
%                   Successive Over-Relaxation (omega chosen with SOR_mod)
%                   Block Successive Over-Relaxation (omega chosen with SOR_mod)
%
%   x^{k+1} = x^{k} + M \ r^{k}, r^{k} = b - A x^{k}
%       for solving A x = b
%
%   [x,k,time] = statit(A,x,b,tol,method_name,SOR_mod)
%   Input:  A           system matrix
%           method_name name of the main stationary iterative solver
%           SOR_mod     (only used if using SOR/BSOR) solver for omega
%
%   Output: Preconditioner matrices M2 and M1 such that:
%           M2 * M1 = M

block_factor = 1;

if method_name == "J"
    M1 = diag(diag(A));
    M2 = [];
elseif method_name == "BJ"
    M1 = triu(tril(A,block_factor),-block_factor);
    M2 = [];
elseif method_name == "GS"
    M1 = tril(A);
    M2 = [];
elseif method_name == "BGS"
    M1 = tril(A,block_factor);
    M2 = [];
elseif method_name == "SGS"
    D = diag(diag(A));
    M1 = tril(A) / sqrt(D);
    M2 = M1';
elseif method_name == "BSGS"
    D = triu(tril(A,block_factor),-block_factor);
    M1 = tril(A,block_factor) / chol(D,"lower");
    M2 = M1';
elseif method_name == "SOR"
    % if SOR_mod == "J"
    %     M = diag(diag(A));
    %     N = -(A - M);
    %     G = M \ N;
    % elseif SOR_mod == "GS"
    %     M = tril(A);
    %     N = -(A - M);
    %     G = M \ N;
    % elseif SOR_mod == "SGS"
    %     D = diag(diag(A));
    %     M = (tril(A) / sqrt(D))' * (tril(A) / sqrt(D));
    %     N = -(A - M);
    %     G = M \ N;
    % else
    %     error("You have selected an unsupported way of calculating omega for SOR.");
    % end
    % max_eig = max(eig(G));
    % w = 2 / (1 + sqrt(1 - max_eig^2));
    w = omega;

    D = diag(diag(A));
    M1 = D / w + tril(A,-1);
    M2 = [];
elseif method_name == "BSOR"
    % if SOR_mod == "BJ"
    %     M = triu(tril(A,block_factor),-block_factor);
    %     N = -(A - M);
    %     G = M \ N;
    % elseif SOR_mod == "BGS"
    %     M = tril(A,block_factor);
    %     N = -(A - M);
    %     G = M \ N;
    % elseif SOR_mod == "BSGS"
    %     D = triu(tril(A,block_factor),-block_factor);
    %     M1 = tril(A,block_factor) / chol(D,"lower");
    %     M2 = M1';
    %     M = M2 * M1;
    %     N = -(A - M);
    %     G = M \ N;
    % else
    %     error("You have selected an unsupported way of calculating omega for BSOR.")
    % end
    % max_eig = max(eig(G));
    % w = 2 / (1 + sqrt(1 - max_eig^2));
    w = omega;

    M1 = triu(tril(A,1),-1)/w + tril(A,-1);
    M2 = [];
else
    error("You have selected an unsupported stationary iterative method.");
end

end