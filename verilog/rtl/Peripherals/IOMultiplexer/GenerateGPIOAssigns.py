import os

# It seems OEB == 0 means output, while OEB == 1 means input
IO_OUTPUT = "1'b0"
IO_INPUT  = "1'b1"

def GenerateVerilog(pinMap:list[tuple[int, str, str]], outputPath:str):

	outputLines = []
	finalLines = []

	if os.path.exists(outputPath):
		foundStart = False
		foundEnd = False
		with open(outputPath, "r") as outputFile:
			lines = outputFile.readlines()
			for l in lines:
				if not foundStart:
					outputLines.append(l)

					if "//----------------Pin Mapping Start----------------//" in l:
						foundStart = True
						outputLines.append("	//-------------Start of Generated Code-------------//\n\n")
				elif not foundEnd:
					if "//-----------------Pin Mapping End-----------------//" in l:
						foundEnd = True
						finalLines.append("	//--------------End of Generated Code--------------//\n")
						finalLines.append(l)
				else:
					finalLines.append(l)

	writeMapComment(outputLines, pinMap)

	for pin in pinMap:
		pinNumber, type, name = pin
		allowGPIO = False
		if '/' in name:
			parts = name.split('/')
			if len(parts) == 2 and parts[0].upper() == "GPIO":
				allowGPIO = True
				name = parts[1]
			else:
				print(f"Invalid name for pin 'IO{pinNumber}-{name}'")
				continue				

		name = name.upper()

		outputLines.append(f"	// IO{pinNumber:02}-PIN_{name}: {type}\n")
		outputLines.append(f"	localparam PIN_{name} = {pinNumber};\n")
		
		if type.upper() == "INPUT":
			if name == "JTAG" or name == "SDI" or name == "CSB" or name == "SCK":
				writeJTAGPin(outputLines, name, False)
			elif name.startswith("IRQ"):
				writeIRQPin(outputLines, name, allowGPIO)
			elif name.startswith("UART"):
				index = getIndex(name[4:-3])					
				if index >= 0 and name.endswith("_RX"):
					writeUARTPin(outputLines, name, index, False, allowGPIO)
				else:
					print(f"Invalid UART pin index for pin 'IO{pinNumber}-{name}'")
			elif name.startswith("SPI") and name.count('_') == 1:
				nameParts = name.split('_')
				pinType = nameParts[-1]
				index = getIndex(nameParts[0][3:])
				if index >= 0 and pinType == "MISO":
					writeSPIPin(outputLines, name, index, False, pinType, allowGPIO)
				else:
					print(f"Invalid SPI pin index for pin 'IO{pinNumber}-{name}'")
			else:
				writeUndefinedPin(outputLines, name, False, allowGPIO)
				print(f"No pin defined for input pin 'IO{pinNumber}-{name}'")
		elif type.upper() == "OUTPUT":
			if name == "SDO":
				writeJTAGPin(outputLines, name, True)
			elif name.startswith("FLASH") and name.count('_') == 1:
				nameParts = name.split('_')
				pinType = nameParts[-1]
				if pinType == "CSB" or pinType == "SCK":
					writeFlashPin(outputLines, name, True, pinType, allowGPIO)
				else:
					print(f"Invalid FLASH pin index for pin 'IO{pinNumber}-{name}'")
			elif name.startswith("UART"):
				index = getIndex(name[4:-3])					
				if index >= 0 and name.endswith("_TX"):
					writeUARTPin(outputLines, name, index, True, allowGPIO)
				else:
					print(f"Invalid UART pin index for pin 'IO{pinNumber}-{name}'")
			elif name.startswith("PWM"):
				index = getIndex(name[3:])
				if index >= 0:
					writePWMPin(outputLines, name, index, allowGPIO)
				else:
					print(f"Invalid PWM pin index for pin 'IO{pinNumber}-{name}'")
			elif name.startswith("SPI") and name.count('_') == 1:
				nameParts = name.split('_')
				pinType = nameParts[-1]
				index = getIndex(nameParts[0][3:])
				if index >= 0 and (pinType == "CLK" or pinType == "MOSI" or pinType == "CS"):
					writeSPIPin(outputLines, name, index, True, pinType, allowGPIO)
				else:
					print(f"Invalid SPI pin index for pin 'IO{pinNumber}-{name}'")
			elif name.startswith("VGA") and name.count('_') == 1:
				nameParts = name.split('_')
				pinType = nameParts[-1]
				if pinType == "VSYNC" or pinType == "HSYNC":
					writeVGAPin(outputLines, name, pinType, -1, allowGPIO)
				elif pinType[0] == "R" or pinType[0] == "G" or pinType[0] == "B":
					index = getIndex(pinType[1:])
					if index >= 0:
						writeVGAPin(outputLines, name, pinType[0], index, allowGPIO)
					else:
						print(f"Invalid VGA pin index for pin 'IO{pinNumber}-{name}'")
				else:
					print(f"Invalid VGA pin index for pin 'IO{pinNumber}-{name}'")
			elif name.startswith("BLINK"):
				index = getIndex(name[5:])
				if index >= 0:
					writeBlinkPin(outputLines, name, index, allowGPIO)
				else:
					print(f"Invalid BLINK pin index for pin 'IO{pinNumber}-{name}'")
			else:
				writeUndefinedPin(outputLines, name, True, allowGPIO)
				print(f"No pin defined for output pin 'IO{pinNumber}-{name}'")
		elif type.upper() == "INOUT":
			if name.startswith("FLASH") and name.count('_') == 1:
				nameParts = name.split('_')
				pinType = nameParts[-1]
				if pinType == "IO0" or pinType == "IO1":
					writeFlashPin(outputLines, name, False, pinType, allowGPIO)
				else:
					print(f"Invalid FLASH pin index for pin 'IO{pinNumber}-{name}'")
			else:
				writeUndefinedPin(outputLines, name, True, allowGPIO)
				print(f"No pin defined for inout pin 'IO{pinNumber}-{name}'")
		else:
			writeUndefinedPin(outputLines, name, False, allowGPIO)
			print(f"Unknown type '{type}' for pin 'IO{pinNumber}-{name}'")

		outputLines.append(f"	\n")

	outputLines.extend(finalLines)

	with open(outputPath, "w") as f:
		f.writelines(outputLines)

