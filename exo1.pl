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
unifie([], _) :- echo('\n Success'), true, !.
unifie([]) :- echo('\n Echec'), false, !.


unifie(P):-
	unifie(P, regle),
	!.

unifie(P, regle):- unifie(P, rename),!,unifie(Q, regle).
unifie(P, regle):- unifie(P, simplify),!,unifie(Q, regle).
unifie(P, regle):- unifie(P, expand),!,unifie(Q, regle).
unifie(P, regle):- unifie(P, check),!,unifie(Q, regle).
unifie(P, regle):- unifie(P, orient),!,unifie(Q, regle).
unifie(P, regle):- unifie(P, decompose),!,unifie(Q, regle).
unifie(P, regle):- unifie(P, clash),!,unifie(Q, regle).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

unifie(P, rename) :- 
	P = [E |L],
	regle(E, rename),
	reduit(rename, E, P, Q),write(Q).


unifie(P, simplify):-
	P = [E |L],
	regle(E, simplify),
	reduit(simplify, E, P, Q),write(Q).

unifie(P, expand):-
	P = [E |L],
	regle(E, expand),
	reduit(expand, E, P, Q).

unifie(P, check):-
	P = [E |L],
	regle(E, check),
	reduit(check, E, P, Q).

unifie(P, orient):-
	P = [E |L],
	regle(E, orient),
	reduit(orient, E, P, Q).

unifie(P, decompose):-
	P = [E |L],
	regle(E, decompose),
	reduit(decompose, E, P, Q).

unifie(P, clash):-
	P = [E |L],
	regle(E, clash),
	reduit(clash, E, P, Q).


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


reduit(rename, E, P, Q):-
	splitEquation(E,X,T),
	X = T,
	P = [Head|Q].

reduit(simplify, E, P, Q):-
	splitEquation(E,X,T),
	X = T,
	P = [Head|Q].
	%simplify(X?=T, [X ?= T |Tail], Q).

%simplify(X ?= T, [X ?= T |Tail], Q):-
	%X = T,
	%Q = Tail.

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
