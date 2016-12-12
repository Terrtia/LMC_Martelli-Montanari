(normalement réussie)
?- trace_unif([f(X,a) ?= f(g(Y),Y)],choix_pondere).
	system: [f(_384,a)?=f(g(_390),_390)]
	decompose: f(_384,a)?=f(g(_390),_390)
	system: [a?=_390,_384?=g(_390)]
	orient: a?=_390
	system: [_390?=a,_384?=g(_390)]
	simplify: _390?=a
	system: [_384?=g(a)]
	expand: _384?=g(a)

	Yes
X = g(a),
Y = a.


(normalement échoue)
?- trace_unif([f(b,a) ?= f(g(Y),Y)],choix_pondere).
	system: [f(b,a)?=f(g(_390),_390)]
	decompose: f(b,a)?=f(g(_390),_390)
	system: [a?=_390,b?=g(_390)]
	orient: a?=_390
	system: [_390?=a,b?=g(_390)]
	simplify: _390?=a
	[f(b,a)?=f(g(_390),_390)]

	No


(normalement échoue)
?- trace_unif([f(X,X) ?= f(g(Y),Y)],choix_pondere).
	system: [f(_384,_384)?=f(g(_390),_390)]
	decompose: f(_384,_384)?=f(g(_390),_390)
	system: [_384?=_390,_384?=g(_390)]
	rename: _384?=_390
	system: [_384?=g(_384)]
	check: _384?=g(_384)
	[f(_384,_384)?=f(g(_390),_390)]

	No


(normalement réussie)
?- trace_unif([f(X,Y) ?= f(Y,X)],choix_pondere).
	system: [f(_384,_386)?=f(_386,_384)]
	decompose: f(_384,_386)?=f(_386,_384)
	system: [_384?=_386,_386?=_384]
	rename: _384?=_386
	system: [_384?=_384]
	rename: _384?=_384

	Yes
X = Y.


(normalement échoue)
?- trace_unif([f(X,Y) ?= f(U,V,W)],choix_pondere).
	system: [f(_384,_386)?=f(_390,_392,_394)]
	clash: f(_384,_386)?=f(_390,_392,_394)
	[f(_384,_386)?=f(_390,_392,_394)]

	No


?- trace_unif([f(g(A), A) ?= f(B, xyz)], choix_pondere).
	system: [f(g(_384),_384)?=f(_394,xyz)]
	decompose: f(g(_384),_384)?=f(_394,xyz)
	system: [_384?=xyz,g(_384)?=_394]
	simplify: _384?=xyz
	system: [g(xyz)?=_394]
	orient: g(xyz)?=_394
	system: [_8?=g(xyz)]
	expand: _8?=g(xyz)

	Yes
A = xyz,
B = g(xyz).



%%%%%%%%%%%%%%%%%%%%%%%%%%%

[c ?= Z, f(b,a) ?= f(g(Y),Y), f(X,Y) ?= f(U,V,W)]

