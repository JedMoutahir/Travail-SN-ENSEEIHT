val fileout : out_channel ref
val numgen : int ref
val nbgens : int
val nbelems : int ref

val read_config :
  unit ->
  float * float * int * bool * float * float * bool * float * float * int   

val read_param :
  unit ->
  int * int * int * float * int
