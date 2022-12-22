import os
import re
from typing import TextIO
import multiprocessing as mp
import time

def CollateErrors(sourceLocation: str, outputLocation: str) -> None:
	macrosPaths = [f.path for f in os.scandir(sourceLocation) if f.is_dir()]
	processes = [mp.Process(target=CheckMacro, args=(macroPath, outputLocation)) for macroPath in macrosPaths]
	[process.start() for process in processes]
	[process.join() for process in processes]

def CheckMacro(macroPath: str, outputLocation: str) -> None:
	outputTypes = ["logs", "reports"]
	outputSections = ["synthesis", "routing", "placement", "floorplan", "finishing", "signoff"]
	macroName = os.path.basename(macroPath)

	buildPath = os.path.join(macroPath, "runs", macroName)
	macroOutputPath = os.path.join(outputLocation, macroName)
	if not os.path.exists(macroOutputPath):
		os.mkdir(macroOutputPath)

	errorOutputFilePath = os.path.join(macroOutputPath, "errors.log")
	if os.path.exists(errorOutputFilePath):
		os.remove(errorOutputFilePath)

	warningOutputFilePath = os.path.join(macroOutputPath, "warnings.log")
	if os.path.exists(warningOutputFilePath):
		os.remove(warningOutputFilePath)

	errorCount = 0
	warningCount = 0
	violationCount = 0

	errorOutputFile = None
	warningOutputFile = None

	try:
		errorOutputFile = open(errorOutputFilePath, "a")
		warningOutputFile = open(warningOutputFilePath, "a")

		if os.path.exists(buildPath):
			# Copy errors from file
			errorFilePath = os.path.join(buildPath, "errors.log")
			if os.path.exists(errorFilePath):
				with open(errorFilePath, "r") as f:
					lines = f.readlines()
					errorOutputFile.writelines(lines)
					errorCount += len(lines)

			# Copy warnings from file
			warningFilePath = os.path.join(buildPath, "warnings.log")
			if os.path.exists(warningFilePath):
				with open(warningFilePath, "r") as f:
					lines = f.readlines()
					warningOutputFile.writelines(lines)
					warningCount += len(lines)

			for dir in outputTypes:
				for section in outputSections:
					path = os.path.join(buildPath, dir, section)
					if os.path.exists(path):
						files = [f.path for f in os.scandir(path) if f.is_file() and (f.path.endswith(".log") or f.path.endswith(".rpt"))]

						for file in files:
							e, w, v = CheckFile(file, errorOutputFile, warningOutputFile)
							errorCount += e
							warningCount += w
							violationCount += v

	finally:
		if errorOutputFile is not None:
			errorOutputFile.close()
		if warningOutputFile is not None:
			warningOutputFile.close()

	print(f"Checking macro '{macroName}': ", end="")
	
	if errorCount == 0 and violationCount == 0 and warningCount == 0:
		if os.path.exists(buildPath):
			print("Ok")
		else:
			print("No runs")
	else:
		print("Found issues")
		if errorCount != 0:
			print(f"	\033[91mErrors: {errorCount}	")
		if violationCount != 0:
			print(f"	\033[91mViolations: {violationCount}\033[0m")
		if warningCount != 0:
			print(f"	\033[93mWarnings: {warningCount}\033[0m")

def CheckFile(fileName: str, errorFile: TextIO, warningFile: TextIO) -> tuple[int, int, int]:
	if not os.path.exists(fileName):
		return 0, 0, 0

	errorCount = 0
	warningCount = 0
	violationCount = 0

	with open(fileName, "r") as f:
		lines = f.readlines()

		for i, line in enumerate(lines):
			if re.search("(?<![_\\-.\\w])(error|errors|mismatch)(?![_\\-.\\w])", line, re.IGNORECASE) is not None or "(no matching " in line or "shorted" in line:
				if "Saving mag view with DRC errors" not in line and "Usage ERROR:" not in line and "CVC: Error output to" not in line and "Checking" not in line and "[InitialPlace]  Iter:" not in line and "No errors found." not in line and "Total errors = 0" not in line and "CVC: Model errors:          0" not in line and "CVC: Error Counts" not in line:
					errorFile.write(f"{fileName}[{i}]: {line.strip()}\n")
					errorCount += 1
			elif re.search("(?<![_\\-.\\w])(violated|violation|violations)(?![_\\-.\\w])", line, re.IGNORECASE) is not None:
				if "No hold violations found." not in line and "Found 0 net violations" not in line and "violation count 0" not in line and "Number of violations = 0" not in line and "violated: 0" not in line and "violations: 0" not in line:
					errorFile.write(f"{fileName}[{i}]: {line.strip()}\n")
					violationCount += 1
			elif "Warning: Calma reading is not undoable!  I hope that's OK." not in line and "already existed before reading GDS!" not in line and "has no liberty cell." not in line and "Parent cell lists instance of" not in line and "Character in instance name converted to underscore." not in line and "is a placeholder, treated as a black box." not in line and "[WARNING GRT-" not in line and "[WARNING TAP-" not in line and "[WARNING ORD-" not in line and "[WARNING STA-" not in line and "[WARNING IFP-" not in line and "[WARNING PSM-" not in line:
				if re.search("(?<![_\\-.\\w])(warning|warnings)(?![_\\-.\\w])", line, re.IGNORECASE) is not None:
					warningFile.write(f"{fileName}[{i}]: {line.strip()}\n")
					warningCount += 1

	return errorCount, warningCount, violationCount

def main():
	CollateErrors("openlane/", "docs/Logs/")

if __name__ == "__main__":
	main()
