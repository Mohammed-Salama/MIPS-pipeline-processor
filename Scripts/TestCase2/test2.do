vsim -gui work.main
mem load -filltype value -filldata 0 -fillradix symbolic -skip 0 /main/DecodeStage/RegFile/regFile
mem load -filltype value -filldata 0 -fillradix symbolic -skip 0 /main/MemoryStage/Mem/memory
mem load -filltype value -filldata 0 -fillradix binary /main/FetchStage/instMem/memory(0)
mem load -filltype value -filldata 10 -fillradix binary /main/FetchStage/instMem/memory(1)
mem load -filltype value -filldata 0000000000000000 -fillradix binary /main/FetchStage/instMem/memory(2)
#######################################################################
mem load -filltype value -filldata 0001100010010000 -fillradix binary /main/FetchStage/instMem/memory(3)
mem load -filltype value -filldata 0001100100100000 -fillradix binary /main/FetchStage/instMem/memory(4)
mem load -filltype value -filldata 0001100110110000 -fillradix binary /main/FetchStage/instMem/memory(5)
mem load -filltype value -filldata 0001101001000000 -fillradix binary /main/FetchStage/instMem/memory(6)
mem load -filltype value -filldata 0010001010110000 -fillradix binary /main/FetchStage/instMem/memory(7)
mem load -filltype value -filldata 0010011000011000 -fillradix binary /main/FetchStage/instMem/memory(8)
mem load -filltype value -filldata 0010101101011000 -fillradix binary /main/FetchStage/instMem/memory(9)
mem load -filltype value -filldata 0010111001111000 -fillradix binary /main/FetchStage/instMem/memory(10)
mem load -filltype value -filldata 1011000100100000 -fillradix binary /main/FetchStage/instMem/memory(11)
mem load -filltype value -filldata 1111111111111111 -fillradix binary /main/FetchStage/instMem/memory(12)
mem load -filltype value -filldata 0010010100010100 -fillradix binary /main/FetchStage/instMem/memory(13)

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


force -freeze sim:/main/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/main/rst 1 0
run
force -freeze sim:/main/rst 0 0
run
run
run
force -freeze sim:/main/In_Port 'd5 0
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
run
run