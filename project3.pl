
:- use_module(library(lists)).
:- use_module(library(readutil)).      % read_line_to_string/2
:- use_module(library(dcg/basics)).    % normalize_space/2
:- initialization(main, main).

main :-
    current_prolog_flag(argv, Argv),
    ( Argv = [InFile, OutFile | _] -> true
    ; writeln(user_error, 'Usage: swipl project3.pl <input> <output>'),
      halt(1)
    ),
    setup_call_cleanup(open(InFile, read,  In),   read_pairs(In,  Pairs), close(In)),
    setup_call_cleanup(open(OutFile, write, Out), really_go_now(Pairs, Out), close(Out)),
    halt.


read_pairs(Stream, Pairs) :-
    read_line_to_string(Stream, Line0),
    ( Line0 == end_of_file ->
        Pairs = []
    ; normalize_space(string(Line), Line0),
      ( Line == "" ->
          read_pairs(Stream, Pairs)               % skip blank lines
      ; parse_line(Line, Cap, Items),
        Pairs = [Cap, Items | Rest],
        read_pairs(Stream, Rest)
      )
    ).

parse_line(Line, Cap, Items) :-
    split_string(Line, " ", "", [CapStr|RestStrings]),
    number_string(Cap, CapStr),
    maplist(atom_string, RestAtoms, RestStrings),
    atomic_list_concat(RestAtoms, ' ', ItemsAtom),
    atom_string(ItemsAtom, ItemsStr),
    term_string(Items, ItemsStr).

really_go_now([Cap,Items|Tail], Out) :-
    write(Out, 'Capacity: '), write(Out, Cap),
    write(Out, ' Items to pack: '), write(Out, Items),
    packing_list(Items, Cap, Set),
    sort(Set, Sorted),
    write(Out, ' Pack this: '), write(Out, Sorted), nl(Out),
    really_go_now(Tail, Out).
really_go_now([], _).

packing_list(Items0, Cap, OptimalPackings) :-
    list_to_set(Items0, Items),
    findall(P, optimal_packing(Items, Cap, P), Ps),
    ( Ps == [] -> OptimalPackings = [[]] ; OptimalPackings = Ps ).

optimal_packing(Items, Cap, Packed) :-
    pack_items(Items, Cap, Packed),
    sum_weights(Packed, WSum),
    Rem is Cap - WSum,
    multiset_subtract(Items, Packed, Left),
    \+ ( member([_,W], Left), W =< Rem ).

pack_items(_Avail, 0, []) :- !.       % bag exactly full
pack_items([], _Cap, []) :- !.        % nothing left
pack_items(_Avail, Cap, []) :- Cap > 0.  % decide to stop early
pack_items(Avail, Cap, [Item|Rest]) :-
    select(Item, Avail, Avail1),
    Item = [_,W], W =< Cap,
    Cap1 is Cap - W,
    pack_items(Avail1, Cap1, Rest).

sum_weights([], 0).
sum_weights([[_,W]|T], Sum) :-
    sum_weights(T, S1),
    Sum is S1 + W.

multiset_subtract([], _, []).
multiset_subtract([H|T], L2, R) :-
    ( select(H, L2, L2Rest) ->
        multiset_subtract(T, L2Rest, R)
    ; R = [H|R1],
      multiset_subtract(T, L2, R1)
    ).
