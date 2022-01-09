##################################################
############# All Instructions ###################
##################################################
import re
MEM_SIZE=2**20

ONE_OPERAND = "oneOp"
NOP="nop"; HLT="hlt"; SETC="setc";
NOT="not"; INC="inc"; OUT="out"; IN="in";

TWO_OPERANDS = "twoOp"
MOV="mov"; ADD="add"; SUB="sub";
AND="and"; IADD="iadd";

MEM_OPERATIONS = "memory"
PUSH="push"; POP="pop"; LDM="ldm";
LDD="ldd"; STD="std";

BRANCH_OPERATIONS = "branch"
JZ='jz'; JN='jn'; JC='jc';
JMP='jmp';CALL='call'; RET='ret';
INT='int'; RTI='rti';

ORG='.org'
INSTRUCTIONS= {
    ONE_OPERAND:{
        NOP: "000", HLT: "001", SETC: "010", NOT: "011", INC: "100",
        OUT:"101",IN:"110"
    },
    TWO_OPERANDS:{
        MOV:"000",ADD:"001", SUB:"010",
        AND:"011",IADD:"100"
    },
    MEM_OPERATIONS:{
        PUSH:"000",POP:"001",LDM:"010",
        LDD:"011",STD:"100"
    },
    BRANCH_OPERATIONS:{
        JZ:"000",JN:"001",JC:"010",
        JMP:"011",CALL:"100",RET:"101",
        INT:"110",RTI:"111"
    }
}

ONE_OPERAND_WITH_RDST=[NOT,INC,OUT,IN]
ONE_OPERAND_INSTRUCTIONS=INSTRUCTIONS[ONE_OPERAND]

TWO_OPERAND_INSTRUCTIONS=INSTRUCTIONS[TWO_OPERANDS]
MEMORY_INSTRUCTIONS=INSTRUCTIONS[MEM_OPERATIONS]
BRANCH_INSTRUCTIONS = INSTRUCTIONS[BRANCH_OPERATIONS]
# 32 bits
LONG_OPERATIONS=[IADD,LDM,LDD,STD]


def hextobin(h):
    print(h)
    return bin(int(h, 16))[2:].zfill(16)

def registerAddr(rstr):
    print(rstr)
    return bin(int(rstr.split('r')[1]))[2:].zfill(3)


class Instruction:
    def __init__(self,isLong=False) -> None:
        length=33 if isLong else 16
        self.bitsString=['0' for _ in range(length)]
    
        if isLong:
            self.bitsString[16]='\n'
        
    def __str__(self) -> str:
        return ''.join(self.bitsString)

    def __repr__(self) -> str:
        return self.__str__()
    
    def save(self,file):
        file.write(''.join(self.bitsString))
    
    def fromString(self,string):
        pass
    

class OneOperand(Instruction):
    def __init__(self, operation: str, rdst: str) -> None:
        super().__init__()
        self.bitsString[0:12] = "000"+operation+ registerAddr(rdst)+ registerAddr( rdst)

class TwoOperands(Instruction):
    def __init__(self, isLong:bool,operation: str, rdst: str, rsrc1: str, rsrc2="r0", imm="0"*4) -> None:
        section = "101" if isLong else "001"
        imm=hextobin(imm)
        super().__init__(isLong)
        self.bitsString[0:15] = section + operation+registerAddr(rdst)+registerAddr(rsrc1)+registerAddr(rsrc2)

        if isLong:
            self.bitsString[17:34]=imm

class MemoryOperation(Instruction):
    def __init__(self, isLong:bool,operation: str, rdst: str, rsrc1="r0", rsrc2="r0", offset="0"*4) -> None:
        section = "110" if isLong else "010"
        offset = hextobin(offset)

        super().__init__(isLong)
        self.bitsString[0:15] =section +operation+registerAddr(rdst)+registerAddr(rsrc1)+registerAddr(rsrc2)

        if isLong:
            self.bitsString[17:34]=offset

class BranchOperation(Instruction):
    def __init__(self,operation: str, rdst:str) -> None:
        super().__init__()
        self.bitsString[0:12] ="011" + operation +"000"+ registerAddr(rdst)


class InstructionFactoryInterface:
    def create(self, instruction: str) -> Instruction:
        pass


class OneOperandFactory(InstructionFactoryInterface):
    def create(self, instParts: list) -> OneOperand:
        instCode = ONE_OPERAND_INSTRUCTIONS[instParts[0]]
        rdst="r0"
        if instParts[0] in ONE_OPERAND_WITH_RDST:
            rdst = instParts[1]
        return OneOperand(instCode,rdst)


