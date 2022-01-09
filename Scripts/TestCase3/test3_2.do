vsim -gui work.main
mem load -filltype value -filldata 0 -fillradix symbolic -skip 0 /main/DecodeStage/RegFile/regFile
mem load -filltype value -filldata 0 -fillradix symbolic -skip 0 /main/MemoryStage/Mem/memory
mem load -filltype value -filldata 0 -fillradix binary /main/FetchStage/instMem/memory(0)
mem load -filltype value -filldata 10 -fillradix binary /main/FetchStage/instMem/memory(1)
mem load -filltype value -filldata 0000000000000000 -fillradix binary /main/FetchStage/instMem/memory(2)
#######################################################################
mem load -filltype value -filldata 0001100100100000 -fillradix binary /main/FetchStage/instMem/memory(3)
mem load -filltype value -filldata 0001100110110000 -fillradix binary /main/FetchStage/instMem/memory(4)
mem load -filltype value -filldata 0001101001000000 -fillradix binary /main/FetchStage/instMem/memory(5)
mem load -filltype value -filldata 1100100010000000 -fillradix binary /main/FetchStage/instMem/memory(6)
mem load -filltype value -filldata 0000000000000101 -fillradix binary /main/FetchStage/instMem/memory(7)
mem load -filltype value -filldata 0100000010010010 -fillradix binary /main/FetchStage/instMem/memory(8)
mem load -filltype value -filldata 0100000100100100 -fillradix binary /main/FetchStage/instMem/memory(9)
mem load -filltype value -filldata 0100010010000000 -fillradix binary /main/FetchStage/instMem/memory(10)
mem load -filltype value -filldata 0100010100000000 -fillradix binary /main/FetchStage/instMem/memory(11)
mem load -filltype value -filldata 0001101011010000 -fillradix binary /main/FetchStage/instMem/memory(12)
mem load -filltype value -filldata 1101000001010100 -fillradix binary /main/FetchStage/instMem/memory(13)
mem load -filltype value -filldata 0000001000000000 -fillradix binary /main/FetchStage/instMem/memory(14)
mem load -filltype value -filldata 1101000001010010 -fillradix binary /main/FetchStage/instMem/memory(15)
mem load -filltype value -filldata 0000001000000001 -fillradix binary /main/FetchStage/instMem/memory(16)
mem load -filltype value -filldata 1100110111010000 -fillradix binary /main/FetchStage/instMem/memory(17)
mem load -filltype value -filldata 0000001000000001 -fillradix binary /main/FetchStage/instMem/memory(18)
mem load -filltype value -filldata 1100111001010000 -fillradix binary /main/FetchStage/instMem/memory(19)
mem load -filltype value -filldata 0000001000000000 -fillradix binary /main/FetchStage/instMem/memory(20)
mem load -filltype value -filldata 0100010110000000 -fillradix binary /main/FetchStage/instMem/memory(21)
mem load -filltype value -filldata 0010010010100110 -fillradix binary /main/FetchStage/instMem/memory(22)

add wave -position end  sim:/main/clk
add wave -position end  sim:/main/rst
add wave -position end  sim:/main/F_PC
add wave -position end  sim:/main/F_instruction
add wave -position end  sim:/main/FD_instruction
add wave -position end  sim:/main/In_Port
add wave -position end  sim:/main/Out_Port
add wave -position end  sim:/main/Flags
add wave -position end  sim:/main/DecodeStage/RegFile/regFile(0)
add wave -position end  sim:/main/DecodeStage/RegFile/regFile(1)
add wave -position end  sim:/main/DecodeStage/RegFile/regFile(2)
add wave -position end  sim:/main/DecodeStage/RegFile/regFile(3)
add wave -position end  sim:/main/DecodeStage/RegFile/regFile(4)
add wave -position end  sim:/main/DecodeStage/RegFile/regFile(5)
add wave -position end  sim:/main/DecodeStage/RegFile/regFile(6)
add wave -position end  sim:/main/DecodeStage/RegFile/regFile(7)
add wave -position end  sim:/main/REAL_SP
add wave -position end  sim:/main/SP_From_EX

force -freeze sim:/main/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/main/rst 1 0
run
force -freeze sim:/main/rst 0 0
run
run
run
force -freeze sim:/main/In_Port 'h19 0
run
force -freeze sim:/main/In_Port 'hFFFF 0
run
force -freeze sim:/main/In_Port 'hF320 0
run
run
run
run
run
run
force -freeze sim:/main/In_Port 'hFD60 0
run
run
run