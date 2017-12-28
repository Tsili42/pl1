fun parse file =
    let
	(* a function to read an integer from an input stream *)
        fun next_int input =
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
	(* open input file and read the two integers in the first line *)
        val stream = TextIO.openIn file
        val n = next_int stream
	val _ = TextIO.inputLine stream
	(* a function to read the pair of integer & real in subsequent lines *)
        fun scanner 0 acc = acc
          | scanner i acc =
            let
                val d = next_int stream
            in
                scanner (i - 1) (d :: acc)
            end
    in
        (n, rev(scanner n []))
    end

fun build_list ([], indexlist, superlist, _, _, _) = (indexlist, superlist) 
  | build_list (a::b, [], [], 1, 42, c) = build_list(b, [1], [a], 2, a, c)
  | build_list (a::b, indexlist, superlist, n, x, c) =  
        if (c(a, x)) then build_list(b, indexlist @ [n], superlist @ [a], n+1, a, c)
        else build_list(b, indexlist, superlist,  n+1, x, c);

fun find_dist ([], _, _, _, _, max, _, _) = max
  | find_dist (a::b, [], i1::i2, _, prev_dist, max, primitive_right, primitive_Rindex) =
        if (prev_dist > max) then find_dist(b, primitive_right, i2, primitive_Rindex, 0, prev_dist, primitive_right, primitive_Rindex)
        else find_dist(b, primitive_right, i2, primitive_Rindex, 0, max, primitive_right, primitive_Rindex)
  | find_dist (a::b, c::d, e::f, g::h, prev_dist, max, primitive_right, primitive_Rindex) =
        if (c >= a) then find_dist(a::b, d, e::f, h, g - e, max, primitive_right, primitive_Rindex)
        else
          if (prev_dist > max) then find_dist(b, primitive_right, f, primitive_Rindex, 0, prev_dist, primitive_right, primitive_Rindex)
          else find_dist(b, primitive_right, f, primitive_Rindex, 0, max, primitive_right, primitive_Rindex);

fun indexlists (n, heights) =
    let
      val (rl_index, rl) = build_list(rev(heights), [], [], 1, 42, op >)
      val (ll_index, ll) = build_list(heights, [], [], 1, 42, op <)
    in
      let
        val correct_rli = map (fn x => n - x + 1) rl_index
        val correct = rev(correct_rli)
      in
        find_dist(ll, rev(rl), ll_index, correct, 0, 0, rev(rl), correct)
      end
    end

fun skitrip fileName = indexlists (parse fileName)