class BranchOperationFactory(InstructionFactoryInterface):
    def create(self, instParts: list) -> BranchOperation:
        instCode = BRANCH_INSTRUCTIONS[instParts[0]]
        rdst="r0"

        if not instParts[0] in [RET,RTI]:
            rdst = instParts[1]
        if instParts[0]==INT:
            rdst='r'+rdst
        return BranchOperation(instCode,rdst)

class TwoOperandsFactory(InstructionFactoryInterface):
    def create(self, instParts: list) -> TwoOperands:
        instCode = TWO_OPERAND_INSTRUCTIONS[instParts[0]]
        rdst=instParts[1]
        rsrc1=instParts[2]
        rsrc2="r0"; imm="0"*4
        isLong=False

        if instParts[0] in LONG_OPERATIONS:
            imm=instParts[3]
            isLong=True
        
        elif len(instParts) > 3:
            rsrc2 = instParts[3]
        
        if instParts[0]==MOV: # since mov instruction is flipped in the document
            rdst, rsrc1 = [rsrc1,rdst]

        return TwoOperands(isLong,instCode,rdst,rsrc1,rsrc2,imm)

class MemoryOperationFactory(InstructionFactoryInterface):
    def create(self, instParts: list) -> MemoryOperation:
        instCode = MEMORY_INSTRUCTIONS[instParts[0]]
        if instParts[0] in [PUSH,POP]:
            return MemoryOperation(False,instCode,instParts[1])
        elif instParts[0] == LDM:
            return MemoryOperation(True, instCode, instParts[1], offset=instParts[2])
        elif instParts[0] == LDD:
            return MemoryOperation(True, instCode, instParts[1], offset=instParts[2], rsrc1=instParts[3])
        elif instParts[0] == STD:
            return MemoryOperation(True, instCode, "r0", rsrc2=instParts[1], offset=instParts[2],rsrc1=instParts[3])




class InstructionFactory(InstructionFactoryInterface):
    def __init__(self) -> None:
        super().__init__()
        self.oneOperandFactory=OneOperandFactory()
        self.twoOperandsFactory=TwoOperandsFactory()
        self.memoryOperationFactory = MemoryOperationFactory()
        self.branchOperationFactory = BranchOperationFactory()
    @staticmethod
    def prepare(instruction:str)->str:
        parts = instruction.strip()
        parts=re.split('[ ,()]',parts)
        return list(filter(lambda x:x!='',parts))
    
    def create(self,instString:str)->Instruction:
        return self._create(self.prepare(instString))
    
    def _create(self,instParts:list)->Instruction:
        if instParts[0] in ONE_OPERAND_INSTRUCTIONS.keys():
            return  self.oneOperandFactory.create(instParts)
        elif instParts[0] in TWO_OPERAND_INSTRUCTIONS.keys():
            return  self.twoOperandsFactory.create(instParts)
        elif instParts[0] in MEMORY_INSTRUCTIONS.keys():
            return self.memoryOperationFactory.create(instParts)
        elif instParts[0] in BRANCH_INSTRUCTIONS.keys():
            return self.branchOperationFactory.create(instParts)
        else:
            inst = Instruction()
            inst.bitsString=hextobin(instParts[0])
            return inst


class Assember:
    def __init__(self) -> None:
        self.factory=InstructionFactory()
        self.index=0
        self.instructions=['0'*16 for _ in range(MEM_SIZE)]

    def openFile(self,filePath):
        self.inFile=open(filePath,'r')
   
    def  assemble(self):
        for line in self.inFile:
            withoutComment=line.lower().strip()
            withoutComment = re.split('[#/-]',withoutComment)[0]
            withoutComment=''.join(withoutComment)
            if withoutComment=='':
                continue
            parts=InstructionFactory.prepare(withoutComment)
            if parts[0]==ORG:
                self.index=int(parts[1],16)
                continue
            self.instructions[self.index]=self.factory.create(withoutComment)
            self.index+=1
         
    def writeToFile(self,fileName="output.txt"):
        self.outFile=open(fileName,'w')
        for inst in self.instructions:
            self.outFile.write(inst.__str__()+'\n')
        self.outFile.close()
        


import sys
if __name__ == "__main__" and len(sys.argv) > 1:
    assember=Assember()

    inFileName=sys.argv[1]
    assember.openFile(inFileName)
    assember.assemble()
    if len(sys.argv)>2:
        outFileName=sys.argv[1]
        assember.writeToFile(outFileName)
    else:
        assember.writeToFile()
else:
    assember=Assember()
    assember.openFile('./test.txt')
    assember.assemble()
    assember.writeToFile()
