let (typefun,dim,typecross,typemut,typeconst)=Gvars.read_param ()
   
type data = {x : float array}

let pi=acos (-1.)
          
let  (highbound,lowbound)= 
  match typefun with
    0 -> (10.,-10.)
  | 1 -> (100., -100.)
  | _ -> (pi,0.)
          
let delta= highbound-.lowbound

let td_fun x =
  let prod=ref 1. in
  for k=0 to dim-1 do
    let sumk= ref 0. in
    for i=1 to 5 do
      let fi=float i in
      sumk:= !sumk+. fi*.(cos ((fi+.1.)*.x.(k)+.fi))
    done;
    prod:= !prod*. !sumk
  done;
  !prod       

    
let griewank x =
  let prod=ref 1.
  and sum=ref 0. in
  for k=0 to dim-1 do
    let fk=float (k+1) in
    prod:= !prod*.(cos (x.(k)/.(sqrt fk)));
    sum:= !sum+. x.(k)*.x.(k);
  done;
  !prod -. !sum/.4000.         

let pi = acos (-1.)
let micha x =
  let s1 = ref 0.0 in
  for i= 0 to dim-1 do
    s1:= !s1+. (sin x.(i)) *. (sin (x.(i)*.x.(i)*.(float (i+1))/.pi))**(2.0*.(10.));
  done;
  ((float dim)+. !s1);;


  
let evalData data= 
  match typefun with
    0 -> td_fun data.x
  | 1 -> griewank data.x
  | _ -> micha data.x
       
let genData() = 
  {x=Array.init dim (fun _ -> delta*. (Random.float 1.0) +. lowbound)}
    
let scale_middle data =
  {x= Array.map (fun v ->
          if v>highbound then v-.delta
          else if v<lowbound then v+.delta 
          else v) data.x}

let scale_edge data =
  {x= Array.map (fun v ->
          if v>highbound then highbound
          else if v<lowbound then lowbound 
          else v) data.x}  

let scale= if typeconst=0 then scale_edge else scale_middle
    
let cross_arithmetic a b =
  let newax=Array.mapi (fun i v -> 
                let c=Random.float 2.-.0.5 in
                c*.v+.(1.-.c)*.b.x.(i)) a.x 
  and newbx=Array.mapi (fun i v -> 
                let c=Random.float 2.-.0.5 in
                c*.v+.(1.-.c)*.a.x.(i)) b.x in
  ((scale {x=newax}),(scale {x=newbx}))

let cross_classic a b =
  let newax=Array.copy a.x
  and newbx=Array.copy b.x in
  for i=0 to dim-1 do
    if Random.int 2=0 then
      (newax.(i)<-b.x.(i);newbx.(i)<-a.x.(i))
  done;
  ((scale {x=newax}),(scale {x=newbx}))

let cross=if typecross=0 then cross_classic else cross_arithmetic
  
let mutate a =
  let newx=Array.mapi (fun i v -> 
               let noise= Random.float (2.*.typemut)-.typemut  in
               v+.noise) a.x in
  (scale {x=newx})
    
let print_data data = 
  Array.iteri (fun i v -> Printf.printf "x.(%d)=%f " i v) data.x
                        
let dataDistance d1 d2 =
  let sum=ref 0. in
  for i=0 to dim-1 do
    sum:= !sum+. (d1.x.(i)-.d2.x.(i))*.(d1.x.(i)-.d2.x.(i))
  done;
  sqrt !sum
    
let dataBarycenter d1 n1 d2 n2 = 
  let f1=float n1 and f2=float n2 in
  {x=Array.init dim (fun i -> (f1*. d1.x.(i) +. f2*. d2.x.(i))/.(f1+. f2))}
    
let calcNext data i alpha =
  data
    
let calcNew data source factor =
  source
    
let dim= 1;;
let endlocal data = ();;
let endlocalerror data = ();;
    

