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
	 echo('\n'),
	 echo('\tYes'),
	 !;
	 echo('\t'),
	 echo(P),
	 echo('\n\n'),
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
	choix_pondere(P, P, _, 0),
	!.

%unification choix aleatoire
unifie(P, choix_aleatoire) :-
	choix_equation_aleatoire(P,_,_,_),
	!.

unifie(P, regle):- unifie(P, autreclash).
unifie(P, regle):- unifie(P, elimination).
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

choix_equation_aleatoire([],_,_,_):- !.

choix_equation_aleatoire(P,_,_,_):-
	random_member(E, P), 				% on choisit aleatoirement une equation
	deleteEquation(P, E, ListTemp),			% on supprime cette equation de la liste
	reduit_random([E|ListTemp], E, Q, regle),	% on essaie d'appliquer les transformations E, nouvelle liste = Q
	choix_equation_aleatoire(Q,_,_,_).

reduit_random(ListTemp2, E, Q, regle) :- regle(E, autreclash), !, reduit(autreclash, E, ListTemp2, Q).
reduit_random(ListTemp2, E, Q, regle) :- regle(E, elimination), !, reduit(elimination, E, ListTemp2, Q).
reduit_random(ListTemp2, E, Q, regle) :- regle(E, rename), !, reduit(rename, E, ListTemp2, Q).
reduit_random(ListTemp2, E, Q, regle) :- regle(E, simplify), !, reduit(simplify, E, ListTemp2, Q).
reduit_random(ListTemp2, E, Q, regle) :- regle(E, expand), !, reduit(expand, E, ListTemp2, Q).
reduit_random(ListTemp2, E, Q, regle) :- regle(E, check), !, reduit(check, E, ListTemp2, Q).
reduit_random(ListTemp2, E, Q, regle) :- regle(E, orient), !, reduit(orient, E, ListTemp2, Q).
reduit_random(ListTemp2, E, Q, regle) :- regle(E, decompose), !, reduit(decompose, E, ListTemp2, Q).
reduit_random(ListTemp2, E, Q, regle) :- regle(E, clash), !, reduit(clash, E, ListTemp2, Q).

%%%%%%%%

	% niveau 0: autreclash, elimination
	% niveau 1: clash, check
	% niveau 2: rename, simplify
	% niveau 3: orient
	% niveau 4: decompose
	% niveau 5: expand

choix_pondere([], _, _, _):-
	true.

choix_pondere(P, [], _, 0):-		% passage au niveau 1
	choix_pondere(P, P, _, 1),
	!.

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

%%%% autreclash, elimination (niveau 0)

%clash
choix_pondere(P, [Head|_], _, 0):-
	regle(Head , autreclash),
	!,
 	reduit(autreclash, Head, P, _),
	!.

%check
choix_pondere(P, [Head|_], _, 0):-
	regle(Head, elimination),
	!,
	reduit(elimination, Head, P, _),
	!.

% regles non applicables dans le système d'équations
choix_pondere(P, [Head|Tail], _, 0):-
	\+regle(Head, autreclash),
	\+regle(Head, elimination),
	!,
	choix_pondere(P, Tail, _, 0),		% on essaye d'appliquer les transformations de niveau 1
	!.					% sur l'equation suivante


%%%% clash, check (niveau 1)

%clash
choix_pondere(P, [Head|_], _, 1):-
	regle(Head , clash),
	!,
 	reduit(clash, Head, P, _),
	!.

%check
choix_pondere(P, [Head|_], _, 1):-
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
	choix_pondere(Q, Q, _, 0),		% on applique la strategie choix_pondere sur le nouveau
	!.					% systeme d'equation

% simplify
choix_pondere(P, [Head|_], _, 2):-
	regle(Head, simplify),
	!,
	deleteEquation(P, Head, ListTemp),
	reduit(simplify, Head, [Head|ListTemp], Q),
	choix_pondere(Q, Q, _, 0),
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
	choix_pondere(Q, Q, _, 0),
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
	choix_pondere(Q, Q, _, 0),
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
	choix_pondere(Q, Q, _, 0),
	!.

% regles non applicables dans le système d'équations
choix_pondere(P, [Head|Tail], _, 5):-
	\+regle(Head, expand),
	!,
	choix_pondere(P, Tail, _, 5),
	!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

unifie(P, autreclash):- 
	P = [E |_],
	regle(E, autreclash),
	reduit(autreclash, E, P, Q),
	unifie(Q, regle),!.

unifie(P, elimination):- 
	P = [E |_],
	regle(E, elimination),
	reduit(elimination, E, P, Q),
	unifie(Q, regle),!.

unifie(P, rename) :- % Placer dans Q le resultat de l'unification avec la transformation rename
	P = [E |_], % Placer dans E la tete du systeme d'equation P
	regle(E, rename), % Test de l'applicabilite de la regle rename sur l'equation E
	reduit(rename, E, P, Q), % Application de la regle
	unifie(Q, regle),!. % Appel recursif sur l'unification de Q avec une nouvelle regle


unifie(P, simplify):- % Meme raisonnement que precedemment
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


reduit(autreclash, E, P, _):-
	echo('\tsystem: '),echo(P),nl,
	echo('\tclashcons: '),echo(E),nl,
	fail,
	!.

reduit(elimination, E,P, Q):-
	echo('\tsystem: '),echo(P),nl, % Affichage des etapes pour le trace_unif
	echo('\telimination: '),echo(E),nl,
	splitEquation(E,X,T),
	P = [_|Tail],
	Q = Tail.


reduit(decompose, E, P, Q):-
	echo('\tsystem: '),echo(P),nl, % Affichage des etapes pour le trace_unif
	echo('\tdecompose: '),echo(E),nl,
	splitEquation(E,X,T), % Separe E en X et T avec comme separateur ?=
	functor(X,_,ArityX), % Recuperation de l'arite de X
	functor(T,_,_),
	P = [_|Tail], % Recup de la queue de la liste P dans Tail
	repet(X,T,ArityX,Tail,Q). % Boucle iterative pour verifier l'unification sur tous les arguments des fonctions

repet(_,_,0,T,Q):- Q = T, !. % Arret du predicat repet et affectation du resultat dans Q
repet(X,T,N,Tail,Q) :-
	N > 0, % Condition d'arret
	arg(N,X,ValX), % Recuperer l'argument a l'indice N dans X et le mettre dans ValX
	arg(N,T,ValT),
	Var = [ValX?=ValT|Tail], % Var va desormais contenir ValX ?= ValT en plus dans la liste Tail
	N1 is N - 1, % Decrementation de la boucle
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

