#include <stdio.h>
#include "mpi.h"

int main ( int argc, char **argv )
{
        int  node, size;
        int  num = 10;
        char name[255];
        MPI_Status status;

        MPI_Init(&argc,&argv);
        MPI_Comm_size(MPI_COMM_WORLD, &size);
        MPI_Comm_rank(MPI_COMM_WORLD, &node);

        if (node == 0)
             MPI_Send(&num, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
        else MPI_Recv(&num, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &status);

        MPI_Finalize();

        return 0 ;
}

