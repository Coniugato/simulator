let th = 0.001 in
let m = 203 in
let f x = x *. x -. float_of_int m in
let df x = 2. *. x in
let rec newton x = 
  if f x < th && f x > -.th
    then x
  else
  let newx = x -. (f x) /. (df x) in
    newton newx in newton 0.2;;

