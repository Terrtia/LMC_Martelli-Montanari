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

% unification
unifie(P):-
	%unifie(P, strategy).
	unifie(P, simplify).

unifie([], _) :- true, !.
%unifie([]) :- false.

unifie(P, strategy):-
	P = [E |L],
	%regle(E, strategy),
	regle(E, simplify),
	%reduit(R, E, P, Q),
	reduit(simplify, E, P, Q),
	%unifie(Q, strategy).
	unifie(Q, simplify).


% Transformation du système d'équations P en un système d'équations Q par application de la règle de transformation à l'équation E


% reduit sur regle decompose - en cours
%reduit(decompose,E,P,Q):-
%	splitEquation(E,X,T),
%	% X = f(a)
%	% Y = f(b)
%	regle(X,T,decompose),
%	functor(X,NameX,ArityX),
%	functor(T,NameT,ArityT),
%	forall(upto(1,ArityX,1,IndiceArg),append(arg(IndiceArg,X,ValueX) ?= arg(IndiceArg,T,ValueT),Q,Q)).


%reduit(rename, E, P, Q):-
%	splitEquation(E,X,T),
%	X = T.

delete_elem(_, [], []) :- !.
delete_elem(Elem, [Elem|Set], Set):- ! .
delete_elem(Elem, [E|Set], [E|R]):-
	delete_elem(Elem, Set, R).

reduit(simplify, E, P, Q):-
	splitEquation(E,X,T),
	X = T,
	delete_elem(E,P,Q).
%	Q = [X = T | Q],
%	write(Q),
%	X = T,
%	P = [_ |Tail]. % suppression du premier élément de la liste
%	P = Tail. % P = queue de la liste

reduit(expand, E, P, Q):-
	splitEquation(E,X,T).

reduit(check, E, P, Q):-
	fail,
	!.

reduit(orient, E, P, Q):-
	splitEquation(E,X,T).


reduit(clash, E, P, Q):-
	fail,
	!.


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