def getIndex(text:str) -> int:
	try:
		return int(text)
	except:
		return -1

def writeMapComment(outputLines:list[str], pinMap:list[tuple[int, str, str]]):
	maxIndex = 0
	for pin in pinMap:
		pinNumber, _, _ = pin
		if pinNumber > maxIndex:
			maxIndex = pinNumber
	
	sortedIndex:list[int] = [-1 for i in range(maxIndex + 1)]

	for i, pin in enumerate(pinMap):
		pinNumber, _, name = pin
		if sortedIndex[pinNumber] < 0:
			sortedIndex[pinNumber] = i
		else:
			print(f"Duplicate pin with index {pinNumber}. Original pin 'IO{pinNumber}-{name}' new pin 'IO{pinNumber}-{name}'")

	outputLines.append(f"	// Interface IO mapping\n")
	outputLines.append(f"	// GPIO0 (user1 side)\n")

	for i, index in enumerate(sortedIndex):
		if i == 19:
			outputLines.append(f"\n	// GPIO1 (user2 side)\n")

		if index < 0:
			outputLines.append(f"	// IO{i:02}: None\n")
		else:
			name = pinMap[index][2]
			if '/' in name:
				parts = name.split('/')				
				name = " or ".join(parts)
				name = name.replace("GPIO", f"GPIO{i:02}")
			outputLines.append(f"	// IO{i:02}: {name}\n")
	
	outputLines.append(f"	\n")

def writeJTAGPin(outputLines:list[str], pinName:str, isOutput:bool):
	if isOutput:
		outputLines.append(f"	assign gpio_input[PIN_{pinName}] = 1'b0;\n")
		outputLines.append(f"	assign io_out[PIN_{pinName}] = {pinName.lower()};\n")
		outputLines.append(f"	assign io_oeb[PIN_{pinName}] = {IO_OUTPUT};\n")
	else:
		outputLines.append(f"	assign gpio_input[PIN_{pinName}] = 1'b0;\n")
		outputLines.append(f"	assign io_out[PIN_{pinName}] = 1'b0;\n")
		outputLines.append(f"	assign io_oeb[PIN_{pinName}] = {IO_INPUT};\n")
		outputLines.append(f"	assign {pinName.lower()} = io_in[PIN_{pinName}];\n")

