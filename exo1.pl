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



regle(X, decompose) :-
	arg(1, X, Y),
	arg(2, X, Z),
	functor(Y, NA, AA),
	functor(Z, NB, AB),
	NA == NB,
	AA == AB.

regle(X ?= T):- regle(X ?= T, simplify).


% Definitions des Transformations

rename(X,T):-
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

