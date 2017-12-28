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
                	if (cost > other.cost) {return true;}
			 		else if (cost == other.cost){return (loaded == 1 && !(other.loaded == 0));}
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
		myfile.open("map500.in", ios::in);
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
		n++;
		N = n * m;
		priority_queue<node_for_Q> Q;


        for (i = 0; i < N; i++)
        {
        	if (myMap[i] == 'S'){
        	 start = i;
        	 break;
        	}
        	//cout << myMap[i];
        }

        node_for_Q init (start, 0, 1);
        Q.push(init);
        tTuple prev[N][2]; //an array of tuples
        int j;
        tTuple temp;
        for (i = 0; i < N; i++){ //prev array initilization
            for (j = 0; j < 2; j++){
                prev[i][j].previPos = -1;
                prev[i][j].prevjPos = -1;
                prev[i][j].prevMove = 'Z';
            }
        }

        char newMove;
        //int newState;
        int newFlag;
        node_for_Q currentSt;
        //node_for_Q incSt;
        stack<char> outSeq;
        while(!Q.empty()){
            currentSt = Q.top();
            Q.pop();


            if (myMap[currentSt.position] == 'E' && currentSt.loaded == 1){
                cout << currentSt.cost;
                cout << " ";
                temp = prev[currentSt.position][1];
                while (temp.prevMove != 'Z'){
                    outSeq.push(temp.prevMove);
                    temp = prev[temp.previPos][temp.prevjPos];
                }
                while (! outSeq.empty()){
                    cout << outSeq.top();
                    outSeq.pop();
                }
            }
            else {
                if (currentSt.position + 1 > m){
                    newMove = myMap[currentSt.position - m];
                    temp = prev[currentSt.position - m][currentSt.loaded];
                    if (newMove != 'X' && temp.previPos == -1 && (newMove != 'S' || currentSt.loaded == 0)){
                        temp.previPos = currentSt.position;
                        temp.prevjPos = currentSt.loaded;
                        temp.prevMove = 'U';
                        prev[currentSt.position - m][currentSt.loaded] = temp;
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
                        prev[currentSt.position - 1][currentSt.loaded] = temp;
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
                        prev[currentSt.position + 1][currentSt.loaded] = temp;
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
                        prev[currentSt.position + m][currentSt.loaded] = temp;
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
                        prev[currentSt.position][newFlag] = temp;
                        node_for_Q incSt (currentSt.position, currentSt.cost + 1, newFlag);
                        Q.push (incSt);
                    }
                }
            }
        }

//        for (i = 0; i < N; i++){
//            for (j = 0; j < 2; j++){
//                cout << "iPos is: ";
//                cout << prev[i][j].previPos;
//                cout << '\n';
//                cout << "jPos is: ";
//                cout << prev[i][j].prevjPos;
//                cout << '\n';
//                cout << "move is: ";
//                cout << prev[i][j].prevMove;
//                cout << '\n';
//            }
//        }
     }
}