def writeIRQPin(outputLines:list[str], pinName:str, allowGPIO:bool):
	if allowGPIO:
		outputLines.append(f"	assign gpio_input[PIN_{pinName}] = irq_en ? 1'b0 : (gpio_oe[PIN_{pinName}] ? io_in[PIN_{pinName}] : 1'b0);\n")
		outputLines.append(f"	assign io_out[PIN_{pinName}] = irq_en ? 1'b0 : gpio_output[PIN_{pinName}];\n")
		outputLines.append(f"	assign io_oeb[PIN_{pinName}] = irq_en ? {IO_INPUT} : gpio_oe[PIN_{pinName}];\n")
		outputLines.append(f"	assign irq_in = irq_en ? io_in[PIN_{pinName}] : 1'b0;\n")
	else:
		outputLines.append(f"	assign gpio_input[PIN_{pinName}] = 1'b0;\n")
		outputLines.append(f"	assign io_out[PIN_{pinName}] = 1'b0;\n")
		outputLines.append(f"	assign io_oeb[PIN_{pinName}] = {IO_INPUT};\n")
		outputLines.append(f"	assign irq_in = io_in[PIN_{pinName}];\n")

def writeFlashPin(outputLines:list[str], pinName:str, isOutput:bool, pinType:str, allowGPIO:bool):
	if allowGPIO:
		if isOutput:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = flash_en ? 1'b0 : (gpio_oe[PIN_{pinName}] ? io_in[PIN_{pinName}] : 1'b0);\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = flash_en ? flash_{pinType.lower()} : gpio_output[PIN_{pinName}];\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = flash_en ? {IO_OUTPUT} : gpio_oe[PIN_{pinName}];\n")
		else:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = flash_en ? 1'b0 : (gpio_oe[PIN_{pinName}] ? io_in[PIN_{pinName}] : 1'b0);\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = flash_en ? flash_{pinType.lower()}_write : gpio_output[PIN_{pinName}];\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = flash_en ? !flash_{pinType.lower()}_we : gpio_oe[PIN_{pinName}];\n")
			outputLines.append(f"	assign flash_{pinType.lower()}_read = flash_en && !flash_{pinType.lower()}_we ? io_in[PIN_{pinName}] : 1'b0;\n")
	else:
		if isOutput:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = 1'b0;\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = flash_{pinType.lower()};\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = {IO_OUTPUT};\n")
		else:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = 1'b0;\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = flash_{pinType.lower()}_write;\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = !flash_{pinType.lower()}_we;\n")
			outputLines.append(f"	assign flash_{pinType.lower()}_read = !flash_{pinType.lower()}_we ? io_in[PIN_{pinName}] : 1'b0;\n")

def writeUARTPin(outputLines:list[str], pinName:str, uartIndex:int, isOutput:bool, allowGPIO:bool):
	if allowGPIO:
		if isOutput:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = uart_en[{uartIndex}] ? 1'b0 : (gpio_oe[PIN_{pinName}] ? io_in[PIN_{pinName}] : 1'b0);\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = uart_en[{uartIndex}] ? uart_tx[{uartIndex}] : gpio_output[PIN_{pinName}];\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = uart_en[{uartIndex}] ? {IO_OUTPUT} : gpio_oe[PIN_{pinName}];\n")
		else:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = uart_en[{uartIndex}] ? 1'b0 : (gpio_oe[PIN_{pinName}] ? io_in[PIN_{pinName}] : 1'b0);\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = uart_en[{uartIndex}] ? 1'b0 : gpio_output[PIN_{pinName}];\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = uart_en[{uartIndex}] ? {IO_INPUT} : gpio_oe[PIN_{pinName}];\n")
			outputLines.append(f"	assign uart_rx[{uartIndex}] = uart_en[{uartIndex}] ? io_in[PIN_{pinName}] : 1'b1;\n") # UART Rx defaults to high when not in use
	else:
		if isOutput:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = 1'b0;\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = uart_tx[{uartIndex}];\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = {IO_OUTPUT};\n")
		else:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = 1'b0;\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = 1'b0;\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = {IO_INPUT};\n")
			outputLines.append(f"	assign uart_rx[{uartIndex}] = io_in[PIN_{pinName}];\n")

