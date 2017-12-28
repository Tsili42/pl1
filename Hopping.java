import java.util.*;
import java.io.*;

public class Hopping{

    static int count(int N,int K, int[] Steps){
        int res[] = new int[N];
        res[0] = 0;
        res[1] = 1;
        for (int i = 2; i < N; i++){
            System.out.print(i);
            res[i] = 0;
            for (int j = 0; j < K; j++){
                if ((i - Steps[j]) > -1){
                    res[i] += res[i - Steps[j]];
                    res[i] = res[i]%1000000009;
                    System.out.print(res[i]);
                }
            }
            //res[i] = res[i]%1000000009;
        }
        return res[N-1];
    }

    static int jacobsladder (int N, int K, int[] Steps){
        return count(N+1, K, Steps);
    }

    static int countbroken(int N, int K, int[] Steps, int Br, Vector Broken){
        int res[] = new int[N];
        res[0] = 0;
        res[1] = 1;
        for(int i = 2; i < N; i++){
            res[i] = 0;
            for (int j = 0; j < K; j++){
                if ((i - Steps[j]) > -1){
                    if(!(Broken.contains(i - Steps[j]))){
                        res[i] += res[i - Steps[j]];
                        res[i] = res[i]%1000000009;
                    }
                }
            }
            //res[i] = res[i]%1000000009;
        }
        return res[N-1];
    }

/*
    static int countbroken(int N, int K, int[] Steps, int Br, Vector Broken){
        if (N <= 1)
            return N;
        int res = 0;
        for (int i = 0; i < K; i++){
            if (!(Broken.contains(N - Steps[i])))
                res += countbroken(N - Steps[i],K,Steps,Br,Broken);
        }
        return res;
    }
    */

    static int brokenladder(int N, int K, int[] Steps, int Br, Vector Broken){
        return countbroken(N+1, K, Steps, Br, Broken);
    }

    public static void main(String[] args){
        File file = new File (args[0]);
        System.out.println("Lol");
        try (BufferedReader in = new BufferedReader(new FileReader(file)))
        {
            String line;
            line = in.readLine();
            String[] li = line.split(" ");
            int N = Integer.parseInt(li[0]);
            int K = Integer.parseInt(li[1]);
            int Br = Integer.parseInt(li[2]);
            int[] Steps = new int[K];
            Vector Broken = new Vector(Br);
            line = in.readLine();
            String[] st = line.split(" ");
            for (int i =0; i < K; i++){
                Steps[i] = Integer.parseInt(st[i]);
            }
            int result;
            if (Br > 0){
                line = in.readLine();
                String[] b = line.split(" ");
                for (int i = 0; i < Br; i++){
                    Broken.addElement(Integer.parseInt(b[i]));
                }
                result = brokenladder(N,K,Steps,Br,Broken);
            }
            else {
                result = jacobsladder(N,K,Steps);
            }
            //result = result%1000000009;
            System.out.println(result);
        }
        catch (IOException e){
            System.out.println ("No input!");
        }
    }
}
