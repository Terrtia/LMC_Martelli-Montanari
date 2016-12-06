% Ajout d'autres fichiers pour simplier le code principal

:-
	[operateurs], % ?= , echo
	[predicatsRelais], % splitEquation , upto
	[reglesTest]. % test de validité sur chaque regle

% Prédicats

% Occur_check
occur_check(V,T):-
	compound(T),
	var(V),
	contains_var(V,T).

% Regle
regle(E,R):-
	splitEquation(E,X,T),
	regle(X,T,R).

% reduit sur regle decompose - en cours
reduit(decompose,E,P,Q):-
	splitEquation(E,X,T),
	% X = f(a)
	% Y = f(b)
	regle(X,T,decompose),
	functor(X,NameX,ArityX),
	functor(T,NameT,ArityT),
	forall(upto(1,ArityX,1,IndiceArg),append(arg(IndiceArg,X,ValueX) ?= arg(IndiceArg,T,ValueT),Q,Q)).








% Definitions des Transformations

% Rename - finie
rename(X?=T):-
	var(T),
	var(X),
	X = T.

% Simplify - finie
simplify(X?=T):-
	atomic(T),
	var(X),
	X = T.

% Orient - finie
orient(T?=X):-
	var(X),
	nonvar(T),
	Z = T,
	T = X,
	X = Z.

% Check - en cours - difficile
check(X?=T):-
	var(X),
	not(X == T),
	occur_check(X,T).

% Expand - finie
expand(X?=T):-
	var(X),
	not(atomic(T)),
	nonvar(T),
	occur_check(X,T),
	X = T.

% Decompose - en cours - difficile
decompose(S?=T):-
	compound(S),
	compound(T),
	functor(S,NameS,ArityS),
	functor(T,NameT,ArityT),
	NameS == NameT,
	ArityS == ArityT,
	arg(1,S,ValueS),
	arg(1,T,ValueT),
	ValueS ?= ValueT.

% Clash - en cours
clash(X?=T):-
	var(X),
	var(T),
	X == T.
