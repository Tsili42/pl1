import java.util.*;
import java.io.*;

public class Map{

    private String path;
    private int row;
    private int col;
    private int iStart;
    private int jStart;

    public Map(String fileName){
        path = fileName;
    }

    public int get_row(){
        return this.row;
    }

    public int get_col(){
        return this.col;
    }

    public int get_i(){
        return this.iStart;
    }

    public int get_j(){
        return this.jStart;
    }

    public Vector<Vector<Character>> readMap() throws IOException{
        File inFile = new File(this.path);
        FileReader input = new FileReader(inFile);
        Vector<Vector<Character>> spaceMap = new Vector<Vector<Character>>();
        Vector<Character> rowVector = new Vector<Character>();

        int r;
        int rows = 0;
        int cols = 0;
        while((r = input.read()) != -1){
            char c = (char) r;
            if (c != '\n'){
                if (cols == 0){
                    rowVector = new Vector<Character>();
                    spaceMap.add(rows++, rowVector);
                }
                rowVector.add(cols++, c);
                if (c == 'S'){
                    this.iStart = rows - 1;
                    this.jStart = cols - 1;
                }
            }
            else {
                this.col = cols;
                cols = 0;
            }

        }
        this.row = rows;

        return spaceMap;
    }
}
