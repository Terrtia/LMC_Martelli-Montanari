:-
	op(20,xfy,?=).

% Prédicats d'affichage fournis

% set_echo: ce prédicat active l'affichage par le prédicat echo
set_echo :-
	assert(echo_on).

% clr_echo: ce prédicat inhibe l'affichage par le prédicat echo
clr_echo :-
	retractall(echo_on).

% echo(T): si le flag echo_on est positionné, echo(T) affiche le terme T
%          sinon, echo(T) réussit simplement en ne faisant rien.

echo(T) :-
	echo_on,
	!,
	write(T).

echo(_).

% Prédicats

% Occur_check - finie
occur_check(V,T):-
	compound(T),
	var(V),
	contains_var(V,T).

% Regle - en cours
regle(E,R):-
	.

regle(X?=T,rename):-
	var(T),
	var(X).

regle(X?=T,simplify):-
	atomic(T),
	var(X).

regle(X?=T,orient):-
	var(X),
	nonvar(T).

regle(X?=T,check):-
	.

regle(X?=T,expand):-
	var(X),
	not(atomic(T)),
	nonvar(T),
	occur_check(X,T).

regle(X?=T,decompose):-
	.

regle(X?=T,clash):-
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
	X == T,
	not(occur_check(X,T)).

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
