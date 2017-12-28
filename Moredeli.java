import java.util.*;
import java.io.*;

//The code follows the structure of this lab example: http://courses.softlab.ntua.gr/pl1/2017a/Labs/anagrams.tgz
public class Moredeli{

    public static void main(String args[]) throws IOException{
        try {
            Solver solver = new DijkstraSolver();
            Map map = new Map(args[0]);
            Vector<Vector<Character>> spaceMap = map.readMap(); //Read the map of the problem
            State initial = new LakiState(0, map.get_i(), map.get_j(), ' ', null, spaceMap);
            State result = solver.solve(initial, map.get_row(), map.get_col());
            if (result == null) System.out.println("Not a lucky day for Laki");
            else{ //print solution
                System.out.print(result.get_cost());
                System.out.print(" ");
                printSteps(result);
            }
        }
        catch(IOException e) {
            e.printStackTrace();
        }

    }

    private static void printSteps(State state){
        if (state.getPrevious() != null){
            printSteps(state.getPrevious());
            System.out.print(state);
        }
    }
}
