import java.util.*;

public class BFSolver implements Solver{

    @Override
    public State solve(State initial){
        Set<State> seen = new HashSet<>();
        PriorityQueue<State> remaining = new PriorityQueue<>();

        seen.add(initial);
        remaining.add(initial);
        boolean flag = false;

        while (!remaining.isEmpty()){

            State s = remaining.remove();
            if (s.isFinal()) return s;

            for (State i : s.next()){
                if (!seen.contains(i)){
                    for (State j : seen){
                        if (j.get_coordinates().isEqual(i.get_coordinates()) && (j.get_cost() < i.get_cost())){
                            flag = true;
                            break;
                        }
                    }
                    if (flag) {
                        flag = false;
                        continue;
                    }
                    seen.add(i);
                    remaining.add(i);
                }
            }
        }

        return null; //Hopefully not
    }
}
