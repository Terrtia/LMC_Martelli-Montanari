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
	 echo("Yes"),
	 !;
	 echo("No")).

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
deleteEquation([], _, []):- !.                % si liste vide, on renvoie une liste vide
deleteEquation([Element | Tail], E, [Element| Tail2]):-
	not(Element == E),
	%echo('\n'),echo('\t E= '),echo(E),
	deleteEquation(Tail, E, Tail2),!.
	
deleteEquation([E | Tail], E, L):- 
	deleteEquation(Tail, E, L),!.       % on supprime l'element E de la liste

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

choix_premier(P, _, _, _):- 
	unifie(P, regle),
	!.
%%%%%%%%

choix_pondere([], _, _, _):-
	true.

choix_pondere(P, [], _, 1):-
	%echo('\n'),
	%echo('\t 1to2'),
	%echo(P),
	%echo('\n'),
	choix_pondere(P, P, _, 2),
	!.

choix_pondere(P, [], _, 2):-
	%echo('\n'),
	%echo('\t 2to3'),
	%echo(P),
	%echo('\n'),
	choix_pondere(P, P, _, 3),
	!.

choix_pondere(P, [], _, 3):-
	%echo('\n'),
	%echo('\t 3to4'),
	%echo(P),
	%echo('\n'),
	choix_pondere(P, P, _, 4),
	!.

choix_pondere(P, [], _, 4):-
	%echo('\n'),
	%echo('\t 4to5'),
	%echo(P),
	%echo('\n'),
	choix_pondere(P, P, _, 5),
	!.

% on a appliqué toutes les régles sans succés, échec de l'unification
choix_pondere(_, [], _, 5):-
%	echo('\n'),
%	echo('\t fail'),
	fail,
	!.

%%%%%%%%

%%%% clash, check

%clash
choix_pondere(_, [Head|_], _, 1):-
	regle(Head , clash),
	!,
%	echo('\t fail clash'),
	fail,
	!.

%check
choix_pondere(_, [Head|_], _, 1):-
	regle(Head, check),
	!,
%	echo('\t fail check'),
	fail,
	!.

% regles non applicables dans le système d'équations
choix_pondere(P, [Head|Tail], _, 1):-
	\+regle(Head, clash),
	\+regle(Head, check),
	!,
	choix_pondere(P, Tail, _, 1),
	!.

%%%% rename, simplify

% rename
choix_pondere(P, [Head|_], _, 2):-
	regle(Head, rename),
	!,
	%echo('\n'),
	%echo('\t head= '),echo(Head),
	deleteEquation(P, Head, ListTemp),
	%echo('\n'),echo('\t ListTemp= '),echo(ListTemp),
	%echo('\n'),echo('\t ListTemp++= '),echo([Head|ListTemp]),
	%echo('\n'),echo('\t head= '),echo(Head),
	reduit(rename, Head, [Head|ListTemp], Q),
	%echo('\n'),
	%echo('\t rename q='),
	%echo(Q),
	choix_pondere(Q, [], _, 1),
	!.

% simplify
choix_pondere(P, [Head|_], _, 2):-
	regle(Head, simplify),
	!,
	%echo('\n'),
	%echo('\t head0 : '),echo(Head),
	deleteEquation(P, Head, ListTemp),
	reduit(simplify, Head, [Head|ListTemp], Q),
	%echo('\t simplify q='),
	%echo(Q),
	%echo('\t head : '),echo(Head),echo('\t listTemp : '),echo(ListTemp),
	choix_pondere(Q, [], _, 1),
	!.

% regles non applicables dans le système d'équations
choix_pondere(P, [Head|Tail], _, 2):-
	\+regle(Head, rename),
	\+regle(Head, simplify),
	!,
	choix_pondere(P, Tail, _, 2),
	!.

%%%% orient

% orient
choix_pondere(P, [Head|_], _, 3):-
	regle(Head, orient),
	!,
	%echo('\n'),
	%echo('\t head : '),echo(Head),
	deleteEquation(P, Head, ListTemp),
	reduit(orient, Head, [Head|ListTemp], Q),
	%echo('\t orient : q='),
	%echo(Q),
	%echo('\t head : '),echo(Head),echo('\t listTemp : '),echo(ListTemp),
	choix_pondere(Q, [], _, 1),
	!.

% regles non applicables dans le système d'équations
choix_pondere(P, [Head|Tail], _, 3):-
	\+regle(Head, orient),
	!,
	choix_pondere(P, Tail, _, 3),
	!.

%%%% decompose

% decompose
choix_pondere(P, [Head|_], _, 4):-
	%echo('\t je verifie decompose'),
	%echo('\t head= '), echo(Head),
	regle(Head, decompose),
	!,
	%echo('\t je peux decompose'),
	deleteEquation(P, Head, ListTemp),
	reduit(decompose, Head, [Head|ListTemp], Q),
	%echo('\n'),
	%echo('\t decompose q='),
	%echo(Q),
	choix_pondere(Q, [], _, 1),
	!.

% regles non applicables dans le système d'équations
choix_pondere(P, [Head|Tail], _, 4):-
	\+regle(Head, decompose),
	!,
	choix_pondere(P, Tail, _, 4),
	!.

%%%% expand

% expand
choix_pondere(P, [Head|_], _, 5):-
	regle(Head, expand),
	!,
	deleteEquation(P, Head, ListTemp),
	reduit(expand, Head, [Head|ListTemp], Q),
	%echo('\n'),
	%echo('\t expand q='),
	%echo(Q),
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
	echo("system: "),echo(P),nl,
	echo("decompose: "),echo(E),nl,
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
	echo("system: "),echo(P),nl,
	echo("rename: "),echo(E),nl,
	splitEquation(E,X,T),
	X = T,
	P = [_|Q].

reduit(simplify, E, P, Q):-
	echo("system: "),echo(P),nl,
	echo("simplify: "),echo(E),nl,
	splitEquation(E,X,T),
	X = T,
	P = [_|Q].

reduit(expand, E, P, Q):-
	echo("system: "),echo(P),nl,
	echo("expand: "),echo(E),nl,
	splitEquation(E,X,T),
	X = T,
	P = [_|Q].

reduit(check, E, P, _):-
	echo("system: "),echo(P),nl,
	echo("check: "),echo(E),nl,
	fail,
	!.

reduit(orient, E, P, Q):-
	echo("system: "),echo(P),nl,
	echo("orient: "),echo(E),nl,
	splitEquation(E,X,T),
	P = [_|Tail],
	Q = [T ?= X | Tail].


reduit(clash, E, P, _):-
	echo("system: "),echo(P),nl,
	echo("clash: "),echo(E),nl,
	fail,
	!.

