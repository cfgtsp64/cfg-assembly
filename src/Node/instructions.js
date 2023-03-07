const instruction_idx = {
	add:            0,
	sub:            1,
	mul:            2,
	div:            3,
	get:            4,
	clear:          5,
	move:           6,
	set:            7,
	cout:           8,
	coutnl:         9,
	coutnlrange:    10,
	coutnlrangestr: 11,
	jmp:            12,
	setpc:          13,
	resetpc:        14,
	halt:           15,
	kill:           16,
	testlt:         17,
	testgt:         18,
	testle:         19,
	testge:         20,
	testeq:         21,
	call:           22,
	return:         23,
};

const instruction_tidx = {
	add:            3,
	sub:            3,
	mul:            3,
	div:            3,
	get:            2,
	clear:          1,
	move:           2,
	set:            2,
	cout:           1,
	coutnl:         1,
	coutnlrange:    2,
	coutnlrangestr: 2,
	jmp:            1,
	setpc:          1,
	resetpc:        0,
	halt:           1,
	kill:           0,
	testlt:         3,
	testgt:         3,
	testle:         3,
	testge:         3,
	testeq:         3,
	call:           1,
	return:         2,
};

module.exports = {instruction_idx: instruction_idx, instruction_tidx: instruction_tidx};