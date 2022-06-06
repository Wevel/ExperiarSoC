
def AddTest(address):
	print(f"{'0x%08x' % address} -> {'0x%08x' % (address + 4)}")
	PrintInstructionData((address & 0xFFFFF000) | (0b0_0001 << 7) | 0b0110111)

def PrintInstructionData(data):
	print("0x%08x" % data)

def main():
	AddTest(0x0000_0000)
	AddTest(0x1000_0000)
	AddTest(0x1100_0000)
	AddTest(0x1200_0000)

	print("SRAM Commands:")
	PrintInstructionData((0b0000_0000_0000 << 20) | (0b0_0001 << 15) | (0b010 << 12) | (0b0_0011 << 7) | 0b0000011)
	PrintInstructionData((0b000_0000 << 25) | (0b0_0011 << 20) | (0b0_0001 << 15) | (0b010 << 12) | (0b0_0100 << 7) | 0b0100011)

	print("Flash Commands:")
	PrintInstructionData((0x0000_0000 & 0xFFFF_F000) | (0b0_0001 << 7) | 0b0110111)
	PrintInstructionData((0x1400_0000 & 0xFFFF_F000) | (0b0_0010 << 7) | 0b0110111)
	PrintInstructionData((0b0000_0000_0000 << 20) | (0b0_0010 << 15) | (0b010 << 12) | (0b0_0011 << 7) | 0b0000011)
	PrintInstructionData((0b000_0000 << 25) | (0b0_0011 << 20) | (0b0_0001 << 15) | (0b010 << 12) | (0b0_0000 << 7) | 0b0100011)

	print("Peripheral Commands:")
	PrintInstructionData((0x1303_1004 & 0xFFFF_F000) | (0b0_0001 << 7) | 0b0110111)
	PrintInstructionData((0x0000_4000 & 0xFFFF_F000) | (0b0_0011 << 7) | 0b0110111)
	PrintInstructionData((0b000_0000 << 25) | (0b0_0011 << 20) | (0b0_0001 << 15) | (0b010 << 12) | (0b0_0100 << 7) | 0b0100011)

if __name__ == "__main__":
	main()