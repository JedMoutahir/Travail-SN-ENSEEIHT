open Gvars
open Types
open Initpop
open Crossmut
open Reproduce
open Scale
open Share
open Local
open Simplex

let computeRMeanSigmaBestMaxfMinf pop = 
 let sum= ref 0.0 and sum2= ref 0.0 and maxf= ref (-1.0/.0.0) 
  and minf=ref (1.0/.0.0) and best = ref 0 in 
  for i = 0 to (Array.length pop)-1 do 
    sum := !sum+. pop.(i).r_fit ;
    sum2 := !sum2 +. pop.(i).r_fit *. pop.(i).r_fit;
    if (pop.(i).r_fit> !maxf) then (maxf:=pop.(i).r_fit;best:=i);
    if (pop.(i).r_fit< !minf) then minf:=pop.(i).r_fit
  done; 
  sum:= !sum /. (float (Array.length pop));
  sum2:= !sum2 /. (float (Array.length pop)) -. (!sum *. !sum);
  sum2:= sqrt !sum2;
  (!sum,!sum2,pop.(!best),!maxf,!minf);;

let stat pop = 
 let (moy,sigma,best_elem,val_best,_)=(computeRMeanSigmaBestMaxfMinf pop) in
 Printf.fprintf !fileout "generation : %d\n" !numgen;
 Printf.fprintf !fileout "best_elem=";
 print_data best_elem.data;
 Printf.fprintf !fileout "r_fit = %f\n"  best_elem.r_fit;
 Printf.fprintf !fileout "moy=%f sigma=%f\n\n"  moy sigma;flush !fileout;;
   

let one_step pop1 scaling sharing complex_sharing elitist evolutive pcross pmut = 
  (scale pop1 scaling);
  let prot=(share elitist sharing complex_sharing pop1) in
  let (newprot,pop2)=(reproduce pop1 prot) in
  (crossmut pop2 pop1 newprot evolutive pcross pmut);
  (stat pop1);
  flush stdout;;


let algogen () = 
  Printf.fprintf !fileout "Starting AG\n";
  flush !fileout;
  let (pcross,pmut,scaling,elitist,sharing,complex_sharing,evolutive,
       simp_alpha,simp_precision,simp_iterations)=Gvars.read_config () in
  let pop1=Array.of_list (initPop !nbelems) in
  
  while (!numgen<nbgens) do 
    incr numgen;
    (one_step pop1 scaling sharing complex_sharing elitist evolutive
       pcross pmut)
  done;
  (scale pop1 scaling);
  let best_elems=(List.sort (fun i j -> if pop1.(i).r_fit>pop1.(j).r_fit then -1 else 1) 
		    (share elitist sharing 
		       complex_sharing pop1)) in
  let indbest = (List.hd best_elems) in
  Printf.fprintf !fileout "\nResultats:\n";
  Printf.fprintf !fileout "best_elem=";
  print_data pop1.(indbest).data;
  Printf.fprintf !fileout "r_fit = %f\n" pop1.(indbest).r_fit;
  flush !fileout;

  print_string "Meilleurs elements :\n";
  (List.iter  
     (function i -> print_string "element= "; 
       print_data pop1.(i).data;
       Printf.printf "r_fit=%f\n" pop1.(i).r_fit) 
     best_elems);
  if simp_iterations <> 0 then (
    Printf.fprintf !fileout "Apres simplex:\n";
    let simp= 
      simplex pop1.(indbest).data simp_iterations simp_alpha simp_precision in
    Printf.fprintf !fileout "best_elem= ";print_data simp;    
    Printf.fprintf !fileout "r_fit = %f\n" (evalData simp);flush !fileout;
    Local.endlocal simp;
    print_string "Meilleurs elements:\n";
    let ls = (List.map 
		(function i-> (simplex pop1.(i).data simp_iterations 
				 simp_alpha simp_precision))
		best_elems) in
    (List.iter  
       (function x -> print_string "element= "; print_data x;
	 Printf.printf "r_fit=%f\n" (evalData x)) 
       ls)
      )
  else 
    Local.endlocal pop1.(indbest).data;
  print_data pop1.(indbest).data;;
    
    
    
    
    
let _= try (Printexc.catch algogen ();flush !fileout;exit 0)
  with _ ->
      	 Printf.fprintf !fileout "\n";
         flush !fileout;
      	 Local.endlocalerror ()

