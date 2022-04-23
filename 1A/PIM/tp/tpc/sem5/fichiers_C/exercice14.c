#include <stdlib.h> 
#include <stdio.h>
#include <assert.h>
#include <math.h>

// Definition du type Point 
struct Point {
    int X;
    int Y;
};

int main(){
    // Déclarer deux variables ptA et ptB de types Point
    struct Point ptA = {0,0};
    struct Point ptB = {10,10};
    // Initialiser ptA à (0,0)
    
    // Initialiser ptB à (10,10)
    
    // Calculer la distance entre ptA et ptB.
    float distance = 0;
    distance = sqrt((ptA.X-ptB.X)*(ptA.X-ptB.X) + (ptA.Y-ptB.Y)*(ptA.Y-ptB.Y));
    assert( (int)(distance*distance) == 200);
    printf("%d \n", (int)(distance*distance));    
    return EXIT_SUCCESS;
}
