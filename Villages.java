/* I found the code for class DisjointSet in the webpage
https://github.com/mission-peace/interview/blob/master/src/com/interview/graph/DisjointSet.java
*/

import java.io.*;

public class Villages {
  public static void main(String[] args) {
    try {
      DisjointSet vs = new DisjointSet();
      int i, succ_unions = 0;
      BufferedReader reader = new BufferedReader(new FileReader(args[0]));
      String line = reader.readLine();
      String[] x = line.split(" ");
      int N = Integer.parseInt(x[0]);
      int M = Integer.parseInt(x[1]);
      int K = Integer.parseInt(x[2]);
      for (i=1; i<=N; i++) {
        vs.makeSet(i);
      }
      for (i=0; i < M; i++) {
        line = reader.readLine();
        x = line.split(" ");
        if(vs.union(Integer.parseInt(x[0]), Integer.parseInt(x[1]))){
          succ_unions++;
        }
      }
      System.out.println(succ_unions);
      reader.close();
      for (i=1; i<=N; i++) {
          if (vs.union(i,i+1)) {
            K--;
            succ_unions++;
          }
          if (K==0 || (N-succ_unions) == 1) break;
      }
      System.out.print(N-succ_unions);
    }
    catch(IOException e) {
      e.printStackTrace();
    }
  }
}

