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

let first_then_apply (lst : 'a list) (pred : 'a -> bool) (f : 'a -> 'b option) : 'b option =
  let rec find_and_apply = function
    | [] -> None
    | x :: xs -> if pred x then f x else find_and_apply xs
  in
  find_and_apply lst

let rec int_pow (base : int) (exponent : int) : int =
  if exponent = 0 then 1 else base * int_pow base (exponent - 1)

let powers_generator (base : int) : int Seq.t =
  let rec aux (n : int) : int Seq.node =
    Seq.Cons (int_pow base n, fun () -> aux (n + 1))
  in
  fun () -> aux 0

let meaningful_line_count (filename : string) : int =
  let count_lines (ic : in_channel) : int =
    let rec aux (count : int) : int =
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

type shape =
  | Sphere of float
  | Box of float * float * float

let volume (s : shape) : float =
  match s with
  | Sphere r -> (4.0 /. 3.0) *. Float.pi *. (r ** 3.0)
  | Box (l, w, h) -> l *. w *. h

let surface_area (s : shape) : float =
  match s with
  | Sphere r -> 4.0 *. Float.pi *. (r ** 2.0)
  | Box (l, w, h) -> 2.0 *. (l *. w +. w *. h +. h *. l)

type 'a bst =
  | Empty
  | Node of 'a * 'a bst * 'a bst

let rec insert (x : 'a) (tree : 'a bst) : 'a bst =
  match tree with
  | Empty -> Node (x, Empty, Empty)
  | Node (y, left, right) ->
      if x < y then Node (y, insert x left, right)
      else if x > y then Node (y, left, insert x right)
      else tree

let rec contains (x : 'a) (tree : 'a bst) : bool =
  match tree with
  | Empty -> false
  | Node (y, left, right) ->
      if x = y then true
      else if x < y then contains x left
      else contains x right

let rec size (tree : 'a bst) : int =
  match tree with
  | Empty -> 0
  | Node (_, left, right) -> 1 + size left + size right

let rec inorder (tree : 'a bst) : 'a list =
  match tree with
  | Empty -> []
  | Node (y, left, right) -> inorder left @ [y] @ inorder right