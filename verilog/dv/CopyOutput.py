import os
import glob
import shutil

def CopySimulationFile(filePath:str, ignoreInvalidType:bool=False):
	if not os.path.exists(filePath):
		print(f"Can't find simulation file '{filePath}'")
		return

	if os.path.splitext(filePath)[1] != ".vcd":
		print(f"Invalid simulation file '{filePath}'")
		return

	directory = os.path.dirname(filePath)
	fileName = os.path.basename(filePath)

	if fileName.startswith("RTL"):
		destinationFilename = "waveRTL.vcd"
	elif fileName.startswith("GL"):
		destinationFilename = "waveGL.vcd"
	elif fileName.startswith("GL_SDF"):
		destinationFilename = "waveGL-SDF.vcd"
	else:
		if not ignoreInvalidType:
			print(f"Invalid simulation file '{filePath}'")
		return

	shutil.copy2(filePath, os.path.join(directory, destinationFilename))
	print(f"Copied '{filePath}' to '{destinationFilename}'")

def main():
	for file in glob.iglob("verilog/dv/**/*.vcd", recursive=True):
		CopySimulationFile(file.replace('\\', '/'), ignoreInvalidType=True)

if __name__ == "__main__":
	main()
	