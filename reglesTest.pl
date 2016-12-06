regle(X,T,rename):-
	var(T),
	var(X).

regle(X,T,simplify):-
	atomic(T),
	var(X).

regle(X,T,orient):-
	var(X),
	nonvar(T).

regle(X,T,check):-
	var(X),
	not(X==T),
	occur_check(X,T).

regle(X,T,expand):-
	var(X),
	not(atomic(T)),
	nonvar(T),
	occur_check(X,T).

regle(S,T,decompose):-
	compound(S),
	compound(T),
	functor(S,NameS,ArityS),
	functor(T,NameT,ArityT),
	NameS == NameT,
	ArityS == ArityT.

regle(S,T,clash):- % revoir le double return
	compound(S),
	compound(T),
	functor(S,NameS,ArityS),
	functor(T,NameT,ArityT),
	(NameS == NameT;
	ArityS == ArityT).
