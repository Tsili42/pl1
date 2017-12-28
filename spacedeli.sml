fun parse file =
   let
     fun next_String input = (TextIO.inputAll input) 
     val stream = TextIO.openIn file
     val a = next_String stream
     val b = explode (a)
     fun notCtrl (c) = if (Char.isCntrl c) then false
                 else true
     val okList = List.filter notCtrl b
     fun findM ([], kappa) = kappa 
       | findM (a::b, counter) = if (Char.isCntrl a) then counter
                                 else findM(b, counter + 1)
     val m = findM (b, 0)
     fun findS ([], pos) = pos
       | findS (a::b, pos) = if (a = #"S") then pos
                             else findS(b, pos + 1)
     val s = findS(okList, 1) 
     val n = List.length okList div m
   in
     (okList, m, s, n)
   end  

(* O skeletos tou kwdika gia thn dhmiourgia ths priority queue "empneusthke" apo
* to ekshs link:
* https://github.com/josepablocam/symfun/blob/master/priority_queue/src/ml/priority_queue.sml
* *)
datatype 'a queue = Q of (int * int * int) list;

(* enqueue helper returns a list for enqueue to wrap in data constructor *)
fun enqueue0 new [] = [new]
|	enqueue0 (new as (l, _, p1)) (old as (a, b, p2) :: xs) = 
	if p1 > p2 orelse (p1 = p2 andalso l > a) then (a, b, p2) :: enqueue0 new xs 
	else new :: old
;

(* returns a new queue with the element enqueued according to priority *)
fun enqueue a b p (Q q) = Q (enqueue0 (a, b, p) q); 

(* returns a tuple of an option containing the element and new queue *)
fun dequeue (Q []) = ((0, 0, 0), Q [])
|	dequeue (Q ((a, b, p) :: xs)) = ((a, b, p), Q xs)
;

fun findSol(_, ~1) = ""
  | findSol (prev, pos) =
      let
        val (a, b) = Array.sub(prev, pos)
      in
       findSol(prev, a) ^ b
      end
 

fun probSolver (Q([]), _, _, _, _, _) = (42, "No solution was found")
  | probSolver (q, arr, prev, m, n, qArr) =
    let
      val ((loaded, pos, cost), q1) = dequeue q
      val mychar = Array.sub(arr, pos - 1) 
    in
      Array.update(qArr, 0, q1);
      if (loaded = 1 andalso mychar = #"E") then
        let
          val zAns = findSol(prev, 2 * (pos - 1) + 1)
          val correctAns = String.extract(zAns, 1, NONE)
        in          
          (cost, correctAns)
        end
      else (
        if (pos > m) then (* UP *) (
          
          let
            val newChar = Array.sub(arr, pos - m - 1) 
            val newState = 2 * (pos - m -1) + loaded
            val (a, _) = Array.sub(prev, newState) 
          in
            if (newChar <> #"X" andalso a = ~1 andalso (newChar <> #"S" orelse loaded = 0)) then (
              Array.update(prev, newState, (2 * (pos - 1) + loaded, "U"));

              let
                val newQ = enqueue (loaded) (pos - m) (cost + 1 + loaded) q1
              in
                Array.update(qArr, 0, newQ)
              end
              )
            else ()
          end
          )
        else ();
        if (pos mod m <> 1) then (* LEFT *) (
          
          let
            val newChar = Array.sub(arr, pos - 2)
            val newState = 2 * (pos - 2) + loaded
            val (a, _) = Array.sub(prev, newState) 
          in
            if (newChar <> #"X" andalso a = ~1 andalso (newChar <> #"S" orelse loaded = 0)) then (
              Array.update(prev, newState, (2 * (pos - 1) + loaded, "L"));
 
              let
                val q1 = Array.sub(qArr, 0)
                val newQ =  enqueue (loaded) (pos - 1) (cost + 1 + loaded) q1
              in    
                Array.update(qArr, 0, newQ)
              end
              )
            else ()
          end
          )
         else ();
        if (pos mod m <> 0) then (* RIGHT *) (
          
          let
            val newChar = Array.sub(arr, pos)
            val newState = 2 * (pos) + loaded
            val (a, _) = Array.sub(prev, newState) 
          in
            if (newChar <> #"X" andalso a = ~1 andalso (newChar <> #"S" orelse loaded = 0)) then (
              Array.update(prev, newState, (2 * (pos - 1) + loaded, "R"));
 
              let
                val q1 = Array.sub(qArr, 0)
                val newQ = enqueue (loaded) (pos + 1) (cost + 1 + loaded) q1
              in
                Array.update(qArr, 0, newQ)
              end
              )
            else ()
          end
          )
        else ();
        if (pos <= (n - 1) * m) then (* DOWN *) (
          
          let
            val newChar = Array.sub(arr, pos + m - 1)
            val newState =  2 * (pos + m - 1) + loaded
            val (a, _) = Array.sub(prev, newState) 
          in
            if (newChar <> #"X" andalso a = ~1 andalso (newChar <> #"S" orelse loaded = 0)) then (
              Array.update(prev, newState, (2 * (pos - 1) + loaded, "D"));
 
              let
                val q1 = Array.sub(qArr, 0)
                val newQ = enqueue (loaded) (pos + m) (cost + 1 + loaded) q1
              in
                Array.update(qArr, 0, newQ)
              end
              )
            else ()
          end
          )
        else ();
        if (mychar = #"W") then (
          let
            val newFlag = 1 - loaded
            val newState = 2 * (pos - 1) + newFlag
            val (a, _) = Array.sub(prev, newState) 
          in
            
            if (a = ~1) then (
              Array.update(prev, newState, (2 * (pos - 1) + loaded, "W"));
 
              let 
                val q1 = Array.sub(qArr, 0)
                val newQ = enqueue (newFlag) (pos) (cost + 1) q1
              in
                Array.update(qArr, 0, newQ)
              end
              )
            else ()
          end
          )
        else ();
       
        let
          val a = Array.sub(qArr, 0)
        in
          probSolver (a, arr, prev, m, n, qArr)
        end
        )
    end



       
  

fun my_solution (myMap, m, s, n) = 
   let
     val arr = Array.fromList myMap
     val len = Array.length arr
     val prev = Array.array(2 * len, (~1, "Z"))
     val q = Q []
     val q1 = enqueue 1 s 0 q
     val qArr = Array.array(1, q1)
   in
     probSolver(q1, arr, prev, m, n, qArr)
   end
     

fun spacedeli fileName = my_solution (parse fileName)
