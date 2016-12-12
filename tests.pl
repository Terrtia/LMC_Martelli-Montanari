(normalement réussie)
?- trace_unif([f(X,a) ?= f(g(Y),Y)],choix_pondere).
	system: [f(_G201,a)?=f(g(_G204),_G204)]
	decompose: f(_G201,a)?=f(g(_G204),_G204)
	system: [a?=_G204,_G201?=g(_G204)]
	orient: a?=_G204
	system: [_G204?=a,_G201?=g(_G204)]
	simplify: _G204?=a
	system: [_G201?=g(a)]
	expand: _G201?=g(a)
	Yes
X = g(a),
Y = a.

(normalement échoue)
?- trace_unif([f(b,a) ?= f(g(Y),Y)],choix_pondere).
	system: [f(b,a)?=f(g(_G204),_G204)]
	decompose: f(b,a)?=f(g(_G204),_G204)
	system: [a?=_G204,b?=g(_G204)]
	orient: a?=_G204
	system: [_G204?=a,b?=g(_G204)]
	simplify: _G204?=a
        [f(b,a)?=f(g(_G204),_G204)]
	No

(normalement échoue)
?- trace_unif([f(X,X) ?= f(g(Y),Y)],choix_pondere).
	system: [f(_G201,_G201)?=f(g(_G204),_G204)]
	decompose: f(_G201,_G201)?=f(g(_G204),_G204)
	system: [_G201?=_G204,_G201?=g(_G204)]
	rename: _G201?=_G204
        [f(_G1,_G1)?=f(g(_G2),_G2)]
	No

(normalement réussie)
?- trace_unif([f(X,Y) ?= f(Y,X)],choix_pondere).
	system: [f(_G201,_G202)?=f(_G202,_G201)]
	decompose: f(_G201,_G202)?=f(_G202,_G201)
	system: [_G201?=_G202,_G202?=_G201]
	rename: _G201?=_G202
	system: [_G201?=_G201]
	rename: _G201?=_G201
	Yes
X = Y.

(normalement échoue)
?- trace_unif([f(X,Y) ?= f(U,V,W)],choix_pondere).
        [f(_G201,_G202)?=f(_G204,_G205,_G206)]
	No

?- trace_unif([f(g(A), A) ?= f(B, xyz)], choix_pondere).
	system: [f(g(_G201),_G201)?=f(_G206,xyz)]
	decompose: f(g(_G201),_G201)?=f(_G206,xyz)
	system: [_G201?=xyz,g(_G201)?=_G206]
	simplify: _G201?=xyz
	system: [g(xyz)?=_G206]
	orient: g(xyz)?=_G206
	system: [_G2?=g(xyz)]
	expand: _G2?=g(xyz)
	Yes
A = xyz,
B = g(xyz).


%%%%%%%%%%%%%%%%%%%%%%%%%%%

[c ?= Z, f(b,a) ?= f(g(Y),Y), f(X,Y) ?= f(U,V,W)]

