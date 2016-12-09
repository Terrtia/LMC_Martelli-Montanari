splitEquation(E,X,T):-
	arg(1,E,L),
	arg(2,E,R),
	X = L,
	T = R.

upto(Low,High,_Step,Low) :-
	Low =< High.

upto(Low,High,Step,Var) :-
	Inc is Low+Step,
	Inc =< High,
	upto(Inc, High, Step, Var).

%renommage(X,T,SystemEquation):-
%	functor(SystemEquation,Name,Arity),
%	Arity >= 1,
%	SystemEquation = [Head | Tail],
%	renommageHead(X,T,Head),
%	renommage(X,T,Tail).
%
%renommageHead(X,T,Head):-
%	

