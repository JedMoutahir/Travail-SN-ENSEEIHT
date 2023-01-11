(* Module de la passe de gestion des identifiants *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast
open Printf

type t1 = Ast.AstSyntax.programme
type t2 = Ast.AstTds.programme

(* analyse_tds_affectable : tds -> AstSyntax.affectable -> bool -> AstTds.affectable *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre a : l'affectable à analyser *)
(* Paramètre ecriture : true si l'affectable est utilisé en écriture, false sinon *)
(* Vérifie la bonne utilisation des affectable et transforme l'affectable
en un affectable de type AstTds.affectable *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_affectable tds a ecriture =
  match a with
  | AstSyntax.Ident nom -> 
    begin
      match (chercherGlobalement tds nom) with
      | None -> raise (IdentifiantNonDeclare nom)
      | Some ia ->
        let info = info_ast_to_info ia in
        begin
          match info with
          | InfoVar _ -> AstTds.Ident(ia)
          | InfoConst(nom, _) ->
            if ecriture then raise (MauvaiseUtilisationIdentifiant nom)
            else AstTds.Const(ia)
          | _ -> raise (MauvaiseUtilisationIdentifiant nom)
        end
    end
  | AstSyntax.DeRef da ->
    let nda = analyse_tds_affectable tds da ecriture in
    AstTds.DeRef(nda)

(* analyse_tds_expression : tds -> AstSyntax.expression -> AstTds.expression *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des identifiants et transforme l'expression
en une expression de type AstTds.expression *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_expression tds e = (match e with 

(* Pointeurs *)
| AstSyntax.Affectable(a) ->
  let na = analyse_tds_affectable tds a false in
  AstTds.Affectable(na)

|Ast.AstSyntax.Booleen b -> Ast.AstTds.Booleen b
|Ast.AstSyntax.Entier n -> Ast.AstTds.Entier n
|Ast.AstSyntax.Binaire (op,e1,e2) -> 
  let ne1 = analyse_tds_expression tds e1 in
  let ne2 = analyse_tds_expression tds e2 in
  Ast.AstTds.Binaire (op,ne1,ne2)
|Ast.AstSyntax.Unaire (op,e1) -> 
  let ne1 = analyse_tds_expression tds e1 in
  Ast.AstTds.Unaire (op,ne1)
|Ast.AstSyntax.AppelFonction (id,es) ->
begin
(match chercherGlobalement tds id with
      | None -> raise (IdentifiantNonDeclare id)
      | Some info_ast -> (match info_ast_to_info info_ast with
          | InfoFun (_,_,_) -> Ast.AstTds.AppelFonction(info_ast,(List.map (fun e -> analyse_tds_expression tds e) es))
          | _ -> raise (MauvaiseUtilisationIdentifiant id)))
end

(* Conditionelle Ternaire *)
| AstSyntax.Ternaire (c, e1, e2) ->
  let nc = analyse_tds_expression tds c in
  let ne1 = analyse_tds_expression tds e1 in
  let ne2 = analyse_tds_expression tds e2 in
  AstTds.Ternaire(nc, ne1, ne2)

(* Pointeurs *)
| AstSyntax.New t -> AstTds.New(t)
| AstSyntax.Adresse nom ->
  begin
    match (chercherGlobalement tds nom) with
    |None -> raise (IdentifiantNonDeclare nom)
    | Some ia ->
      begin
        match info_ast_to_info ia with
        | InfoVar _ -> AstTds.Adresse(ia)
        | _ -> raise (MauvaiseUtilisationAccesAdresse nom)
      end
  end
| AstSyntax.Null -> AstTds.Null)



(* analyse_tds_instruction : tds -> info_ast option -> AstSyntax.instruction -> AstTds.instruction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre oia : None si l'instruction i est dans le bloc principal,
                   Some ia où ia est l'information associée à la fonction dans laquelle est l'instruction i sinon *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'instruction
en une instruction de type AstTds.instruction *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_instruction tds oia lloop i =
  match i with
  | AstSyntax.Declaration (t, n, e) ->
      begin
        match chercherLocalement tds n with
        | None ->
            let ne = analyse_tds_expression tds e in
            let info = InfoVar (n,Undefined, 0, "") in
            let ia = info_to_info_ast info in
            ajouter tds n ia;
            AstTds.Declaration (t, ia, ne)
        | Some _ ->
            raise (DoubleDeclaration n)
      end
  | AstSyntax.Affectation (n,e) ->
    let na = analyse_tds_affectable tds n true in
    let ne = analyse_tds_expression tds e in
    AstTds.Affectation (na, ne)
  | AstSyntax.Constante (n,v) ->
      begin
        match chercherLocalement tds n with
        | None ->
          ajouter tds n (info_to_info_ast (InfoConst (n,v)));
          AstTds.Empty
        | Some _ ->
          raise (DoubleDeclaration n)
      end
  | AstSyntax.Affichage e ->
      let ne = analyse_tds_expression tds e in
      AstTds.Affichage (ne)
  | AstSyntax.Conditionnelle (c,t,e) ->
      let nc = analyse_tds_expression tds c in
      let tast = analyse_tds_bloc tds oia lloop t in
      let east = analyse_tds_bloc tds oia lloop e in
      AstTds.Conditionnelle (nc, tast, east)
  | AstSyntax.TantQue (c,b) ->
      let nc = analyse_tds_expression tds c in
      let bast = analyse_tds_bloc tds oia lloop b in
      AstTds.TantQue (nc, bast)
  | AstSyntax.Retour (e) ->
      begin
      match oia with
      | None -> raise RetourDansMain
      | Some ia ->
        let ne = analyse_tds_expression tds e in
        AstTds.Retour (ne,ia)
      end
  | AstSyntax.Loop (nom, b) ->
    if (nom <> "_" && List.exists (fun x -> x = nom) lloop) then eprintf " Attention, il y a des loop à la rust imbriquées (nommées %s)" nom;
    let nb = analyse_tds_bloc tds oia (nom::lloop) b in
    AstTds.Loop(nom, nb)
  | AstSyntax.Continue(n) ->
    if (lloop = []) then raise (MauvaiseUtilisationContinue n)
    else if (n = "" || List.exists (fun x -> x = n) lloop) then AstTds.Continue(n)
    else raise (IdentifiantNonDeclare n)
  | AstSyntax.Break(n) ->
    if (lloop = []) then raise (MauvaiseUtilisationBreak n)
    else if (n = "" || List.exists (fun x -> x = n) lloop) then AstTds.Break(n)
    else raise (IdentifiantNonDeclare n)


(* analyse_tds_bloc : tds -> info_ast option -> AstSyntax.bloc -> AstTds.bloc *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre oia : None si le bloc li est dans le programme principal,
                   Some ia où ia est l'information associée à la fonction dans laquelle est le bloc li sinon *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le bloc en un bloc de type AstTds.bloc *)
(* Erreur si mauvaise utilisation des identifiants *)
and analyse_tds_bloc tds oia lloop li =
  let tdsbloc = creerTDSFille tds in
   let nli = List.map (analyse_tds_instruction tdsbloc oia lloop) li in
   nli


(* analyse_tds_fonction : tds -> AstSyntax.fonction -> AstTds.fonction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre : la fonction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme la fonction
en une fonction de type AstTds.fonction *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyse_tds_fonction maintds (AstSyntax.Fonction(t,n,lp,li))  =
  match chercherLocalement maintds n with
  | None -> let info = InfoFun(n,Undefined,[]) in
    let info_fun = (info_to_info_ast info) in
      ajouter maintds n info_fun;
      let tdsfille = creerTDSFille maintds in
        let m = List.map (fun (x,y) -> 
          let infovar = InfoVar(y,Undefined,0,"") in begin
            match chercherLocalement tdsfille y with
            | None -> 
            let info = info_to_info_ast infovar in
            ajouter tdsfille y info;
            (x,info)
            |Some _ -> raise (DoubleDeclaration y)
            end) lp in
          Ast.AstTds.Fonction (t,info_fun,m,(analyse_tds_bloc tdsfille (Some info_fun) [] li))
  | Some _-> raise (DoubleDeclaration n) 

(* analyser : AstSyntax.programme -> AstTds.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le programme
en un programme de type AstTds.programme *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyser (AstSyntax.Programme (fonctions,prog)) =
  let tds = creerTDSMere () in
  let nf = List.map (analyse_tds_fonction tds) fonctions in
  let nb = analyse_tds_bloc tds None [] prog in
  AstTds.Programme (nf,nb)