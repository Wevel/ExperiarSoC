from PIL import Image, ImageDraw

import os
import sys
import json

from JSONWrapper import JSONWrapper
import Utility


def LoadJSON(macroPlacementFileName: str) -> JSONWrapper:
	if not os.path.exists(macroPlacementFileName):
		print(f"Can't find macro placement file '{macroPlacementFileName}'")
		return JSONWrapper(macroPlacementFileName, ".", ".", {})

	if os.path.splitext(macroPlacementFileName)[1] != ".json":
		print(f"Can't find file '{macroPlacementFileName}' as it isn't a json file")
		return JSONWrapper(macroPlacementFileName, ".", ".", {})

	with open(macroPlacementFileName, 'r') as f:
		data = json.load(f)

	return JSONWrapper(macroPlacementFileName, ".", ".", data)


def SaveJSON(root: JSONWrapper):
	with open(root.baseFileName, 'w') as f:
		json.dump(root.value, f, indent='\t')

	print(f"Saved '{root.baseFileName}'")


def GetMacroBounds(positionX, positionY, width, height, rotation) -> tuple[float, float, float, float]:
	if rotation == "N" or rotation == "S" or rotation == "FN" or rotation == "FS":
		return (positionX, positionY, positionX + width, positionY + height)
	elif rotation == "E" or rotation == "W" or rotation == "FE" or rotation == "FW":
		return (positionX, positionY, positionX + height, positionY + width)
	else:
		print(f"Invalid rotation '{rotation}'")
		return (positionX, positionY, positionX + width, positionY + height)


def PrintMacroPlacement(macroPlacementFileName: str):
	macroDir = os.path.dirname(macroPlacementFileName)
	root = LoadJSON(macroPlacementFileName)
	macroPlacement = root.GetEntry("macros")

	macroPositions = []
	pdnHooks = []
	obstructions = ["met5 0.0 0.0 2920.0 3520.0,"]
	for i, item in enumerate(macroPlacement):
		name = item.GetEntry("name").AsString()
		position = item.GetEntry("position")
		size = item.GetEntry("size")
		rotation = item.GetEntry("rotation")

		macroPositions.append(f"{name} {position.GetEntry('x').AsFloat()} {position.GetEntry('y').AsFloat()} {rotation.AsString()}\n")
		pdnHooks.append(f"{name} vccd1 vssd1 vccd1 vssd1,",)

		if item.HasEntry("obstructions"):
			bounds = GetMacroBounds(position.GetEntry("x").AsFloat(), position.GetEntry("y").AsFloat(), size.GetEntry("x").AsFloat(), size.GetEntry("y").AsFloat(), rotation.AsString())
			boundsString = f"{bounds[0]} {bounds[1]} {bounds[2]} {bounds[3]}"
			obstructionLayers = item.GetEntry("obstructions")
			for layer in obstructionLayers:
				obstructions.append(f"{layer.AsString()} {boundsString},")

	if len(pdnHooks) > 0:
		pdnHooks[-1] = pdnHooks[-1].strip(",")

	if len(obstructions) > 0:
		obstructions[-1] = obstructions[-1].strip(",")

	config = LoadJSON(Utility.Join(macroDir, "config.json"))
	config.SetEntry("FP_PDN_MACRO_HOOKS", pdnHooks)
	config.SetEntry("GRT_OBS", obstructions)
	SaveJSON(config)

	macroPositionsFilePath = Utility.Join(macroDir, "macro.cfg")
	with open(macroPositionsFilePath, "w") as f:
		f.writelines(macroPositions)

	print(f"Saved '{macroPositionsFilePath}'")


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