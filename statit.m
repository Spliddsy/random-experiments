function [x,k,c,resvec,t] = statit(A,x,b,tol,method_name,omega,max_iterations)
%STATIT Stationary Iteration
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
%           x           initial vector x^{0} (default x = 0)
%           b           right hand side
%           tol         (default tol = eps)
%           method_name name of the main stationary iterative solver
%           SOR_mod     (only used if using SOR/BSOR) solver for omega
%
%   Output: x approximate solution
%           k number of iteration until convergence
%           t time spent solving
%   convergence criterion:
%           norm(b - A*x) <= tol*norm(b - A*x0)

if nargin < 6
    omega = "";
end

[M2, M1] = select_precon(A,method_name,omega);

tic;

r = b - A*x;
rnrm0 = norm(r);

c = 0;
resvec = zeros(max_iterations,1);
for k=1:max_iterations
    if isempty(M2)
        x = x + M1\r;
    else
        x = x + M2\(M1\r);
    end
	r = b - A*x;
	resvec(k) = norm(r);
	if resvec(k) < tol*rnrm0; t = toc; return, end
end
c = 1;
t = toc;
end