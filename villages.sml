(* The signature used below was taken from the following url:
* https://github.com/gruenewa/sml-snippets/blob/master/unionfind/union-find.sml
* This structure simply implements the basic operations needed for the
* union-find algorithm (connected, union) *)

signature UNIONFIND =
  sig

    type t

    val create : int -> t
    val union : t * int * int -> unit
    val connected : t * int * int -> bool              

  end

structure QuickUnion :> UNIONFIND = 
  struct

    open Array

    type t = int array

    fun create n =
        tabulate (n, fn x => x)

    fun root (id, n) = 
        let val i = ref n in
          (while !i <> sub (id, !i) do i := sub (id, !i); !i)
        end

    fun connected (id, p, q) = 
        root (id, p) = root (id, q)

    fun union (id, p, q) = 
        let
          val i = root (id, p)
          val j = root (id, q)
        in
          update (id, i, j)
        end
  end


fun parse file =
    let
	(* a function to read an integer from an input stream *)
        fun next_int input =
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
	(* open input file and read the three integers in the first line *)
        val stream = TextIO.openIn file
        val n = next_int stream
        val m = next_int stream
        val k = next_int stream
	val _ = TextIO.inputLine stream
	(* a function to read the pair of integers in subsequent lines *)
        fun scanner 0 acc = acc
          | scanner i acc =
            let
                val d = next_int stream
                val v = next_int stream
            in
                scanner (i - 1) ((d, v) :: acc)
            end
    in
        (n, m, k,  rev(scanner m []))
    end

(* The following function connects the villages with the initial roads, namely
* it constructs the topology of the problem *)
fun init_roads ([], _, s_un) = s_un
  | init_roads ((a,b)::l, vs, s_un) = (
      let
        val flag = QuickUnion.connected(vs, a - 1, b - 1)
      in
        QuickUnion.union(vs, a - 1, b - 1);
        if (not flag) then init_roads(l, vs, init_roads(l, vs, s_un + 1))
        else init_roads(l, vs, s_un)
      end
      )
      
(* The following function connects (topologically) each village with its
* (algebraic) neighbor, i.e. village number 10 connects with village number 11,
* if there are not already connected. *)
fun new_roads (_, 0, succ_unions, _, _) = succ_unions
  | new_roads (vs, k, succ_unions, counter, n) = (
      if (n - succ_unions = 1) then succ_unions + 1 else (
        let
          val a = QuickUnion.connected(vs, counter, counter + 1)
        in
          if (not a) then (QuickUnion.union(vs, counter, counter + 1); new_roads(vs, k - 1, succ_unions + 1, counter + 1, n))
          else new_roads(vs, k, succ_unions, counter + 1, n)
        end )
      )

fun unionFind_solution (n, m, k, roads) = 
  let 
    val vs = QuickUnion.create n
    val succ_un = init_roads(roads, vs, 0)
   in 
    let
      val res = new_roads(vs, k, succ_un, 0, n - 1)
    in
      n - res (* The number of connected components *)
    end
  end

fun villages fileName = unionFind_solution (parse fileName)
