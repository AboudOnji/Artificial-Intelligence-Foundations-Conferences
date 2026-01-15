
fun = @(x) 20+x(1)^2+x(2)^2-10*((cos(2*pi*x(1)))+(cos(2*pi*x(2))));
fsurf (@(x,y) 20+x.^2+y.^2-10*((cos(2*pi.*x))+(cos(2*pi.*y))))
%%





options=optimoptions("particleswarm","MaxIterations",500,"SocialAdjustmentWeight" ...
    ,2,"SelfAdjustmentWeight",2,"FunctionTolerance",0.0000000000000000001 ...
    ,"MinNeighborsFraction",0.9,"Display","iter",PlotFcn="pswplotbestf");
[x,f]=particleswarm(fun,2,[],[],options)
