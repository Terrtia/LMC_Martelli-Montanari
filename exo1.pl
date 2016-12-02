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

% Definitions des Transformations

  regle(X ?= T):- regle(X ?= T, simplify).

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


%unifie(P) :- regle(E).

%regle(E, simplify):-
    


%occur_check(V, T).

%reduit(R,E,P,Q).

%decompose().
