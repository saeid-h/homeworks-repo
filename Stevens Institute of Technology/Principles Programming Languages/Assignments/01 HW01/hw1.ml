
let add (x:int) (y:int) : int = x + y

(* Exercise 1 *)
(* 1 *)
let seven (x:'a) : int = 7

(* 2 *)
let sign (x:int) : int =
    if x > 0 then
        1
    else if x < 0 then
        (-1)
    else
        0
(* 3 *)
let absolute_float (x:float) : float = 
    if x > 0. then
        x
    else
        (-.x)

let absolute (x:int) : int = 
    if x > 0 then
        x
    else
        (-x)

(* 4 *)
let andp (x:bool) (y:bool) : bool =
    match x, y with
    | true, true -> true
    | _,_ -> false

let orp (x:bool) (y:bool) : bool =
    match x, y with 
    | false, false -> false
    | _, _ -> true

let notp (x:bool) : bool =
    if x then false else true

let xorp (x:bool) (y:bool) : bool =
    x != y

(* 5 *)
let dividesBy (a:int) (b:int) : bool = 
    a mod b = 0

(* 6 *)
let is_sigleton (x: 'a list) : bool = 
    match x with
    | [a] -> true
    | _ -> false

(* 7 *)
let swap ((x,y):('a*'b)) : ('b*'a) = 
    (y, x)

(* 8 *)
let app (f:'a->'b) (x:'a) : 'b = 
    f x

let succ (x:int) : int = x+1
let f (x:'a) : 'a = x

(* 9 *)
let twice (f:'a->'b) (x:'a) : 'b = f (f x)

(* 10 *)
let compose (f:'b->'c) (g:'a->'b) (x:'a) : 'c = f (g x)






(* Exercise 2 *)
(* 1 *)
let rec belongsTo_ext (set:'a list) (x:'a): bool =
    match set with
    | [] -> false
    | a::ax -> if a = x then true
                else belongsTo_ext ax x

let rec belongsTo_char (set:'a list) : ('a->bool) =
    belongsTo_ext set

let rec union_ext (setA:'a list) (setB:'a list) : ('a list) = 
    match setB with
    | [] -> setA
    | e::es ->  if belongsTo_ext setA e then
                    union_ext setA es
                else 
                    (union_ext setA es)@[e]

let union_char (fA:'a->bool) (fB:'a->bool) (x:'a): (bool) = 
        fA x || fB x

let rec intersection_ext (setA:'a list) (setB:'a list) : ('a list) = 
    match setA, setB with
    | _, [] -> []
    | [], _ -> []
    | ea::eas, _ -> if belongsTo_ext setB ea then
                        ea::(intersection_ext eas setB)
                    else 
                        intersection_ext eas setB

let intersection_char (fA:'a->bool) (fB:'a->bool) (x:'a) : bool = 
    fA x && fB x


(* 2 *)
let rec remAdjDups (x: 'a list) : 'a list =
    match x with 
    | [] -> []
    | [xe] -> [xe]
    | x1::x2::xs -> if x1 = x2 then
                        remAdjDups (x2::xs)
                    else 
                        x1::remAdjDups (x2::xs)

(* 3 *)
(* ref: https://stackoverflow.com/questions/728972/finding-all-the-subsets-of-a-set *)
let rec sublists (x: 'a list) : ('a list) list = 
    let  rec  insert (e: 'a) (l: ('a list) list)  : ('a list) list =
        match l with
        | [] -> []
        | (x::xs) ->  [[e]@x]@(insert e xs)
    in
    match x with
    | [] -> [[]]
    | x1::xs -> (insert  x1 (sublists xs)) @ (sublists xs) 








(* Exercise 3 *)
type calcExp =
    | Const of int
    | Add of ( calcExp * calcExp )
    | Sub of ( calcExp * calcExp )
    | Mult of ( calcExp * calcExp )
    | Div of ( calcExp * calcExp )


let e1 = Const (2)
let e2 = Add ( Sub ( Const (2) , Const (3)) , Const (4))
let e3 = Add (Const (3), Add(Mult(Const(3),Const(2)), Const (5)))
let e4 = Mult (Add (Const (3), Add(Sub(Const(3),Const(2)), Const (5))), Const (8))
let e5 = Div(Add(e4,Const(2)),Const(5))

(* 1 *)
let rec mapC (exp:calcExp) : calcExp = 
    match exp with
    | Const x -> Const (x+1)
    | Add (x,y) -> Add (mapC(x),mapC(y))
    | Sub (x,y) -> Sub (mapC(x),mapC(y))
    | Mult (x,y) -> Mult (mapC(x),mapC(y))
    | Div (x,y) -> Div (mapC(x),mapC(y))

(* here is the general solution: *)
let rec mapC' (f:'a->'a) (exp:calcExp) : calcExp = 
    match exp with
    | Const x -> Const (f x)
    | Add (x,y) -> Add (mapC(x),mapC(y))
    | Sub (x,y) -> Sub (mapC(x),mapC(y))
    | Mult (x,y) -> Mult (mapC(x),mapC(y))
    | Div (x,y) -> Div (mapC(x),mapC(y))

(* 2 *)
let rec foldC f e a =
    match e with 
    | Const x -> a (e)
    | Add (x,y) -> f e (foldC f x a) (foldC f y a)
    | Mult (x,y) -> f e (foldC f x a) (foldC f y a)
    | Sub (x,y) -> f e (foldC f x a) (foldC f y a)
    | Div (x,y) -> f e (foldC f x a) (foldC f y a)

(* 3 *)
let numAdd e = 
    let f = fun e a1 a2 ->
        match e with 
        | Add (x,y) -> 1+a1+a2
        | _ -> a2+a2
    and a = fun x -> 0
    in 
    foldC f e a


(* 4 *)    
let replaceAddWithMult e = 
    let f e a1 a2 = 
    match e with 
    | Add (x,y) -> Mult(a1,a2)
    | Mult (x,y) -> Mult(a1,a2)
    | Sub (x,y) -> Sub(a1,a2)
    | Div (x,y) -> Div(a1,a2)
    | _ -> e
    and a x = x
    in 
    foldC f e a


(* 5 *)
let rec evalC (e:calcExp) : int =
    match e with
    | Const x -> x
    | Add(x,y)-> evalC(x)+evalC(y)
    | Mult(x,y)-> evalC(x)*evalC(y)
    | Sub(x,y)-> evalC(x)-evalC(y)
    | Div(x,y)-> evalC(x)/evalC(y)
    

(* 6 *)
let evalCf e = 
    let f e a b = 
        match e with
        | Add(x,y) -> a+b
        | Mult(x,y) -> a*b
        | Sub(x,y) -> a-b
        | Div(x,y)-> a/b
        | Const x -> x
    and a x = match x with Const y -> y | _ -> 0
    in
    foldC f e a







(* Exercise 4 *)
(* 1 *)
let f xs =
let g = fun x r -> if x mod 2 = 0 then (+) r 1 else r
in List.fold_right g xs 0

(* This function returns the total amount of even numbers within a list
for example
f [1;2;3;2;1;3;5;6] -> 3
f [] -> 0
f [1;3;5;7] -> 0
f [4] -> 1
f [4;3;1;7] -> 1 *)

(* 2 *)
let concat xss =
let g = fun xs h -> xs@h
in List.fold_right g xss []

(* 3 *)
let append xs =
let g = fun x h -> [x]@h
in List.fold_right g xs

