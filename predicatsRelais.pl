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
