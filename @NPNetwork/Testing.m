function Testing(obj,varargin)
    sigmoid_func = @(x) -1+2./(1+exp(-x));
    
    if nargin == 1  % default
        ifLinear        = false;
        ifHiddenLayer   = true;
    else
        for i = 1:nargin-1
            var1 = varargin{i};
            switch var1,
                case 'Linear'
                    ifLinear = true;
                case 'Nonlinear'
                    ifLinear = false;
                case 'Hidden Layer',
                    ifHiddenLayer = true;
                case 'No Hidden Layer',
                    ifHiddenLayer = false;
                otherwise,
                     display(['Argument ',var1,' is not correct']);
            end
        end
    end
    
    % get parameters from object properties
    L = obj.L;
    x_testing = obj.x_testing;
    d_testing = obj.d_testing;
    N = length(x_testing)-L;
    
    % convert streaming to matrix
    xTrainingMtx = zeros(L,N+L);
    for i = L:N+L,
        xtdl = x_testing(i:-1:i-L+1);
        xTrainingMtx(:,i) = xtdl;
    end
    
    % fixed layer
    if ifHiddenLayer,
        fixedWeightVec = obj.getFixedWeights();
        xtdl = xTrainingMtx;
        
        for i = 1:obj.NumOfHiddenLayer,
            fixed_weights = fixedWeightVec{i};
            xtdl = fixed_weights*xtdl;
            xtdl = sigmoid_func(xtdl);
        end
        
        fixedLayerMtx = xtdl;
    else
        fixedLayerMtx = xTrainingMtx;
    end
    
    % adaptive layer
    filter_error = zeros(N+L,1);
    filter_output = zeros(N+L,1);
    
    adaptive_weights = obj.getAdaptiveWeights();
    
    s = adaptive_weights'*fixedLayerMtx;
    
    if ifLinear,
        filter_output = s';
    else
        filter_output = sigmoid_func(s');
    end
    
    filter_error(L:end) = d_testing(L:end)-filter_output(L:end);
    
    obj.y_testing = filter_output;
    obj.e_testing = filter_error;
end
    
    
    
    
    