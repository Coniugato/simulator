let rec rem10 x =
  if x<10 then x else rem10 (x-10) in
let rec dight_print x n =
  let dight = rem10 (int_of_float x) in
  let next = x -. float_of_int ((int_of_float x) - dight) in
  if n<=0 then print_int dight
  else ((print_int dight); dight_print (next *. 10.) (n-1)) in
 (dight_print 3.24765 10)