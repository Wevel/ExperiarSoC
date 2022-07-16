import os
import shutil
import subprocess
import sys

from typing import Any

def RunShellCommand(cmd:list[str]) -> int | Any:
	process = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
	process.wait()
	if process.stdout != None:
		for line in process.stdout:
			print(line.decode("utf-8"), end="")
	return process.returncode

def RunArchTest(elfFilePath:str, signatureFilePath:str):
	# Run the simulator
	print(f"Running simulation")

	try:
		makeFilePath = os.path.dirname(os.path.abspath(__file__))
		shutil.copy2(os.path.join(makeFilePath, "coreArch_tb.v"), os.getcwd())
		shutil.copy2(os.path.join(makeFilePath, "Makefile"), os.getcwd())
		RunShellCommand(["make"]) # , "SIM=GL"
	except Exception as e:
		print(e)
		
	print(f"Simulation completed")

def RunArchTestLocal():
	print(f"Running simulation")

	try:
		RunShellCommand(["make"]) # , "SIM=GL"
	except Exception as e:
		print(e)
		
	print(f"Simulation completed")

def main():
	if len(sys.argv) > 1:
		args = {}
		for item in sys.argv[1:]:
			parts = item.split('=')
			if len(parts) == 2:
				args[parts[0]] = parts[1]
			else:
				print(f"Invalid arg 'item'")
		
		if "isa" in args:
			isa = args["isa"]
			
			if isa == "rv32i":
				if "elf" in args:
					elfFilePath = args["elf"]

					if "signature" in args:
						signatureFilePath = args["signature"]

						RunArchTest(elfFilePath, signatureFilePath)
					else:
						print(f"Missing argument 'signature'")
				else:
					print(f"Missing argument 'elf'")
			else:
				print(f"Invalid isa '{isa}' must be 'rv32i'")
		else:
			print(f"Missing argument 'isa'")
	else:
		RunArchTestLocal()
		
if __name__ == "__main__":
	main()