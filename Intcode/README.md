Intcode
======

An Intcode program is a list of integers separated by commas (like `1,0,0,3,99`). To run one, start by looking at the first integer (called position `0`). Here, you will find an **opcode**. The opcode indicates what to do; for example, `99` means that the program is finished and should immediately halt. Encountering an unknown opcode means something went wrong.

### Opcodes

- Opcode `1` adds together numbers read from two positions and stores the result in a third position. The three integers immediately after the opcode tell you these three positions - the first two indicate the positions from which you should read the input values, and the third indicates the position at which the output should be stored. For example, if your Intcode computer encounters `1,10,20,30`, it should read the values at positions `10` and `20`, add those values, and then overwrite the value at position 30 with their sum.
- Opcode `2` works exactly like opcode `1`, except it multiplies the two inputs instead of adding them. Again, the three integers after the opcode indicate where the inputs and outputs are, not their values.
- Opcode `3` takes a single integer as input and saves it to the position given by its only parameter. For example, the instruction `3,50` would take an input value and store it at address `50`.
- Opcode `4` outputs the value of its only parameter. For example, the instruction `4,50` would output the value at address `50`.
- Opcode `5` is **jump-if-true**: if the first parameter is non-zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
- Opcode `6` is **jump-if-false**: if the first parameter is zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
- Opcode `7` is **less than**: if the first parameter is less than the second parameter, it stores `1` in the position given by the third parameter. Otherwise, it stores `0`.
- Opcode `8` is **equals**: if the first parameter is equal to the second parameter, it stores `1` in the position given by the third parameter. Otherwise, it stores `0`.
- Opcode `99` halts the execution. It has no parameters.

### Parameter modes

Each parameter of an instruction is handled based on its parameter mode. There are two parameter modes:

- **Position mode**, which causes the parameter to be interpreted as a position - if the parameter is `50`, its value is the value stored at address `50` in memory. 
- **Immediate mode**. In immediate mode, a parameter is interpreted as a value - if the parameter is `50`, its value is simply `50`.

Parameter modes are stored in the same value as the instruction's opcode. The opcode is a two-digit number based only on the ones and tens digit of the value, that is, the opcode is the rightmost two digits of the first value in an instruction. Parameter modes are single digits, one per parameter, read right-to-left from the opcode: the first parameter's mode is in the hundreds digit, the second parameter's mode is in the thousands digit, the third parameter's mode is in the ten-thousands digit, and so on. Any missing modes are `0`.

For example, consider the program `1002,4,3,4,33`.

The first instruction, `1002,4,3,4`, is a **multiply** instruction - the rightmost two digits of the first value, `02`, indicate opcode `2`, multiplication. Then, going right to left, the parameter modes are `0` (hundreds digit), `1` (thousands digit), and `0` (ten-thousands digit, not present and therefore zero):

```
ABCDE
 1002

DE - two-digit opcode,      02 == opcode 2
 C - mode of 1st parameter,  0 == position mode
 B - mode of 2nd parameter,  1 == immediate mode
 A - mode of 3rd parameter,  0 == position mode,
                                  omitted due to being a leading zero
```

This instruction multiplies its first two parameters. The first parameter, `4` in position mode, its value is the value stored at address `4` (`33`). The second parameter, `3` in immediate mode, simply has value `3`. The result of this operation, `33 * 3 = 99`, is written according to the third parameter, `4` in position mode, which also works like it did before - `99` is written to address `4`.

Parameters that an instruction writes to will **never be in immediate mode**.
