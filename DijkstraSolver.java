import java.util.*;

public class DijkstraSolver implements Solver{

    @Override
    public State solve (State initial, int n, int m){
        PriorityQueue<State> remaining = new PriorityQueue<>();
        Vector<Vector<Integer>> dist = new Vector<Vector<Integer>>();
        int i, j;
        for (i = 0; i < n; i++){
            Vector<Integer> rowV = new Vector<Integer>(m);
            dist.add(rowV);
            for (j = 0; j < m; j++){
                rowV.add(1000000); //initialize distance array (We assume that 10e06 is big enough for our test cases)
            }
        }

        int alt;
        remaining.add(initial);
        while (!remaining.isEmpty()){

            State u = remaining.remove();
            if (u.isFinal()) return u;

            for (State v : u.next()){
                alt = v.get_cost(); //alt <- cost(v) + weight of edge(u,v)
                if (alt < dist.elementAt(v.get_i()).elementAt(v.get_j())){
                    //Update distance(u,v) &
                    Vector<Integer> inner = new Vector<Integer>();
                    inner = dist.elementAt(v.get_i());
                    inner.set(v.get_j(), alt);
                    dist.set(v.get_i(), inner);

                    //add vertex v to queue
                    remaining.add(v);
                }
            }
        }

        return null;
    }
}
