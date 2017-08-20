/*
 * A predicate that reads the input from File and returns it in
 * the next arguments: N, K, B, Steps and Broken.
 * Example:
 *
 * ?- read_input('h1.txt', N, K, B, Steps, Broken).
 * N = 10,
 * K = 3,
 * B = 4,
 * Steps = [1, 2, 4],
 * Broken = [2, 4, 6, 7].
 */
read_input(File, N, K, B, Steps, Broken) :-
    open(File, read, Stream),
    read_line(Stream, [N, K, B]),
    read_line(Stream, Steps),
    read_line(Stream, Broken).

/*
 * An auxiliary predicate that reads a line and returns the list of
 * integers that the line contains.
 */
read_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    ( Line = [] -> List = []
    ; atom_codes(A, Line),
      atomic_list_concat(As, ' ', A),
      maplist(atom_number, As, List)
   ).

countWays(N, N, _, _, _, Res, Ways):-
    Correct_N is N - 1,
    get_assoc(Correct_N, Res, Ways).
countWays(I, N, [], HelpSteps, ABroken, Res, Ways):-
    New_I is I + 1,
    countWays(New_I, N, HelpSteps, HelpSteps, ABroken, Res, Ways),!.
countWays(I, N, [StA|StB], HelpSteps, ABroken, Res, Ways):-
    /*print('S'),
    print(I),*/
    ( StA =< I,
      Dif is I - StA,
      ( \+ get_assoc(Dif, ABroken, Dif),
        get_assoc(Dif, Res, Add1),
        get_assoc(I, Res, Base),
        New_Res0 is Base + Add1,
        New_Res is New_Res0 mod 1000000009,
       /* print(New_Res),
        print(,),*/
        put_assoc(I, Res, New_Res, Resminus),
        countWays(I, N, StB, HelpSteps, ABroken, Resminus, Ways),!
      ; countWays(I, N, StB, HelpSteps, ABroken, Res, Ways),!
      )
    ; StA > I,
      countWays(I, N, StB, HelpSteps, ABroken, Res, Ways),!
    ).

hopping(File, Ways):-
    read_input(File, N, _, _, Steps, Broken),
    pairs_keys_values(Pairs, Broken, Broken),
    list_to_assoc(Pairs, ABroken),
    New_N is N + 1,
    numlist(0, New_N, X),
    Nplus2 is New_N + 1,
    length(Zeros, Nplus2),
    maplist(=(0), Zeros),
    pairs_keys_values(DesPairs, X, Zeros),
    list_to_assoc(DesPairs, Res0),
    put_assoc(1, Res0, 1, Res),
    countWays(2, New_N, Steps, Steps, ABroken, Res, Ways).

