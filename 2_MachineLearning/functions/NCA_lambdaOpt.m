function [bestlambda] = NCA_lambdaOpt(folder, Nucleus)
% 
% Copyright (c) 2023 Conrad Szczuka
%
% load data
[FeaturesX,Calc] = loadData(folder);
ResponseTab = Calc{:,string(Calc.Properties.VariableNames)==Nucleus};
X = table2array(FeaturesX); y = table2array(ResponseTab);
%% perform NCA lambda optimization
cvp = cvpartition(length(y),'kfold',4);
numtestsets = cvp.NumTestSets;

for i = 1:size(y,2)

    % Lambda optimization
    lambdavals = linspace(0.001,0.3,40);
    for j = 1:length(lambdavals)
        for k = 1:numtestsets
            Xtrain = X(cvp.training(k),:);
            ytrain = y(cvp.training(k),i);
            Xtest = X(cvp.test(k),:);
            ytest = y(cvp.test(k),i);

            nca = fsrnca(Xtrain,ytrain,'FitMethod','exact', ...
                'Solver','lbfgs','Lambda',lambdavals(j),'Standardize',true);

            lossvals(j,k) = loss(nca,Xtest,ytest,'LossFunction','mse');
        end
    end
    lossmatrix(:,i) = mean(lossvals,2); %compute mean of all 4 cross validation sets  
end
% plot Loss versus lambda
figure
plot(lambdavals,lossmatrix,'o-')
xlabel('Lambda')
ylabel('Loss (MSE)')
grid on
legend(ResponseTab.Properties.VariableNames)
% determine best lambda for all 
[~,idx] = min(lossmatrix,[],1);
bestlambda = mean(lambdavals(idx));
disp('The optimized lambda regularization parameter for all hyperfine parameters is: '), disp(string(bestlambda))
end

