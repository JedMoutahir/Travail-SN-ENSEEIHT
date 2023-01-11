/* Imports. */

%{

open Type
open Ast.AstSyntax
%}


%token <int> ENTIER
%token <string> ID
%token RETURN
%token PV
%token AO
%token AF
%token PF
%token PO
%token EQUAL
%token CONST
%token PRINT
%token IF
%token ELSE
%token WHILE
%token BOOL
%token INT
%token RAT
%token CALL 
%token CO
%token CF
%token SLASH
%token NUM
%token DENOM
%token TRUE
%token FALSE
%token PLUS
%token MULT
%token INF
%token EOF

(* Pointeur *)
%token NULL
%token NEW
%token ADDR

(* Conditionelle Ternaire *)
%token PTINT
%token PP

(* Loop Rust *)
%token LOOP
%token CONTINUE
%token BREAK

(* Type de l'attribut synthétisé des non-terminaux *)
%type <programme> prog
%type <instruction list> bloc
%type <fonction> fonc
%type <instruction> i
%type <typ> typ
%type <typ*string> param

(* Pointeur *)
%type <affectable> a

%type <expression> e 


(* Type et définition de l'axiome *)
%start <Ast.AstSyntax.programme> main

%%

main : lfi=prog EOF     {lfi}

prog : lf=fonc* ID li=bloc  {Programme (lf,li)}

fonc : t=typ n=ID PO lp=param* PF li=bloc {Fonction(t,n,lp,li)}

param : t=typ n=ID  {(t,n)}

bloc : AO li=i* AF      {li}

i :
| t=typ n=ID EQUAL e1=e PV          {Declaration (t,n,e1)}
(* Pointeur *)
| n=a EQUAL e1=e PV                {Affectation (n,e1)}
| CONST n=ID EQUAL e=ENTIER PV      {Constante (n,e)}
| PRINT e1=e PV                     {Affichage (e1)}

(* Else optionel *)
| IF exp=e li=bloc                  {Conditionnelle (exp,li,[])}

| IF exp=e li1=bloc ELSE li2=bloc   {Conditionnelle (exp,li1,li2)}
| WHILE exp=e li=bloc               {TantQue (exp,li)}

(* Loop Rust *)
| LOOP li=bloc                      {Loop ("_", li)}
| n=ID PP LOOP li=bloc              {Loop (n, li)}
| CONTINUE PV                       {Continue ("")}
| CONTINUE n=ID                     {Continue (n)}
| BREAK PV                          {Break ("")}
| BREAK n=ID PV                     {Break (n)}

| RETURN exp=e PV                   {Retour (exp)}

typ :
| BOOL    {Bool}
| INT     {Int}
| RAT     {Rat}

(* Pointeur *)
| t=typ MULT               {Pointeur (t)}

(* Ajout regle pour exemple *)
| PO t=typ PF               {t}

(* Pointeurs *)
a :
| n=ID                      {Ident n}
| MULT aff=a               {DeRef(aff)}
| PO aff=a PF               {aff}

e : 
| CALL n=ID PO lp=e* PF   {AppelFonction (n,lp)}
| CO e1=e SLASH e2=e CF   {Binaire(Fraction,e1,e2)}

(* Pointeur *)
| n=a                     {Affectable(n)}

| TRUE                    {Booleen true}
| FALSE                   {Booleen false}
| e=ENTIER                {Entier e}
| NUM e1=e                {Unaire(Numerateur,e1)}
| DENOM e1=e              {Unaire(Denominateur,e1)}
| PO e1=e PLUS e2=e PF    {Binaire (Plus,e1,e2)}
| PO e1=e MULT e2=e PF    {Binaire (Mult,e1,e2)}
| PO e1=e EQUAL e2=e PF   {Binaire (Equ,e1,e2)}
| PO e1=e INF e2=e PF     {Binaire (Inf,e1,e2)}
| PO exp=e PF             {exp}

(* Conditionelle Ternaire *)
| PO ec=e PTINT ev=e PP ef=e PF      {Ternaire(ec, ev, ef)}

(* Pointeur *)
| NULL                                  {Null}
| PO NEW t=typ PF                       {New t}
| ADDR n=ID                             {Adresse n}

