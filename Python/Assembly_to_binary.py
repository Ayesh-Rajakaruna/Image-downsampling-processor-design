def compiler(instruction):
    parts = instruction.split()

    instructions = ['NOP', 'LOAD', 'STORE', 'COPY', 'JUMP', 'ADD', 'SUB', 'MUL', 'DIV', 'CLR', 'INC', 'DEC', 'LOADK',
                    'END']
    inscode = ['0000', '0001', '0010', '0011', '0100', '0101', '0110', '0111', '1000', '1001', '1010', '1011', '1100',
               '1111']

    registers = ['AC', 'R1', 'R2', 'MAR', 'MDR', 'SR1', 'SR2', 'SR3', 'RRR', 'CRR', 'RWR', 'CWR', 'RR', 'WR']
    registercode = ['0001', '0010', '0011', '0100', '0101', '0110', '0111', '1000', '1001', '1010', '1011', '1100',
                    '0010', '0010']

    opcode = inscode[instructions.index(parts[0])]
    restricted = ['LOADK', 'JUMP', 'MUL', 'DIV']

    if parts[0] not in restricted:
        if len(parts) > 1:
            opcode = opcode + registercode[registers.index(parts[1])]
            if len(parts) == 2:
                opcode = opcode + '00000000'
            else:
                opcode = opcode + '0000' + registercode[registers.index(parts[2])]
        else:
            opcode = opcode + '000000000000'
        return opcode

    elif parts[0] == 'IDLE':
        opcode = '0000000000000000'
        return opcode

    else:
        if parts[0] == 'LOADK':
            k = int(parts[1])
            kbin = bin(k)[2:]
            opcode = opcode + (12 - len(kbin)) * '0' + kbin
        else:
            if parts[0] == 'JUMP':
                jmpcond = ['Z=0', 'Z!=0', 'U']
                jmpcondcode = ['0001', '0010', '0000']
                opcode = opcode + jmpcondcode[jmpcond.index(parts[1])]
                addr = int(parts[2])
                addrbin = bin(addr)[2:]
                opcode = opcode + (8 - len(addrbin)) * '0' + addrbin

            if parts[0] == 'DIV' or parts[0] == 'MUL':
                param = bin(int(parts[1]))[2:]
                param = (4 - len(param)) * '0' + param
                opcode = opcode + param + '00000000'

        return opcode


file = open('Assembly_code.txt', 'r')
hexfile = open('BinaryOfAssembly.txt', 'w')
lines = file.readlines()
opcodes = []

for i in range(len(lines)):
    opcodes.append(compiler(lines[i]))

count = 0
for l in opcodes:
    hexfile.write(f"IRAM[{count}] = 16'b{l};")
    hexfile.write("\n")
    count = count + 1
