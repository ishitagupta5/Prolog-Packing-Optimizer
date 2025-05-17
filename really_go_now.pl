%copy and paste this predicate if you want or you can write your own

really_go_now([Head,List|Tail],Out) :-
	write(Out, "Capacity: "),
	write(Out,Head),
	write(Out, " Items to pack: "),write(Out, List),
	packing_list(List,Head,Set),
	sort(Set, Sorted),
	write(Out, " Pack this: "),write(Out,Sorted),
	writeln(Out,""),
	really_go_now(Tail,Out).

really_go_now([],_).