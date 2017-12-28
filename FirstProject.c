#include<stdio.h>
#include<stdlib.h>

int main(int argc, char* argv[])
{
    //if (argc < 2) return 1;
    FILE *ptr_file;

    ptr_file = fopen("h1000000.in", "r");
    if (!ptr_file) return 1;

    int N;
    fscanf(ptr_file, "%d", &N);

    int *Y = (int*) malloc(N * sizeof(int));
    int i = 0;

    while (!feof(ptr_file)){
        fscanf(ptr_file, "%d", &Y[i]);
        i++;
    }

    int *L = (int*) malloc(1 * sizeof(int));
    int *R = (int*) malloc(1 * sizeof(int));
    L[0] = 0;
    R[0] = N - 1;
    int Lsize = 1, Rsize = 1;

    for (i = 1; i < N; i++){
        if (Y[i] < Y[L[Lsize - 1]]){
            Lsize += 1;
            L = realloc(L, (Lsize) * sizeof(int));
            L[Lsize - 1] = i;
        }

        if (Y[N - 1 - i] > Y[R[Rsize - 1]]){
            Rsize += 1;
            R = realloc(R, (Rsize) * sizeof(int));
            R[Rsize - 1] = N - 1 - i;
        }
    }

    int j, dist, max = 0;
    int flag = 0;
    for (i = 0; i < Lsize; i++){
        for (j = Rsize - 1; j > -1; j--){
            if (Y[L[i]] > Y[R[j]]) break;
            flag = 1;
        }
        if (flag == 1){
            dist = R[j + 1] - L[i];
            if (dist > max) max = dist;
            flag = 0;
        }
    }

    printf("%d", max);

    fclose(ptr_file);
    free(Y);
    free(R);
    free(L);
    return 0;

    //naive solution

//    FILE *ptr_file;
//
//    ptr_file = fopen("testcase.txt","r");
//    if (!ptr_file)
//        return 1;
//    int N;
//    fscanf(ptr_file, "%d", &N);
//    int A[N-1];
//    int i = 0;
//
//    while (!feof(ptr_file)){
//        fscanf(ptr_file, "%d", &A[i]);
//        i++;
//    }
//    int j;
//    int dist;
//    int max[N-1];
//    int maxofthemax = 0;
//    for (i = 0; i < N; i++){
//        max[i] = 0;
//        for (j = i + 1; j < N; j++){
//            if (A[j] > A[i]){
//                dist = j - i;
//                if (dist > max[i]) max[i] = dist;
//            }
//        }
//        if (max[i] > maxofthemax) maxofthemax = max[i];
//    }
//    printf("%d", maxofthemax);
//
//    fclose(ptr_file);
//    return 0;

}
