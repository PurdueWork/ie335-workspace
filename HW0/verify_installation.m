function verify_installation()
% verify_installation Check if Optimization Toolbox and Gurobi are properly set up
%
% This function verifies:
%   1. Optimization Toolbox installation and functionality
%   2. Gurobi installation and functionality
%
% Output: Prints status messages for each component

fprintf('========================================\n');
fprintf('Verifying Installation\n');
fprintf('========================================\n\n');

% Check Optimization Toolbox
fprintf('1. Checking Optimization Toolbox...\n');
optim_toolbox_ok = check_optimization_toolbox();
if optim_toolbox_ok
    fprintf('   ✓ Optimization Toolbox is properly installed\n');
else
    fprintf('   ✗ Optimization Toolbox is NOT properly installed\n');
end
fprintf('\n');

% Check Gurobi
fprintf('2. Checking Gurobi...\n');
gurobi_ok = check_gurobi();
if gurobi_ok
    fprintf('   ✓ Gurobi is properly installed\n');
else
    fprintf('   ✗ Gurobi is NOT properly installed\n');
end
fprintf('\n');

% Summary
fprintf('========================================\n');
fprintf('Summary\n');
fprintf('========================================\n');
if optim_toolbox_ok && gurobi_ok
    fprintf('✓ All components are properly installed\n');
elseif optim_toolbox_ok
    fprintf('⚠ Optimization Toolbox: OK, Gurobi: MISSING\n');
elseif gurobi_ok
    fprintf('⚠ Optimization Toolbox: MISSING, Gurobi: OK\n');
else
    fprintf('✗ Both components are missing\n');
end
fprintf('========================================\n');

end

function is_ok = check_optimization_toolbox()
% check_optimization_toolbox Verify Optimization Toolbox installation
    
    is_ok = false;
    
    % Check if toolbox is installed
    try
        toolbox_info = ver('optim');
        if isempty(toolbox_info)
            fprintf('   - Optimization Toolbox not found in installed toolboxes\n');
            return;
        end
        fprintf('   - Found Optimization Toolbox version: %s\n', ...
            toolbox_info.Version);
    catch
        fprintf('   - Error checking for Optimization Toolbox\n');
        return;
    end
    
    % Test functionality with a simple linear program
    try
        % Simple LP: min -x1 - x2 s.t. x1 + x2 <= 1, x1, x2 >= 0
        % This is equivalent to max x1 + x2
        f = [-1; -1];
        A = [1, 1];
        b = 1;
        lb = [0; 0];
        
        options = optimoptions('linprog', 'Display', 'none');
        [~, ~, exitflag] = linprog(f, A, b, [], [], lb, [], options);
        
        if exitflag == 1
            fprintf('   - linprog test: PASSED\n');
        else
            fprintf('   - linprog test: FAILED (exitflag = %d)\n', exitflag);
            return;
        end
    catch ME
        fprintf('   - linprog test: ERROR - %s\n', ME.message);
        return;
    end
    
    % Test intlinprog functionality
    try
        % Simple IP: max x1 + x2 s.t. x1 + x2 <= 1, x1, x2 >= 0, integer
        f = [-1; -1];
        A = [1, 1];
        b = 1;
        intcon = [1; 2];
        lb = [0; 0];
        
        options = optimoptions('intlinprog', 'Display', 'none');
        [~, ~, exitflag] = intlinprog(f, intcon, A, b, [], [], lb, [], options);
        
        if exitflag == 1
            fprintf('   - intlinprog test: PASSED\n');
        else
            fprintf('   - intlinprog test: FAILED (exitflag = %d)\n', exitflag);
            return;
        end
    catch ME
        fprintf('   - intlinprog test: ERROR - %s\n', ME.message);
        return;
    end
    
    is_ok = true;
end

function is_ok = check_gurobi()
% check_gurobi Verify Gurobi installation and functionality
    
    is_ok = false;
    
    % Check if gurobi function exists
    if ~exist('gurobi', 'file')
        fprintf('   - gurobi function not found in MATLAB path\n');
        return;
    end
    fprintf('   - Found gurobi function\n');
    
    % Test with a simple linear program
    try
        % Simple LP: max x1 + x2 s.t. x1 + x2 <= 1, x1, x2 >= 0
        model.obj = [1; 1];
        model.A = sparse([1, 1]);
        model.rhs = 1;
        model.sense = '<';
        model.lb = [0; 0];
        model.modelsense = 'max';
        
        params.outputflag = 0;  % Suppress output
        
        result = gurobi(model, params);
        
        if strcmp(result.status, 'OPTIMAL')
            fprintf('   - Gurobi LP test: PASSED\n');
            fprintf('   - Optimal value: %.6f\n', result.objval);
        else
            fprintf('   - Gurobi LP test: FAILED (status: %s)\n', result.status);
            return;
        end
    catch ME
        if contains(ME.message, 'license') || contains(ME.message, 'License')
            fprintf('   - Gurobi LP test: LICENSE ERROR - %s\n', ME.message);
        elseif contains(ME.message, 'gurobi') || contains(ME.identifier, 'gurobi')
            fprintf('   - Gurobi LP test: ERROR - %s\n', ME.message);
        else
            fprintf('   - Gurobi LP test: UNEXPECTED ERROR - %s\n', ME.message);
        end
        return;
    end
    
    % Test with a simple integer program
    try
        % Simple IP: max x1 + x2 s.t. x1 + x2 <= 1, x1, x2 >= 0, integer
        model.obj = [1; 1];
        model.A = sparse([1, 1]);
        model.rhs = 1;
        model.sense = '<';
        model.lb = [0; 0];
        model.vtype = 'II';  % Both integer
        model.modelsense = 'max';
        
        params.outputflag = 0;  % Suppress output
        
        result = gurobi(model, params);
        
        if strcmp(result.status, 'OPTIMAL')
            fprintf('   - Gurobi IP test: PASSED\n');
            fprintf('   - Optimal value: %.6f\n', result.objval);
        else
            fprintf('   - Gurobi IP test: FAILED (status: %s)\n', result.status);
            return;
        end
    catch ME
        if contains(ME.message, 'license') || contains(ME.message, 'License')
            fprintf('   - Gurobi IP test: LICENSE ERROR - %s\n', ME.message);
        else
            fprintf('   - Gurobi IP test: ERROR - %s\n', ME.message);
        end
        return;
    end
    
    is_ok = true;
end

