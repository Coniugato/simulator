let arr = Array.make 3 (read_float ()) in
let h = 0.00001 in
let threshold = 0.00001 in
let rec dfdx f x =
  (f (x +. h) -.  f x )/. h in
let rec fl_abs x = if x > 0. then x else 0. -.x in
let rec newton f x =
  let newx = x -. (f x)/.(dfdx f x) in
  if (fl_abs (newx -. x)) < threshold 
    then x
else newton f newx in
let rec f x =  x *. x -. 2. *. x in
print_int (int_of_float ((newton f arr.(2)) *. 100000.))