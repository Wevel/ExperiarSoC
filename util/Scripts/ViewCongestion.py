from PIL import Image, ImageDraw, ImageFont, ImageOps

import os
import sys
import json
import shutil
import glob
import re

from JSONWrapper import JSONWrapper
import Utility


def LoadCongestionFile(congestionFileName: str) -> JSONWrapper:
	if not os.path.exists(congestionFileName):
		print(f"Can't find congestion file '{congestionFileName}'")
		return JSONWrapper(congestionFileName, ".", ".", {})

	if os.path.splitext(congestionFileName)[1] != ".rpt":
		print(f"Can't find file '{congestionFileName}' as it isn't a report file")
		return JSONWrapper(congestionFileName, ".", ".", {})

	# File looks something like this:
	# violation type: Horizontal congestion
	# 	srcs:
	# 	congestion information: capacity:17 usage:20 overflow:3
	# 	bbox = ( 69, 82.8 ) - ( 75.9, 89.7) on Layer -
	# violation type: Horizontal congestion
	# 	srcs:
	# 	congestion information: capacity:17 usage:19 overflow:2
	# 	bbox = ( 55.2, 89.7 ) - ( 62.1, 96.6) on Layer -

	# Load bbox for each congestion
	data = {}
	file = Utility.FileReference(congestionFileName)
	file.Load()
	line = file.NextLine()
	while line is not None:
		if line.startswith("violation type: "):
			violationType = line[len("violation type: "):]
			if violationType not in data:
				data[violationType] = []
			line = file.NextLine()
			while line is not None:
				if line.startswith("bbox = "):
					# Use re to get bbox and layer line:
					# bbox = ( 55.2, 89.7 ) - ( 62.1, 96.6) on Layer -
					values = re.findall(r"[-+]?\d*\.\d+|\d+", line)
					layer = line.split(" on Layer ")[1].strip()
					if len(values) == 4:
						data[violationType].append({"x0": float(values[0]), "y0": float(values[1]), "x1": float(values[2]), "y1": float(values[3]), "layer": layer})
					else:
						print(f"Invalid bbox line '{line}'")
					break
				line = file.NextLine()
		line = file.NextLine()

	return JSONWrapper(congestionFileName, ".", ".", data)


def GetMacroBounds(positionX: float, positionY: float, width: float, height: float, rotation: str) -> tuple[float, float, float, float]:
	if rotation == "N" or rotation == "S" or rotation == "FN" or rotation == "FS":
		return (positionX, positionY, positionX + width, positionY + height)
	elif rotation == "E" or rotation == "W" or rotation == "FE" or rotation == "FW":
		return (positionX, positionY, positionX + height, positionY + width)
	else:
		print(f"Invalid rotation '{rotation}'")
		return (positionX, positionY, positionX + width, positionY + height)


def ViewCongestion(congestionFilePath: str, outputDir: str, baseName: str):
	if not os.path.exists(congestionFilePath):
		print(f"Can't find guide file '{congestionFilePath}' to render")
		return

	if os.path.splitext(congestionFilePath)[1] != ".rpt":
		print(f"Can't find file '{congestionFilePath}' as it isn't a report file")
		return

	congestionData = LoadCongestionFile(congestionFilePath)

	baseImagePaths = glob.glob(Utility.Join(outputDir, f"{baseName}_*.guide.png"))
	if len(baseImagePaths) == 0:
		print(f"Can't find base image '{baseName}'")
		return

	baseImage = Image.open(baseImagePaths[0])

	boarder = 100
	imageScale = 1

	def drawRect(d: ImageDraw.ImageDraw, r, c):
		px0 = int((r[0] + boarder) * imageScale)
		py0 = baseImage.height - int((r[1] + boarder) * imageScale)
		px1 = int((r[2] + boarder) * imageScale)
		py1 = baseImage.height - int((r[3] + boarder) * imageScale)
		d.rectangle((px0, py0, px1, py1), fill=c, outline=None, width=0)

	layerIm = baseImage.copy()
	layerDraw = ImageDraw.Draw(layerIm, "RGBA")
	drawRect(layerDraw, (0, 0, layerIm.width, layerIm.height), (0, 0, 0, 255))

	colour = (255, 0, 255, 200)
	count = 0

	# Draw congestion
	for congestionType in congestionData:
		for congestion in congestionData.GetEntry(congestionType):
			count += 1
			drawRect(layerDraw, (congestion.GetEntry("x0").value, congestion.GetEntry("y0").value, congestion.GetEntry("x1").value, congestion.GetEntry("y1").value), colour)

	if count == 0:
		return

	baseImage = Image.blend(baseImage, layerIm, colour[3] / 255.0)

	# write to stdout
	outputFileName = Utility.Join(outputDir, f"{baseName}_{os.path.split(congestionFilePath)[1]}.png")
	baseImage.save(f"{outputFileName}", "PNG")
	print(f"Saved output image: '{outputFileName}'")


def main():
	if len(sys.argv) > 1:
		for i in range(1, len(sys.argv)):
			item = sys.argv[i]
			if type(item) is str:
				if os.path.splitext(item)[1] != ".json":
					guideFileName = str(item)
					if os.path.isdir(guideFileName):
						buildPath = Utility.GetMostRecentRunPath(guideFileName)
						if buildPath is None:
							print(f"No runs for '{guideFileName}'")
							return

						guideFileName = Utility.Join(buildPath, "tmp/routing/detailed.guide")
					ViewCongestion(guideFileName, "docs/Images/", "")
			else:
				print(f"Invalid argument '{item}' but be a path to a guide file")
	else:
		macroPaths = [f.path for f in os.scandir("openlane") if f.is_dir()]

		for item in macroPaths:
			macroName = os.path.split(item)[1]
			buildPath = Utility.GetMostRecentRunPath(item)
			if buildPath is None:
				print("No runs")
				return

			guideFileName = Utility.Join(buildPath, "reports/congestion.rpt")
			if os.path.exists(guideFileName):
				ViewCongestion(guideFileName, "docs/Images/", macroName)


if __name__ == "__main__":
	main()