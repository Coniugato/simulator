let rec pow x n = 
  if n <= 0 then 1. else x *. (pow x (n-1)) in
let rec f n a = let rec tmp x = pow x n -. a in tmp in
let rec df n = let rec tmp x = (float_of_int n) *. (pow x (n-1)) in tmp in
let threshold = 0.0001 in
let rec abs x = if x < 0. then 0. -.x else x in
let rec step x g dg = let next = x -. ((g x) /. (dg x)) in 
  if (abs (next-.x))< threshold then next else (step next g dg) in
  print_float (step 0.1 (f 2 2.) (df 2))