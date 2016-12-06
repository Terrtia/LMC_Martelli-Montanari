% Ajout d'autres fichiers pour simplier le code principal

:-
	[operateurs],
	[predicatsRelais],
	[reglesTest].

% Prédicats

% Occur_check - finie
occur_check(V,T):-
	compound(T),
	var(V),
	contains_var(V,T).

% Regle - en cours
regle(E,R):-
	splitEquation(E,X,T),
	regle(X,T,R).

% Transformation du système d'équations P en un système d'équations Q par application de la règle de transformation à l'équation E

reduit(rename, E, P, Q):-
	splitEquation(E,X,T),
	.

reduit(simplify, E, P, Q):-
	splitEquation(E,X,T),
	.

reduit(expand, E, P, Q):-
	splitEquation(E,X,T),
	.

reduit(check, E, P, Q):-
	splitEquation(E,X,T),
	.

reduit(orient, E, P, Q):-
	splitEquation(E,X,T),
	.

reduit(decompose, E, P, Q):-
	.

reduit(clash, E, P, Q):-
	splitEquation(E,X,T),
	.


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
