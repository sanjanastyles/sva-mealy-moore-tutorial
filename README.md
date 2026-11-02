# Stop Writing Testbenches, Start Writing Properties: An SVA Tutorial

Welcome to the repository for the SystemVerilog Assertions (SVA) tutorial! 

This project demonstrates how to transition from traditional simulation to property-based verification using a classic digital design problem: a Mealy Finite State Machine (FSM) sequence detector.

📖 **Read the full tutorial on Medium:** [Stop Writing Testbenches, Start Writing Properties: An SVA Tutorial](https://sharplikekatana.medium.com/stop-writing-testbenches-start-writing-properties-an-sva-tutorial-77a4afed0bf3)

## 🎯 What You Will Learn
1. The timing difference between Mealy and Moore FSMs.
2. How to write SystemVerilog Assertions (`assert property`).
3. The difference between Invariants, Safety properties, and Cover points.
4. **Mutation Testing (Bug Injection):** How to intentionally break a design to prove your testbench actually works.

## 📂 Repository Structure
*   `rtl/fsm_1001_good.sv`: The correct, synthesizable Mealy FSM.
*   `rtl/fsm_1001_buggy.sv`: The design with an injected 1-cycle delay bug.
*   `tb/tb_fsm_1001.sv`: The testbench containing the stimulus, clock generation, and the `bind` statement connecting our SVA module to the DUT.
*   `scripts/run.do`: A TCL script to automatically compile and run the simulation.

## 🚀 How to Run Locally (Siemens QuestaSim / ModelSim)
If you have QuestaSim installed, simply open the terminal in the root of this repository and run:

```bash
# To run the GOOD design (0 Errors expected)
vsim -c -do scripts/run.do

# To run the BUGGY design (2 Assertion Errors expected)
# (You will need to edit run.do to point to fsm_1001_buggy.sv, or just compile it manually)
