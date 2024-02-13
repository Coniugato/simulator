min_caml_print_int:
    li  a1, 512
    beq a0, a1, min_caml_print_int_512
    li  a1, 200
    bge a0, a1, min_caml_print_int_100_2
    li  a1, 100
    bge a0, a1, min_caml_print_int_100_1
    j   min_caml_print_int_100_0
min_caml_print_int_100_2:
    li  a2, 50
    out a2
    sub a0, a0, a1
    j   min_caml_print_int_10
min_caml_print_int_100_1:
    li  a2, 49
    out a2
    sub a0, a0, a1
    j   min_caml_print_int_10
min_caml_print_int_100_0:
    li  a2, 48
    out a2
min_caml_print_int_10:
    li a1, 90
    bge a0, a1, min_caml_print_int_10_9
    li a1, 80
    bge a0, a1, min_caml_print_int_10_8
    li a1, 70
    bge a0, a1, min_caml_print_int_10_7
    li a1, 60
    bge a0, a1, min_caml_print_int_10_6
    li a1, 50
    bge a0, a1, min_caml_print_int_10_5
    li a1, 40
    bge a0, a1, min_caml_print_int_10_4
    li a1, 30
    bge a0, a1, min_caml_print_int_10_3
    li a1, 20
    bge a0, a1, min_caml_print_int_10_2
    li a1, 10
    bge a0, a1, min_caml_print_int_10_1
    j min_caml_print_int_10_0
min_caml_print_int_10_9:
    li  a2, 57
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_8:
    li  a2, 56
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_7:
    li  a2, 55
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_6:
    li  a2, 54
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_5:
    li  a2, 53
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_4:
    li  a2, 52
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_3:
    li  a2, 51
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_2:
    li  a2, 50
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_1:
    li  a2, 49
    out a2
    sub a0, a0, a1
    j min_caml_print_int_1
min_caml_print_int_10_0:
    li  a2, 48
    out a2
min_caml_print_int_1:
    li a1, 9
    bge a0, a1, min_caml_print_int_1_9
    li a1, 8
    bge a0, a1, min_caml_print_int_1_8
    li a1, 7
    bge a0, a1, min_caml_print_int_1_7
    li a1, 6
    bge a0, a1, min_caml_print_int_1_6
    li a1, 5
    bge a0, a1, min_caml_print_int_1_5
    li a1, 4
    bge a0, a1, min_caml_print_int_1_4
    li a1, 3
    bge a0, a1, min_caml_print_int_1_3
    li a1, 2
    bge a0, a1, min_caml_print_int_1_2
    li a1, 1
    bge a0, a1, min_caml_print_int_1_1
    li a1, 0
    bge a0, a1, min_caml_print_int_1_0
min_caml_print_int_1_9:
    li  a2, 57
    out a2
    ret
min_caml_print_int_1_8:
    li  a2, 56
    out a2
    ret
min_caml_print_int_1_7:
    li  a2, 55
    out a2
    ret
min_caml_print_int_1_6:
    li  a2, 54
    out a2
    ret
min_caml_print_int_1_5:
    li  a2, 53
    out a2
    ret
min_caml_print_int_1_4:
    li  a2, 52
    out a2
    ret
min_caml_print_int_1_3:
    li  a2, 51
    out a2
    ret
min_caml_print_int_1_2:
    li  a2, 50
    out a2
    ret
min_caml_print_int_1_1:
    li  a2, 49
    out a2
    ret
min_caml_print_int_1_0:
    li  a2, 48
    out a2
    ret
min_caml_print_int_512:
    li  a2, 53
    out a2
    li  a2, 49
    out a2
    li  a2, 50
    out a2
    ret
