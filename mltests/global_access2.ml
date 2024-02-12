let x = Array.make 2 0 in
let rec prod_pred y =
  let d = Array.make 2 0 in
  d.(0) <- succ y.(0);
  d.(1) <- y.(0);
  d in
let rec loop n a = if n = 0 then a else prod_pred (loop (n-1) a) in
let rec snd t = t.(1) in
let rec rem10 x =
  if x<10 then x else rem10 (x-10) in
let rec dight_print x =
  if x<=0 then () 
  else (print_int (rem10 x); dight_print (int_of_float ((float_of_int x) /. 10.))) in
dight_print (snd (loop 13285 x))