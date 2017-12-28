#include <iostream>
#include <fstream>
#include <queue>
#include <vector>
#include <stack>
using namespace std;

struct node_for_Q{
            int position;
            int cost;
            int loaded;
            bool operator< ( const node_for_Q& other) const
                {
                	if (cost > other.cost) return true;
			 		else if (cost==other.cost) {
                        if(loaded == 1 && other.loaded == 0) return true;
                    }
					return false;
                }
            node_for_Q(int pos, int co,int l) {position = pos, cost = co, loaded = l;}
            node_for_Q(){}
};

 typedef struct{
            int previPos;
            int prevjPos;
            char prevMove;
} tTuple;


int main(int argc, char** argv){
    {

        //if (argc < 2) return 1;
        ifstream myfile;
        myfile.open("map20.in", ios::in);
        int i, n = 0, col = 0, m = 0, N, start = 0;
        bool first = true;
        vector<char> myMap;
        char c;
        myfile.get(c);
        myMap.push_back(c);
        m++;
        while(!myfile.eof()){
            myfile.get(c);
            col++;
            if (c == '\n')
            {
                if (first)
                {
                    m = col;
                    first = false;
                }
                myfile.get(c);
                if (myfile.eof()) break;
                n++;
            }
            myMap.push_back(c);
        }
        cout << m;
		N = n * m;
		priority_queue<node_for_Q> Q;
        stack<tTuple> solution;

        for (i = 0; i < N; i++){
        	if (myMap[i] == 'S'){
        	 start = i;
        	}
        	cout << myMap[i];
        	 cout << '\n';
        }

        node_for_Q init (start, 0, 1);
        Q.push(init);
        vector<vector<tTuple> > prev;
        vector<tTuple> newRow;

        int j;
        tTuple temp;
        temp.previPos = -1;
        temp.prevjPos = -1;
        temp.prevMove = 'Z';
        for (i = 0; i < N ; i++){ //prev_array initialization
            prev.push_back(newRow);
            for (j = 0; j < 2; j++){
                prev.at(i).push_back(temp);
            }
        }

        char newMove;
        int newFlag;
        node_for_Q currentSt;
        tTuple temp2;
        while(!Q.empty()){
            currentSt = Q.top();
            cout << currentSt.position;
            cout << '\n';
            Q.pop();
            if (myMap[currentSt.position] == 'E' && currentSt.loaded == 1){
                cout << currentSt.cost;
                cout << " ";
                temp = prev[currentSt.position][1];
                while (temp.prevMove != 'Z'){
                    solution.push(temp);
                    temp = prev[temp.previPos][temp.prevjPos];
                }
                while(!solution.empty()){
                    temp2 = solution.top();
                    cout << temp2.prevMove;
                    solution.pop();
                }
                cout<<endl;
            }
            else {
                if (currentSt.position + 1 > m){
                    newMove = myMap[currentSt.position - m];
                    temp = prev[currentSt.position - m][currentSt.loaded];
                    if (newMove != 'X' && temp.previPos == -1 && (newMove != 'S' || currentSt.loaded == 0)){
                        temp.previPos = currentSt.position;
                        temp.prevjPos = currentSt.loaded;
                        temp.prevMove = 'U';
                        prev[currentSt.position-m][currentSt.loaded]=temp;
                        node_for_Q incSt (currentSt.position - m, currentSt.cost + 1 + currentSt.loaded, currentSt.loaded);
                        Q.push(incSt);
                    }
                }
                if ((currentSt.position + 1) % m != 1){
                    newMove = myMap[currentSt.position - 1];
                    temp = prev[currentSt.position - 1][currentSt.loaded];
                    if (newMove != 'X' && temp.previPos == -1 && (newMove != 'S' || currentSt.loaded == 0)) {
                        temp.previPos = currentSt.position;
                        temp.prevjPos = currentSt.loaded;
                        temp.prevMove = 'L';
                        prev[currentSt.position-1][currentSt.loaded]=temp;
                        node_for_Q incSt (currentSt.position - 1, currentSt.cost + 1 + currentSt.loaded, currentSt.loaded);
                        Q.push(incSt);
                    }
                }
                if ((currentSt.position + 1) % m != 0){
                    newMove = myMap[currentSt.position + 1];
                    temp = prev[currentSt.position + 1][currentSt.loaded];
                    if (newMove != 'X' && temp.previPos == -1 && (newMove != 'S' || currentSt.loaded == 0)){
                        temp.previPos = currentSt.position;
                        temp.prevjPos = currentSt.loaded;
                        temp.prevMove = 'R';
                        prev[currentSt.position+1][currentSt.loaded]=temp;
                        node_for_Q incSt (currentSt.position + 1, currentSt.cost + currentSt.loaded + 1, currentSt.loaded);
                        Q.push (incSt);
                    }
                }
                if (currentSt.position + 1 <= (n-1)*m){
                    newMove = myMap[currentSt.position + m];
                    temp = prev[currentSt.position + m ][currentSt.loaded];
                    if (newMove != 'X' && temp.previPos == -1 && (newMove != 'S' || currentSt.loaded == 0)){
                        temp.previPos = currentSt.position;
                        temp.prevjPos = currentSt.loaded;
                        temp.prevMove = 'D';
                        prev[currentSt.position+m][currentSt.loaded]=temp;
                        node_for_Q incSt (currentSt.position + m, currentSt.cost + 1 + currentSt.loaded, currentSt.loaded);
                        Q.push (incSt);
                    }
                }
                if (myMap[currentSt.position] == 'W'){
                    newFlag = 1 - currentSt.loaded;
                    temp = prev[currentSt.position][newFlag];
                    if (temp.previPos == -1){
                        temp.previPos = currentSt.position;
                        temp.prevjPos = currentSt.loaded;
                        temp.prevMove = 'W';
                        prev[currentSt.position][newFlag]=temp;
                        node_for_Q incSt (currentSt.position, currentSt.cost + 1, newFlag);
                        Q.push (incSt);
                    }
                }
            }
        }


     }
}
