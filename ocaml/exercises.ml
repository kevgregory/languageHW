exception Negative_Amount

let change amount =
  if amount < 0 then
    raise Negative_Amount
  else
    let denominations = [25; 10; 5; 1] in
    let rec aux remaining denominations =
      match denominations with
      | [] -> []
      | d :: ds -> (remaining / d) :: aux (remaining mod d) ds
    in
    aux amount denominations

(* first then apply function *)
let first_then_apply lst pred f =
  let rec find_and_apply = function
    | [] -> None
    | x :: xs -> if pred x then Some (f x) else find_and_apply xs
  in
  find_and_apply lst

(* powers generator *)
let rec int_pow base exponent =
  if exponent = 0 then 1
  else base * int_pow base (exponent - 1)

let powers_generator base =
  let rec aux n =
    Seq.Cons (int_pow base n, fun () -> aux (n + 1))
  in
  aux 0

(* line count function *)
let meaningful_line_count filename =
  let count_lines ic =
    let rec aux count =
      try
        let line = input_line ic in
        let trimmed_line = String.trim line in
        if trimmed_line = "" || String.get trimmed_line 0 = '#' then
          aux count
        else
          aux (count + 1)
      with End_of_file -> count
    in
    aux 0
  in
  let ic = open_in filename in
  Fun.protect (fun () -> count_lines ic) ~finally:(fun () -> close_in ic)

(* shape type and associated functions *)
type shape =
  | Sphere of float
  | Box of float * float * float

let volume = function
  | Sphere r -> (4.0 /. 3.0) *. Float.pi *. (r ** 3.0)
  | Box (l, w, h) -> l *. w *. h

let surface_area = function
  | Sphere r -> 4.0 *. Float.pi *. (r ** 2.0)
  | Box (l, w, h) -> 2.0 *. (l *. w +. w *. h +. h *. l)

(* binary search tree implementation *)
type 'a bst =
  | Empty
  | Node of 'a * 'a bst * 'a bst

let rec insert x = function
  | Empty -> Node (x, Empty, Empty)
  | Node (y, left, right) as node ->
      if x < y then Node (y, insert x left, right)
      else if x > y then Node (y, left, insert x right)
      else node

let rec contains x = function
  | Empty -> false
  | Node (y, left, right) ->
      if x = y then true
      else if x < y then contains x left
      else contains x right

let rec size = function
  | Empty -> 0
  | Node (_, left, right) -> 1 + size left + size right

let rec inorder = function
  | Empty -> []
  | Node (y, left, right) -> inorder left @ [y] @ inorder right