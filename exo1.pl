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

unifie(P, regle):- unifie(P, rename).
unifie(P, regle):- unifie(P, simplify).
unifie(P, regle):- unifie(P, expand).
unifie(P, regle):- unifie(P, check).
unifie(P, regle):- unifie(P, orient).
unifie(P, regle):- unifie(P, decompose).
unifie(P, regle):- unifie(P, clash).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

unifie(P, rename) :- 
	P = [E |L],
	regle(E, rename),
	reduit(rename, E, P, Q),
	unifie(Q, regle),!.


unifie(P, simplify):-
	P = [E |L],
	regle(E, simplify),
	reduit(simplify, E, P, Q),
	unifie(Q, regle),!.

unifie(P, expand):-
	P = [E |L],
	regle(E, expand),
	reduit(expand, E, P, Q),
	unifie(Q, regle),!.

unifie(P, check):-
	P = [E |L],
	regle(E, check),
	reduit(check, E, P, Q),
	unifie(Q, regle),!.

unifie(P, orient):-
	P = [E |L],
	regle(E, orient),
	reduit(orient, E, P, Q),
	unifie(Q, regle),!.

unifie(P, decompose):-
	P = [E |L],
	regle(E, decompose),
	reduit(decompose, E, P, Q),
	unifie(Q, regle),!.

unifie(P, clash):-
	P = [E |L],
	regle(E, clash),
	reduit(clash, E, P, Q),
	unifie(Q, regle),!.


% Transformation du système d'équations P en un système d'équations Q par application de la règle de transformation à l'équation E


% reduit sur regle decompose - en cours
reduit(decompose, E, P, Q):-
	splitEquation(E,X,T),
	functor(X,NameX,ArityX),
	functor(T,NameT,ArityT),
	
	forall(upto(1,ArityX,1,IndiceArg), write(IndiceArg)).


reduit(rename, E, P, Q):-
	splitEquation(E,X,T),
	X = T,
	P = [Head|Q].

reduit(simplify, E, P, Q):-
	splitEquation(E,X,T),
	X = T,
	P = [Head|Q].


reduit(expand, E, P, Q):-
	splitEquation(E,X,T).

reduit(check, E, P, Q):-
	fail,
	!.

reduit(orient, E, P, Q):-
	splitEquation(E,X,T).
	P = [_|Q],
	Q = [X ?= T | []],write(Q).


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
