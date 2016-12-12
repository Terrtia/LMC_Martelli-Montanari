% Ajout d'autres fichiers pour simplier le code principal

:-
	[operateurs], % ?= , echo
	[predicatsRelais], % splitEquation
	[reglesTest]. % test de validité sur chaque règle

% Prédicats

% Occur_check
occur_check(V,T):-
	compound(T),
	var(V),
	contains_var(V,T).

% unif
unif(P,S) :-
	clr_echo,
	unifie(P,S).

% trace_unif
trace_unif(P,S) :-
	set_echo,
	(unifie(P,S),
	 echo('\tYes'),
	 !;
	 echo('\t'),
	 echo(P),
	 echo('\n'),
	 echo('\tNo')).

% unification
unifie([], _) :- !.
unifie([]) :- !.

% unification choix premier
unifie(P, choix_premier) :- 
	choix_premier(P, _, _, _),
	!.

%unification choix pondere
unifie(P, choix_pondere) :-
	choix_pondere(P, P, _, 1),
	!.

%unifie(P):-
	%unifie(P, regle),
	%!.

unifie(P, regle):- unifie(P, rename).
unifie(P, regle):- unifie(P, simplify).
unifie(P, regle):- unifie(P, expand).
unifie(P, regle):- unifie(P, check).
unifie(P, regle):- unifie(P, orient).
unifie(P, regle):- unifie(P, decompose).
unifie(P, regle):- unifie(P, clash).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fonction qui supprime l'equation du systeme d'equation
deleteEquation([], _, []):- !.              % si liste vide, on renvoie une liste vide
deleteEquation([Element | Tail], E, [Element| Tail2]):-
	not(Element == E),		    
	deleteEquation(Tail, E, Tail2),!.
	
deleteEquation([E | Tail], E, L):- 
	deleteEquation(Tail, E, L),!.       % on supprime l'element E de la liste

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

choix_premier(P, _, _, _):- 
	unifie(P, regle),
	!.
%%%%%%%%

	% niveau 1: clash, check
	% niveau 2: rename, simplify
	% niveau 3: orient
	% niveau 4: decompose
	% niveau 5: expand

choix_pondere([], _, _, _):-
	true.

choix_pondere(P, [], _, 1):-		% passage au niveau 2
	choix_pondere(P, P, _, 2),
	!.

choix_pondere(P, [], _, 2):-		% passage au niveau 3
	choix_pondere(P, P, _, 3),
	!.

choix_pondere(P, [], _, 3):-		% passage au niveau 4
	choix_pondere(P, P, _, 4),
	!.

choix_pondere(P, [], _, 4):-		% passage au niveau 5
	choix_pondere(P, P, _, 5),
	!.

% on a appliqué toutes les régles sans succés, échec de l'unification
choix_pondere(_, [], _, 5):-
	fail,
	!.

%%%%%%%%

%%%% clash, check (niveau 1)

%clash
choix_pondere(P, [Head|_], _, 1):-
	regle(Head , clash),
	!,
 	reduit(clash, Head, P, _),
	!.

%check
choix_pondere(_, [Head|_], _, 1):-
	regle(Head, check),
	!,
	reduit(check, Head, P, _),
	!.

% regles non applicables dans le système d'équations
choix_pondere(P, [Head|Tail], _, 1):-
	\+regle(Head, clash),
	\+regle(Head, check),
	!,
	choix_pondere(P, Tail, _, 1),		% on essaye d'appliquer les transformations de niveau 1
	!.					% sur l'equation suivante

%%%% rename, simplify (niveau 2)

% rename
choix_pondere(P, [Head|_], _, 2):-
	regle(Head, rename),
	!,
	deleteEquation(P, Head, ListTemp),	% on supprime l'equation E du systeme d'equation
	reduit(rename, Head, [Head|ListTemp], Q),
	choix_pondere(Q, [], _, 1),		% on applique la strategie choix_pondere sur le nouveau
	!.					% systeme d'equation

% simplify
choix_pondere(P, [Head|_], _, 2):-
	regle(Head, simplify),
	!,
	deleteEquation(P, Head, ListTemp),
	reduit(simplify, Head, [Head|ListTemp], Q),
	choix_pondere(Q, [], _, 1),
	!.

% regles non applicables dans le système d'équations
choix_pondere(P, [Head|Tail], _, 2):-
	\+regle(Head, rename),
	\+regle(Head, simplify),
	!,
	choix_pondere(P, Tail, _, 2),
	!.

%%%% orient (niveau 3)