def writePWMPin(outputLines:list[str], pinName:str, pwmIndex:int, allowGPIO:bool):
	if allowGPIO:
		outputLines.append(f"	assign gpio_input[PIN_{pinName}] = pwm_en[{pwmIndex}] ? 1'b0 : (gpio_oe[PIN_{pinName}] ? io_in[PIN_{pinName}] : 1'b0);\n")
		outputLines.append(f"	assign io_out[PIN_{pinName}] = pwm_en[{pwmIndex}] ? pwm_out[{pwmIndex}] : gpio_output[PIN_{pinName}];\n")
		outputLines.append(f"	assign io_oeb[PIN_{pinName}] = pwm_en[{pwmIndex}] ? {IO_OUTPUT} : gpio_oe[PIN_{pinName}];\n")
	else:
		outputLines.append(f"	assign gpio_input[PIN_{pinName}] = 1'b0;\n")
		outputLines.append(f"	assign io_out[PIN_{pinName}] = pwm_out[{pwmIndex}];\n")
		outputLines.append(f"	assign io_oeb[PIN_{pinName}] = {IO_OUTPUT};\n")

def writeSPIPin(outputLines:list[str], pinName:str, spiIndex:int, isOutput:bool, pinType:str, allowGPIO:bool):
	if allowGPIO:
		if isOutput:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = spi_en[{spiIndex}] ? 1'b0 : (gpio_oe[PIN_{pinName}] ? io_in[PIN_{pinName}] : 1'b0);\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = spi_en[{spiIndex}] ? spi_{pinType.lower()}[{spiIndex}] : gpio_output[PIN_{pinName}];\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = spi_en[{spiIndex}] ? {IO_OUTPUT} : gpio_oe[PIN_{pinName}];\n")
		else:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = spi_en[{spiIndex}] ? 1'b0 : (gpio_oe[PIN_{pinName}] ? io_in[PIN_{pinName}] : 1'b0);\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = spi_en[{spiIndex}] ? 1'b0 : gpio_output[PIN_{pinName}];\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = spi_en[{spiIndex}] ? {IO_INPUT} : gpio_oe[PIN_{pinName}];\n")
			outputLines.append(f"	assign spi_{pinType.lower()}[{spiIndex}] = spi_en[{spiIndex}] ? io_in[PIN_{pinName}] : 1'b0;\n")
	else:
		if isOutput:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = 1'b0;\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = spi_{pinType.lower()}[{spiIndex}];\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = {IO_OUTPUT};\n")
		else:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = 1'b0;\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = 1'b0;\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = {IO_INPUT};\n")
			outputLines.append(f"	assign spi_{pinType.lower()}[{spiIndex}] = io_in[PIN_{pinName}];\n")

def writeVGAPin(outputLines:list[str], pinName:str, pinType:str, pinIndex:int, allowGPIO:bool):
	if allowGPIO:
		if pinIndex >= 0:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = vgaEnable ? 1'b0 : (gpio_oe[PIN_{pinName}] ? io_in[PIN_{pinName}] : 1'b0);\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = vgaEnable ? vga_{pinType.lower()}[{pinIndex}] : gpio_output[PIN_{pinName}];\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = vgaEnable ?{IO_OUTPUT} : gpio_oe[PIN_{pinName}];\n")
		else:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = vgaEnable ? 1'b0 : (gpio_oe[PIN_{pinName}] ? io_in[PIN_{pinName}] : 1'b0);\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = vgaEnable ? vga_{pinType.lower()} : gpio_output[PIN_{pinName}];\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = vgaEnable ?{IO_OUTPUT} : gpio_oe[PIN_{pinName}];\n")
	else:
		if pinIndex >= 0:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = 1'b0;\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = vga_{pinType.lower()}[{pinIndex}];\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = {IO_OUTPUT};\n")
		else:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = 1'b0;\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = vga_{pinType.lower()};\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = {IO_OUTPUT};\n")

