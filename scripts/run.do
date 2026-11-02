# run.do - QuestaSim Automation Script

# Create work library
vlib work
vmap work work

# Compile the GOOD design and Testbench
vlog rtl/fsm_1001_good.sv tb/tb_fsm_1001.sv

# Optimize with full visibility for assertions
vopt +acc=npr -o tb_opt tb_fsm_1001 -work work

# Run the simulation
vsim -c -do "run -all; quit" tb_opt
