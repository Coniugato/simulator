let rec rem10 x =
  if x<10 then x else rem10 (x-10) in
let rec dight_print x n =
  if n<=0 then print_int (rem10 (int_of_float x))
  else (print_int (rem10 (int_of_float x)); dight_print (x *. 10.) (n-1)) in
 (dight_print 31.2 10)