def writeBlinkPin(outputLines:list[str], pinName:str, blinkIndex:int, allowGPIO:bool):
	if allowGPIO:
		outputLines.append(f"	assign gpio_input[PIN_{pinName}] = blinkEnabled ? 1'b0 : (gpio_oe[PIN_{pinName}] ? io_in[PIN_{pinName}] : 1'b0);\n")
		outputLines.append(f"	assign io_out[PIN_{pinName}] = blinkEnabled ? blink[{blinkIndex}] : gpio_output[PIN_{pinName}];\n")
		outputLines.append(f"	assign io_oeb[PIN_{pinName}] = blinkEnabled ? {IO_OUTPUT} : gpio_oe[PIN_{pinName}];\n")
	else:
		outputLines.append(f"	assign gpio_input[PIN_{pinName}] = 1'b0;\n")
		outputLines.append(f"	assign io_out[PIN_{pinName}] = blink[{blinkIndex}];\n")
		outputLines.append(f"	assign io_oeb[PIN_{pinName}] = {IO_OUTPUT};\n")

def writeUndefinedPin(outputLines:list[str], pinName:str, isOutput:bool, allowGPIO:bool):
	if allowGPIO:
		if isOutput:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = gpio_oe[PIN_{pinName}] ? io_in[PIN_{pinName}] : 1'b0;\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = gpio_output[PIN_{pinName}];\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = gpio_oe[PIN_{pinName}];\n")
		else:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = gpio_oe[PIN_{pinName}] ? io_in[PIN_{pinName}] : 1'b0;\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = gpio_output[PIN_{pinName}];\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = gpio_oe[PIN_{pinName}];\n")
	else:
		if isOutput:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = 1'b0;\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] =  1'b0;\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = {IO_OUTPUT};\n")
		else:
			outputLines.append(f"	assign gpio_input[PIN_{pinName}] = 1'b0;\n")
			outputLines.append(f"	assign io_out[PIN_{pinName}] = 1'b0;\n")
			outputLines.append(f"	assign io_oeb[PIN_{pinName}] = {IO_INPUT};\n")

def main():
	pinMap = [
		( 0, "Input",  "JTAG"),
		( 1, "Output", "SDO"),
		( 2, "Input",  "SDI"),
		( 3, "Input",  "CSB"),
		( 4, "Input",  "SCK"),
		( 5, "Input",  "GPIO/UART1_RX"),
		( 6, "Output", "GPIO/UART1_TX"),
		( 7, "Input",  "GPIO/IRQ"),
		( 8, "Output", "FLASH_CSB"),
		( 9, "Output", "FLASH_SCK"),
		(10, "InOut",  "FLASH_IO0"),
		(11, "InOut",  "FLASH_IO1"),
		(12, "Output", "GPIO/PWM0"),
		(13, "Output", "GPIO/PWM1"),
		(14, "Output", "GPIO/PWM2"),
		(15, "Output", "GPIO/PWM3"),
		(16, "Output", "GPIO/PWM4"),
		(17, "Output", "GPIO/PWM5"),
		(18, "Output", "GPIO/PWM6"),
		(19, "Input",  "GPIO/UART2_RX"),
		(20, "Output", "GPIO/UART2_TX"),
		(21, "Output", "GPIO/PWM7"),
		(22, "Output", "GPIO/SPI0_CLK"),
		(23, "Output", "GPIO/SPI0_MOSI"),
		(24, "Input",  "GPIO/SPI0_MISO"),
		(25, "Output", "GPIO/SPI0_CS"),
		(26, "Input",  "GPIO/UART3_RX"),
		(27, "Output", "GPIO/UART3_TX"),
		(28, "Output", "GPIO/BLINK0"),
		(29, "Output", "GPIO/BLINK1"),
		(30, "Output", "VGA_R0"),
		(31, "Output", "VGA_R1"),
		(32, "Output", "VGA_G0"),
		(33, "Output", "VGA_G1"),
		(34, "Output", "VGA_B0"),
		(35, "Output", "VGA_B1"),
		(36, "Output", "VGA_VSYNC"),
		(37, "Output", "VGA_HSYNC")]

	GenerateVerilog(pinMap, "verilog/rtl/Peripherals/IOMultiplexer/IOMultiplexer_top.v")

if __name__ == "__main__":
	main()