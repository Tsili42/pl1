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
findWays(_, 0, _, [], _, 0).
findWays(N, _, _, _, _, W):-
    (N =< 1, W is N
    ;1 is 0
    ).
findWays(N, K, Br, [A|B], Broken, Ways):-
    New_N is N - A,
    (\+ member(New_N, Broken),
     findWays(New_N, K, Br, [A|B], Broken, Ways1),
     New_K is K - 1,
     findWays(N, New_K, Br, B, Broken, Ways2),
     Ways is Ways1 + Ways2
     ; New_K is K - 1,
     findWays(N, New_K, Br, B, Broken, Ways2),
     Ways is Ways2
    ).

hopping(File, Ways):-
    read_input(File, N, K, B, Steps, Broken),
    findWays(N, K, B, Steps, Broken, Ways).
