import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge

DEBUG = False
def print_my_computer_please(dut):
    dut._log.info("************ DUT Signals ***************")
    dut._log.info(f" \n  PC: {dut.PC.value}\t {hex(dut.PC.value)}\n\
    AR: {dut.AR.value}\t {hex(dut.AR.value)}\n\
    IR: {dut.IR.value}\t {hex(dut.IR.value)}\n\
    AC: {dut.AC.value}\t {hex(dut.AC.value)}\n\
    DR: {dut.DR.value}\t {hex(dut.DR.value)}\n \
    TR: {dut.TR.value}\t {hex(dut.TR.value)}\n ")

@cocotb.test()
async def basic_computer_test(dut):
    """Try accessing the design."""
    dut.FGI.value = 0
    #Start the clock
    await cocotb.start(Clock(dut.clk, 10, 'us').start(start_high=False))
    #Get the fallin edge to work with
    clkedge = FallingEdge(dut.clk)
    
    for cycle in range(110):
        await clkedge
        
        #Log values if debugging
        if DEBUG:
            print_my_computer_please(dut)
            
        # INTERRUPTS
        if cycle == 10 :
            dut.FGI.value = 1
            
        if cycle == 14:
            dut.FGI.value = 0
            

            
        match cycle:
            case 0:
                assert dut.PC.value == 0x000, "PC not initialized to 0!"
                assert dut.AR.value == 0x000, "AR not initialized to 0!"
                assert dut.IR.value == 0x0000, "IR not initialized to 0!"
                assert dut.AC.value == 0x0000, "AC not initialized to 0!"
                assert dut.DR.value == 0x0000, "DR not initialized to 0!"
                assert dut.TR.value == 0x0000, "TR not initialized to 0!"
            case 2: 
                assert dut.PC.value == 0x001, "PC not incremented!"
                assert dut.IR.value == 0x4009, "IR not loaded!"
            case 6: # BUN 0x0009
                assert dut.PC.value == 0x009, "PC not loaded!"
            case 7: #ION
                assert dut.IR.value == 0xf080, "IR not loaded for ION!"
            case 15: #LDA 003
                assert dut.AC.value == 0xaaaa, "LDA doesn't work!"
            case 17: #Interrupt
                assert dut.PC.value == 0x000, "PC not loaded for interrupt!"
                assert dut.TR.value == 0x000b, "TR not loaded from PC!"
            case 19: #Interrupt
                assert dut.PC.value == 0x001 , "Interrupt not working!"
            case 30: #Interrupt
                assert dut.IR.value == 0x7200, "Did not get back from interrupt!"
            case 33 : #CMA
                assert dut.AC.value == 0x5555, "CMA doesn't work!"
            case 42: #ADD 003
                assert dut.AC.value == 0x5557, "ADD doesn't work!"
            case 51: #ISZ
                assert dut.IR.value == 0xf040, "ISZ not loaded!"
            case 58: #CIR
                assert dut.AC.value == 0x2aab, "CIR doesn't work!"
                
            case 61: #CIL
                assert dut.AC.value == 0x5556, "CIL doesn't work!"
            case 65: #CLA
                assert dut.AC.value == 0x0000, "CLA doesn't work!"
            case 73: #INC
                assert dut.AC.value == 0x0001, "INC doesn't work!"
            case 78 : #SPA
                assert dut.PC.value == 0x018 , "SPA doesn't work!"
            case 107: #HLT
                assert dut.IR.value == 0x7001, "HLT not loaded! or HLT doesn't work!"
            


        dut._log.info(f"Cycle count: {cycle} \n")
        # input("Press Enter to continue...")
    
    dut._log.info("BC I test ended successfully!")
