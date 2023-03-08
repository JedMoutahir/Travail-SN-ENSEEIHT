#include "aux.h"
#include "omp.h"

int main(int argc, char **argv){
  long    t_start;
  double  time;
  int     i, j, n, head;
  Stack   stacks[ntypes];
  Request req;
  int     head;
    
  init(stacks);

  t_start=usecs();
#pragma omp parallel
  {
    
#pragma omp master
    {
      for(;;){
        
        req = receive();
        
        /* printf("Received request %d\n",req.id); */
        if(req.type != -1) {
          
#pragma omp task firstprivate(req) private(head)
          {
            /* process request and push result on stack */
            /* printf("Processing request %d\n",req.id); */
#pragma omp critical
            head = ++stacks[req.type].head;

            
            stacks[req.type].results[head] = process(&req);
          }
          
        } else {
          break;
        }
        
      }
    }
  }
  
  time=(double)(usecs()-t_start)/1000000.0;
  printf("Finished. Execution time:%.2f \n",time);

  check(stacks);
  
  return 0;
}
