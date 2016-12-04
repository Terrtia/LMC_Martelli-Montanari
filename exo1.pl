:- op(20,xfy,?=).

% Prédicats d'affichage fournis

% set_echo: ce prédicat active l'affichage par le prédicat echo
set_echo :- assert(echo_on).

% clr_echo: ce prédicat inhibe l'affichage par le prédicat echo
clr_echo :- retractall(echo_on).

% echo(T): si le flag echo_on est positionné, echo(T) affiche le terme T
%          sinon, echo(T) réussit simplement en ne faisant rien.

echo(T) :- echo_on, !, write(T).
echo(_).


% Tests
regle(X?=T):-
	regle(X?=T,expand).


% Definitions des Transformations

% Rename
rename(X?=T):-
	var(T),
	var(X),
	X = T.

% Simplify
simplify(X?=T):-
	atomic(T),
	var(X),
	X = T.

% Orient
orient(T?=X):-
	not(var(T)),
	Z = T,
	T = X,
	X = Z.

% Check
check(X?=T):-
	var(X),
	X == T,
	term_variables(T,L),
	not(memberchk(X,L)).

% Expand
expand(X?=T):-
	var(X),
	not(atomic(T)),
	not(var(T)),
	term_variables(T,L),
	not(memberchk(X,L)),
	X = T.
