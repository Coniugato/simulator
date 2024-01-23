main:addi t0,t0,1
      call test
      j end
float_data:
    .data float, -2.7
    .data float, -2.4
    .data float, -4
    .data float, 2.7
test:
    addr t0, float_data
    flw ft0, t0, 0
    flw ft1, t0, 4
    flw ft2, t0, 8
    flw ft3, t0, 12
    
    floor t3, ft0
    fround t4, ft0  
    floor t5, ft1
    fround t6, ft1
    floor a0, ft2
    fround a1, ft2 
    floor a2, ft3
    fround a3, ft3    
end:
    nop
