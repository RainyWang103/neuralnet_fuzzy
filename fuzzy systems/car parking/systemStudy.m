
a=readfis('parkcar');

plotfis(a)
ruleview(a)

ruleedit(a)

plotmf(a,'input',1), plotmf(a,'input',2),
plotmf(a ,'output',1)


park([ -15 30 -150 ], 'testdata')