from PIL import Image, ImageDraw

import os
import sys
import json

from JSONWrapper import JSONWrapper

def LoadMacroPlacementFile(macroPlacementFileName:str) -> JSONWrapper:
	if not os.path.exists(macroPlacementFileName):
		print(f"Can't find macro placement file '{macroPlacementFileName}'")
		return JSONWrapper(macroPlacementFileName, ".", ".", {})

	if os.path.splitext(macroPlacementFileName)[1] != ".json":
		print(f"Can't find file '{macroPlacementFileName}' as it isn't a json file")
		return JSONWrapper(macroPlacementFileName, ".", ".", {})

	with open(macroPlacementFileName, 'r') as f:
		data = json.load(f)

	return JSONWrapper(macroPlacementFileName, ".", ".", data)

def GetMacroBounds(positionX, positionY, width, height, rotation) -> tuple[float, float, float, float]:
	if rotation == "N" or rotation == "S" or rotation == "FN" or rotation == "FS":
		return (positionX, positionY, positionX + width, positionY + height)
	elif rotation == "E" or rotation == "W" or rotation == "FE" or rotation == "FW":
		return (positionX, positionY, positionX + height, positionY + width)
	else:
		print(f"Invalid rotation '{rotation}'")
		return (positionX, positionY, positionX + width, positionY + height)

def PrintMacroPlacement(macroPlacementFileName:str):
	root = LoadMacroPlacementFile(macroPlacementFileName)
	macroPlacement = root.GetEntry("macros")

	print(f"Macro PDN hooks for '{macroPlacementFileName}':")
	print("set ::env(FP_PDN_MACRO_HOOKS) \"\\")
	for i, item in enumerate(macroPlacement):
		name = item.GetEntry("name").AsString()
		if i == macroPlacement.EntryCount() - 1:
			print(f"	{name} vccd1 vssd1\"")
		else:
			print(f"	{name} vccd1 vssd1, \\")

	print()
	print(f"Macro obstructions for '{macroPlacementFileName}':")
	print("set ::env(GLB_RT_OBS) \"\\", end="")
	isFirst = True
	for item in macroPlacement:
		if item.HasEntry("obstructions"):
			name = item.GetEntry("name").AsString()
			position = item.GetEntry("position")
			size = item.GetEntry("size")
			rotation = item.GetEntry("rotation")
			bounds = GetMacroBounds(
				position.GetEntry("x").AsFloat(),
				position.GetEntry("y").AsFloat(),
				size.GetEntry("x").AsFloat(),
				size.GetEntry("y").AsFloat(),
				rotation.AsString())
			boundsString = f"{bounds[0]} {bounds[1]} {bounds[2]} {bounds[3]}"
			obstructions = item.GetEntry("obstructions")
			for obs in obstructions:
				if isFirst:
					isFirst = False
					print(f"\n	{obs.AsString()} {boundsString}", end="")
				else:
					print(f",\\\n	{obs.AsString()} {boundsString}", end="")
	print("\"")

	print()
	print(f"Macro placement for '{macroPlacementFileName}':")
	for item in macroPlacement:
		name = item.GetEntry("name").AsString()
		position = item.GetEntry("position")
		rotation = item.GetEntry("rotation").AsString()
		print(f"{name} {position.GetEntry('x').AsFloat()} {position.GetEntry('y').AsFloat()} {rotation}")

def main():
	if len(sys.argv) > 1:
		macroPlacementFile = ""
		for i in range(1, len(sys.argv)):
			item = sys.argv[i]
			if type(item) is str:
				PrintMacroPlacement(item)
	else:
		PrintMacroPlacement("openlane/user_project_wrapper/macros.json")

if __name__ == "__main__":
	main()