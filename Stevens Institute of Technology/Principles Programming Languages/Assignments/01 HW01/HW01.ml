
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
let absolute (x:'a) : 'a = 
    if x > 0 then
        x
    else
        (-x)


let succ (x:int) : int = x+1

let f (x:'a) : 'b = x

let app (fn:'a->'b) (x:'a) : 'b = fn x

let twice (fn:'a->'b) (x:'a) : 'b = fn (fn x)


let rec belongTo_ext (set:'a list) (x:'a): bool =
    match set with
    | [] -> false
    | a::ax -> if a = x then true
                else belongTo_ext ax x

let rec belongTo_char (set:('a->bool) list) (x:('a->bool)): bool =
    match set with
    | [] -> false
    | a::ax -> if a == x then true
                else belongTo_ext ax x

let union_ext (fa:'a->bool) (fb:'a->bool) (x:'a) : bool = 
    (fa x) || (fb x)

let union_char (fa:'a->bool) (fb:'a->bool) (x:'a) : bool = 
    (fa x) || (fb x)

let intersection_ext (fa:'a->bool) (fb:'a->bool) (x:'a) : bool = 
    (fa x) && (fb x)

let intersection_char (fa:'a->bool) (fb:'a->bool) (x:'a) : bool = 
    (fa x) && (fb x)