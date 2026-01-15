
fun = @(x) x(1).*exp(-(x(1).^2+x(2).^2));
fsurf(@(x,y)x.*exp(-(x.^2+y.^2)))
%%

rng default  % For reproducibility
options=optimoptions("particleswarm","SwarmSize",100,"Display","iter","SelfAdjustmentWeight",1.5,"MaxStallTime",50,"FunctionTolerance",0.000000000001,"SocialAdjustmentWeight",1.8,PlotFcn="pswplotbestf")
x = particleswarm(fun,2,[],[],options)

