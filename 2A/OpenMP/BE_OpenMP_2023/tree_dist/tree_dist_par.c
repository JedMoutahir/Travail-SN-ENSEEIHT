#include "aux.h"

//parallel version of tree_dist_seq using tasks
void tree_dist_par(node_t *nodes, int n){
  
  int node;
  
  #pragma omp parallel
  {
    #pragma omp single
    {
      for(node=0; node<n; node++){
        #pragma omp task firstprivate(node) shared(nodes)  depend(out:nodes[node].dist) depend(in:nodes[node].p) depend(inout:nodes[node].weight)
        {
          nodes[node].weight = process(nodes[node]);
          nodes[node].dist    = nodes[node].weight;
          if(nodes[node].p) nodes[node].dist += (nodes[node].p)->dist;
        }
      }
    }
  }
    
}