% orient
choix_pondere(P, [Head|_], _, 3):-
	regle(Head, orient),
	!,
	deleteEquation(P, Head, ListTemp),
	reduit(orient, Head, [Head|ListTemp], Q),
	choix_pondere(Q, [], _, 1),
	!.

% regles non applicables dans le système d'équations
choix_pondere(P, [Head|Tail], _, 3):-
	\+regle(Head, orient),
	!,
	choix_pondere(P, Tail, _, 3),
	!.

%%%% decompose (niveau 4)

% decompose
choix_pondere(P, [Head|_], _, 4):-
	regle(Head, decompose),
	!,
	deleteEquation(P, Head, ListTemp),
	reduit(decompose, Head, [Head|ListTemp], Q),
	choix_pondere(Q, [], _, 1),
	!.

% regles non applicables dans le système d'équations
choix_pondere(P, [Head|Tail], _, 4):-
	\+regle(Head, decompose),
	!,
	choix_pondere(P, Tail, _, 4),
	!.

%%%% expand (niveau 5)

% expand
choix_pondere(P, [Head|_], _, 5):-
	regle(Head, expand),
	!,
	deleteEquation(P, Head, ListTemp),
	reduit(expand, Head, [Head|ListTemp], Q),
	choix_pondere(Q, [], _, 1),
	!.

% regles non applicables dans le système d'équations
choix_pondere(P, [Head|Tail], _, 5):-
	\+regle(Head, expand),
	!,
	choix_pondere(P, Tail, _, 5),
	!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

unifie(P, rename) :- 
	P = [E |_],
	regle(E, rename),
	reduit(rename, E, P, Q),
	unifie(Q, regle),!.


unifie(P, simplify):-
	P = [E |_],
	regle(E, simplify),
	reduit(simplify, E, P, Q),
	unifie(Q, regle),!.

unifie(P, expand):-
	P = [E |_],
	regle(E, expand),
	reduit(expand, E, P, Q),
	unifie(Q, regle),!.

unifie(P, check):-
	P = [E |_],
	regle(E, check),
	reduit(check, E, P, Q),
	unifie(Q, regle),!.

unifie(P, orient):-
	P = [E |_],
	regle(E, orient),
	reduit(orient, E, P, Q),
	unifie(Q, regle),!.

unifie(P, decompose):-
	P = [E |_],
	regle(E, decompose),
	reduit(decompose, E, P, Q),
	unifie(Q, regle),!.

unifie(P, clash):-
	P = [E |_],
	regle(E, clash),
	reduit(clash, E, P, Q),
	unifie(Q, regle),!.


% Transformation du système d'équations P en un système d'équations Q par application de la règle de transformation à l'équation E


% reduit sur regle decompose - en cours
reduit(decompose, E, P, Q):-
	echo('\tsystem: '),echo(P),nl,
	echo('\tdecompose: '),echo(E),nl,
	splitEquation(E,X,T),
	functor(X,_,ArityX),
	functor(T,_,_),
	P = [_|Tail],
	repet(X,T,ArityX,Tail,Q).

repet(_,_,0,T,Q):- Q = T, !.
repet(X,T,N,Tail,Q) :-
	N > 0,
	arg(N,X,ValX),
	arg(N,T,ValT),
	Var = [ValX?=ValT|Tail],
	N1 is N - 1,
	repet(X,T,N1,Var,Q).

reduit(rename, E, P, Q):-
	echo('\tsystem: '),echo(P),nl,
	echo('\trename: '),echo(E),nl,
	splitEquation(E,X,T),
	X = T,
	P = [_|Q].

reduit(simplify, E, P, Q):-
	echo('\tsystem: '),echo(P),nl,
	echo('\tsimplify: '),echo(E),nl,
	splitEquation(E,X,T),
	X = T,
	P = [_|Q].

reduit(expand, E, P, Q):-
	echo('\tsystem: '),echo(P),nl,
	echo('\texpand: '),echo(E),nl,
	splitEquation(E,X,T),
	X = T,
	P = [_|Q].

reduit(check, E, P, _):-
	echo('\tsystem: '),echo(P),nl,
	echo('\tcheck: '),echo(E),nl,
	fail,
	!.

reduit(orient, E, P, Q):-
	echo('\tsystem: '),echo(P),nl,
	echo('\torient: '),echo(E),nl,
	splitEquation(E,X,T),
	P = [_|Tail],
	Q = [T ?= X | Tail].


reduit(clash, E, P, _):-
	echo('\tsystem: '),echo(P),nl,
	echo('\tclash: '),echo(E),nl,
	fail,
	!.

