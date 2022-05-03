import os
import sys
import io

def CollateErrors(sourceLocation:str, outputLocation:str):
	macrosPaths = [ f.path for f in os.scandir(sourceLocation) if f.is_dir() ]

	for macroPath in macrosPaths:
		CheckMacro(macroPath, outputLocation)

def CheckMacro(macroPath:str, outputLocation:str):
	outputDirNames = ["logs", "reports"]
	macroName = os.path.basename(macroPath)
	print(f"Checking macro '{macroName}': ", end="")

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

			# Check for synthesis problems
			for dir in outputDirNames:
				synthesisFilesPath = os.path.join(buildPath, dir, "synthesis")
				synthesisFiles = [ f.path for f in os.scandir(synthesisFilesPath) if f.is_file() and f.path.endswith(".log") ]
				for file in synthesisFiles:
					e, w, v = CheckFile(file, errorOutputFile, warningOutputFile)
					errorCount += e
					warningCount += w
					violationCount += v

			# Check for routing violations
			for dir in outputDirNames:
				routingFilesPath = os.path.join(buildPath, dir, "routing")
				routingFiles = [ f.path for f in os.scandir(routingFilesPath) if f.is_file() and f.path.endswith(".rpt") ]
				for file in routingFiles:
					e, w, v = CheckFile(file, errorOutputFile, warningOutputFile)
					errorCount += e
					warningCount += w
					violationCount += v

	finally:
		if errorOutputFile != None:
			errorOutputFile.close()
		if warningOutputFile != None:
			warningOutputFile.close()

	
	if errorCount == 0 and violationCount == 0 and warningCount == 0:
		print("Ok")
	else:
		print("Found issues")
		if errorCount != 0:
			print(f"	\033[91mErrors: {errorCount}\033[0m")
		if violationCount != 0:
			print(f"	\033[91mViolations: {violationCount}\033[0m")
		if warningCount != 0:
			print(f"	\033[93mWarnings: {warningCount}\033[0m")

def CheckFile(fileName:str, errorFile:io.TextIOWrapper, warningFile:io.TextIOWrapper) -> tuple[int, int, int]:
	if not os.path.exists(fileName):
		return 0, 0, 0

	errorCount = 0
	warningCount = 0
	violationCount = 0

	with open(fileName, "r") as f:
		lines = f.readlines()
		for i in range(len(lines)):
			lowerCaseLine = lines[i].lower()
			if "error" in lowerCaseLine:
				errorFile.write(f"{fileName}[{i}]: {lines[i].strip()}\n")
				errorCount += 1
			elif  "violated" in lowerCaseLine:
				errorFile.write(f"{fileName}[{i}]: {lines[i].strip()}\n")
				violationCount += 1
			elif "warning" in lowerCaseLine and "has no liberty cell." not in lines[i]:
				warningFile.write(f"{fileName}[{i}]: {lines[i].strip()}\n")
				warningCount += 1

	return errorCount, warningCount, violationCount

if __name__ == "__main__":
	CollateErrors("openlane/", "docs/Logs/")