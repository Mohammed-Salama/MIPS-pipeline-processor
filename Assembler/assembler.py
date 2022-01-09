##################################################
############# All Instructions ###################
##################################################
import re

ONE_OPERAND = "oneOp"
NOP="nop"; HLT="hlt"; SETC="setc";
NOT="not"; INC="inc"; OUT="out"; IN="in";

TWO_OPERANDS = "twoOp"
MOV="mov"; ADD="add"; SUB="sub";
AND="and"; IADD="iadd";

INSTRUCTIONS= {
    ONE_OPERAND:{
        NOP: "000", HLT: "001", SETC: "010", NOT: "011", INC: "100",
        OUT:"101",IN:"110"
    },
    TWO_OPERANDS:{
        MOV:"000",ADD:"001", SUB:"010",
        AND:"011",IADD:"100"
    }
}

ONE_OPERAND_WITH_RDST=[NOT,INC,OUT,IN]
ONE_OPERAND_INSTRUCTIONS=INSTRUCTIONS[ONE_OPERAND]

TWO_OPERAND_INSTRUCTIONS=INSTRUCTIONS[TWO_OPERANDS]
# 32 bits
TWO_OPERAND_LONG=[IADD]

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
        self.bitsString[0:12] = "000"+operation+rdst+rdst

class TwoOperands(Instruction):
    def __init__(self, isLong:bool,operation: str, rdst: str, rsrc1: str, rsrc2="0"*3, imm="0"*16) -> None:
        section = "101" if isLong else "001"

        super().__init__(isLong)
        self.bitsString[0:15] =section +operation+rdst+rsrc1+rsrc2

        if isLong:
            self.bitsString[17:34]=imm


class InstructionFactoryInterface:
    def create(self, instruction: str) -> Instruction:
        pass


class OneOperandFactory(InstructionFactoryInterface):
    def create(self, instParts: list) -> OneOperand:
        instCode = ONE_OPERAND_INSTRUCTIONS[instParts[0]]
        rdst="000"
        if instParts[0] in ONE_OPERAND_WITH_RDST:
            rdst = instParts[1]
        return OneOperand(instCode,rdst)

class TwoOperandsFactory(InstructionFactoryInterface):
    def create(self, instParts: list) -> TwoOperands:
        instCode = TWO_OPERAND_INSTRUCTIONS[instParts[0]]
        rdst=instParts[1]
        rsrc1=instParts[2]
        rsrc2="000"; imm="0"*16
        isLong=False

        if instParts[0] in TWO_OPERAND_LONG:
            imm=instParts[3]
            isLong=True
        
        elif len(instParts) > 3:
            rsrc2 = instParts[3]
        
        if instParts[0]==MOV: # since mov instruction is flipped in the document
            rdst, rsrc1 = [rsrc1,rdst]
        # if instParts[0] in TWO_OPERAND_LONG:
            # print(instCode, rdst, rsrc1, rsrc2, imm)
        return TwoOperands(isLong,instCode,rdst,rsrc1,rsrc2,imm)


class InstructionFactory(InstructionFactoryInterface):
    def __init__(self) -> None:
        super().__init__()
        self.oneOperandFactory=OneOperandFactory()
        self.twoOperandsFactory=TwoOperandsFactory()
    
    def prepare(self,instruction:str)->str:
        parts = instruction.strip()
        parts=re.split('[ ,]',parts)
        return list(filter(lambda x:x!='',parts))
    
    def create(self,instString:str)->Instruction:
        return self._create(self.prepare(instString))
    
    def _create(self,instParts:list)->Instruction:
        if instParts[0] in ONE_OPERAND_INSTRUCTIONS.keys():
            return  self.oneOperandFactory.create(instParts)
        elif instParts[0] in TWO_OPERAND_INSTRUCTIONS.keys():
            return  self.twoOperandsFactory.create(instParts)

class Assember:
    def __init__(self) -> None:
        self.factory=InstructionFactory()

    def openFile(self,filePath):
        self.inFile=open(filePath,'r')
    
    def writeToFile(self,fileName="output.txt"):
        self.outFile=open(fileName,'w')
        for line in self.inFile:
            withoutComment=line.lower().strip().split('#')[0].split('//')[0].split('--')
            withoutComment=''.join(withoutComment)
            if withoutComment=='':
                continue
            inst=self.factory.create(withoutComment)
            self.outFile.write(inst.__str__()+'\n')
        self.outFile.close()
        


import sys
if __name__ == "__main__" and len(sys.argv) > 1:
    assember=Assember()

    inFileName=sys.argv[1]
    assember.openFile(inFileName)

    if len(sys.argv)>2:
        outFileName=sys.argv[1]
        assember.writeToFile(outFileName)
    else:
        assember.writeToFile()
else:
    assember=Assember()
    assember.openFile('test.txt')
    assember.writeToFile()
