regle(E, rename):-
	splitEquation(E,X,T),
	var(T),
	var(X).

regle(E, simplify):-
	splitEquation(E,X,T),
	atomic(T),
	var(X).

regle(E, orient):-
	splitEquation(E,T,X),
	var(X),
	nonvar(T).

regle(E, check):-
	splitEquation(E,X,T),
	var(X),
	not(X==T),
	occur_check(X,T).

regle(E, expand):-
	splitEquation(E,X,T),
	var(X),
	not(atomic(T)),
	nonvar(T),
	not(occur_check(X,T)).

regle(E, decompose):-
	splitEquation(E,S,T),
	compound(S),
	compound(T),
	functor(S,NameS,ArityS),
	functor(T,NameT,ArityT),
	NameS == NameT,
	ArityS == ArityT.

regle(E, clash):- % revoir le double return
	splitEquation(E,S,T),
	compound(S),
	compound(T),
	functor(S,NameS,ArityS),
	functor(T,NameT,ArityT),
	\+(NameS == NameT; ArityS == ArityT).
