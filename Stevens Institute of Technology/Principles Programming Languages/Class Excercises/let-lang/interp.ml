open Ast
open Ds


let init_env =
  ExtendEnv("i",NumVal 1,
   ExtendEnv("v",NumVal 5,
    ExtendEnv("x",NumVal 10,
      EmptyEnv)))
    
let rec eval_expr (en:env) (e:expr) :exp_val =
  match e with
  | Int n          -> NumVal n
  | Var id          ->
    (match apply_env en id with
    | None -> failwith @@ "Variable "^id^" undefined"
    | Some ev -> ev)
  | Add(e1, e2)    ->
    let v1 = eval_expr en e1 in
    let v2 = eval_expr en e2  in
    NumVal ((numVal_to_num v1) + (numVal_to_num v2))
  | Sub(e1, e2)    ->
    let v1 = eval_expr en e1 in
    let v2 = eval_expr en e2  in
    NumVal ((numVal_to_num v1) - (numVal_to_num v2))
  | IsZero(e) ->
    let v1 = eval_expr en e  in
    BoolVal (numVal_to_num v1=0)
  |  ITE(e1,e2,e3) ->
    let v1 = eval_expr en e1
    in    if boolVal_to_bool v1
        then eval_expr en e2
        else eval_expr en e3
  | Let(x, e1, e2) ->
    let v1 = eval_expr en e1  in
    eval_expr (extend_env en x v1) e2
  | Proc(x,e)      -> failwith "Not implemented"
  | App(e1,e2)     -> failwith "Not implemented"
  | _ -> failwith("Not implemented")

let eval_prog (AProg e) = eval_expr init_env e



(***********************************************************************)
(* Everything above this is essentially the same as we saw in lecture. *)
(***********************************************************************)

(* Parse a string into an ast *)


let parse s =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast


(* Interpret an expression *)
let interp (e:string) : exp_val =
  e |> parse |> eval_prog 

let ex1 = "
let x = 7  
in let y = 2 
   in let y = let x = x-1 
              in x-y 
      in (x-8)- y"

