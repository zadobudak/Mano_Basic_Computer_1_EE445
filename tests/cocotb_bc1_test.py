import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge

#TRUE for printing signals
DEBUG = True

#CHANGE THE BELOW SIGNAL NAMES TO MATCH YOUR DESIGN!!!!!!!!!!!!!!!!!
def print_my_computer_please(dut):
    #Log whatever signal you want from the datapath, called before positive clock edge
    dut._log.info("************ DUT Signals ***************")
    # dut._log.info(f" PC: {dut.PC.value}\t {hex(dut.PC.value)}\n\
    # AR: {dut.AR.value}\t {hex(dut.AR.value)}\n\
    # IR: {dut.IR.value}\t {hex(dut.IR.value)}\n\
    # AC: {dut.AC.value}\t {hex(dut.AC.value)}\n\
    # DR: {dut.DR.value}\t {hex(dut.DR.value)}\n")
    dut._log.info(dut.PC.value)

@cocotb.test()
async def basic_computer_test(dut):
    """Try accessing the design."""
    dut.FGI.value = 0
    #Start the clock
    await cocotb.start(Clock(dut.clk, 10, 'us').start(start_high=False))
    #Get the fallin edge to work with
    clkedge = FallingEdge(dut.clk)
    
    #Check your design for however many cycles, assert at correct clock cycles
    for cycle in range(110):
        await clkedge
        
        #Log values if debugging
        if DEBUG:
            print_my_computer_please(dut)
            
        #Sımple match-case structure to test when needed
        #You should modify it according to your sample code
        # match cycle:
        #     case 2:
        #         assert dut.IR.value == 0x1234, "IR not loaded properly!"
        #     case 8:
        #         assert dut.AC.value == 123, "Direct LDA doesn't work!"
        #     case _:
        dut._log.info(f"Cycle count: {cycle} \n")
        input("Press Enter to continue...")
    
    dut._log.info("BC I test ended successfully!")