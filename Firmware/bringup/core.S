.global core0
core0:
	beq x0,x0,core0
	auipc sp,0
	ebreak