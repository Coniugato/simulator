let a = read_float () in
let b = read_float () in
let arr = Array.make 3 (a +. b +. read_float ()) in
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
let rec f x =  x *. x *. x -. 3.1415926 *. x *.x in
let rec rem10 x =
  if x<10 then x else rem10 (x-10) in
let rec dight_print x n =
  if n=0 then print_int (int_of_float x)
  else (print_int (rem10 (int_of_float x)); dight_print (x *. 10.) (n-1)) in
 (dight_print (newton f arr.(2)) 10)