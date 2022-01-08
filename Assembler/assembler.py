##################################################
############# All Instructions ###################
##################################################

ONE_OPERAND = "oneOp"
NOP="nop"; HLT="hlt"; SETC="setc";
NOT="not"; INC="inc"; OUT="out"; IN="in";

INSTRUCTIONS= {
    ONE_OPERAND:{
        NOP: "000", HLT: "001", SETC: "010", NOT: "011", INC: "100",
        OUT:"101",IN:"110"
    }
}
ONE_OPERAND_WITH_RDST=[NOT,INC,OUT,IN]
ONE_OPERAND_INSTRUCTIONS=INSTRUCTIONS[ONE_OPERAND]

class Instruction:
    def __init__(self) -> None:
        self.bitsString=['0' for _ in range(16)]
    
    def __str__(self) -> str:
        return ''.join(self.bitsString)

    def __repr__(self) -> str:
        return self.__str__()
    
    def save(self,file):
        assert not self.bitsString==[], "bits cannot be empty"
        assert len(self.bitsString) == 16 or len(self.bitsString) == 32,"invalid instruction length"
        file.write(''.join(self.bitsString))
    
    def fromString(self,string):
        pass
    

class OneOperand(Instruction):
    def __init__(self, operation: str, rdst: str) -> None:
        assert len(rdst)==3 , "invalid rdst"
        assert len(operation)==3 , "invalid operation"
        super().__init__()
        self.bitsString[0:3] = "000"+operation+rdst+rdst


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


class InstructionFactory(InstructionFactoryInterface):
    def __init__(self) -> None:
        super().__init__()
        self.oneOperandFactory=OneOperandFactory()
    
    def prepare(self,instruction:str)->str:
        parts = instruction.strip().split(' ')
        return list(filter(lambda x:x!='',parts))
    
    def create(self,instString:str)->Instruction:
        return self._create(self.prepare(instString))
    
    def _create(self,instParts:list)->Instruction:
        if instParts[0] in ONE_OPERAND_INSTRUCTIONS.keys():
            return  self.oneOperandFactory.create(instParts)

class Assember:
    def __init__(self) -> None:
        self.factory=InstructionFactory()

    def openFile(self,filePath):
        self.inFile=open(filePath,'r')
    
    def writeToFile(self,fileName="output.txt"):
        self.outFile=open(fileName,'w')
        for line in self.inFile:
            withoutComment=line.lower().split('#')[0].split('//')[0].split('--')
            withoutComment=''.join(withoutComment)
            inst=self.factory.create(withoutComment)
            print(inst)
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
