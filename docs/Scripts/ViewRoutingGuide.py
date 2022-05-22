from PIL import Image, ImageDraw, ImageFont, ImageOps

import os
import sys
import json

from JSONWrapper import JSONWrapper

def ParseGuideFile(fileName:str) -> dict[str, list[tuple[float, float, float, float]]]:
	if not os.path.exists(fileName) or os.path.splitext(fileName)[1] != ".guide":
		return {}

	with open(fileName, "r") as f:
		lines = f.readlines()

	data = { "other": [] }
	
	for l in lines:
		parts = l.strip().split(' ')
		if len(parts) == 5:
			if parts[4] not in [parts[4]]:
				print(f"Found unknown layer type '{parts[4]}'")
				parts[4] = "other"
			if parts[4] not in data:
				data[parts[4]] = []
			data[parts[4]].append((float(parts[0]) * 0.001, float(parts[1]) * 0.001, float(parts[2]) * 0.001, float(parts[3]) * 0.001))

	return data

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

def GetMacroBounds(positionX:float, positionY:float, width:float, height:float, rotation:str) -> tuple[float, float, float, float]:
	if rotation == "N" or rotation == "S" or rotation == "FN" or rotation == "FS":
		return (positionX, positionY, positionX + width, positionY + height)
	elif rotation == "E" or rotation == "W" or rotation == "FE" or rotation == "FW":
		return (positionX, positionY, positionX + height, positionY + width)
	else:
		print(f"Invalid rotation '{rotation}'")
		return (positionX, positionY, positionX + width, positionY + height)

def DrawText(image, bounds:tuple[float, float, float, float], text:str):
	width = abs(bounds[2] - bounds[0])
	height = abs(bounds[3] - bounds[1])

	fontSize = 200
	textWidth = width + 1
	while textWidth >  width:
		fnt = ImageFont.truetype("arial.ttf", fontSize)
		textWidth = fnt.getlength(text)
		fontSize -= 10

	rotated = False
	if fontSize < 100 and height > width:
		fontSizeAlt = 200
		textWidth = height + 1
		while textWidth >  height:
			fnt = ImageFont.truetype("arial.ttf", fontSizeAlt)
			textWidth = fnt.getlength(text)
			fontSizeAlt -= 10
		if fontSizeAlt > fontSize:
			fontSize = fontSizeAlt
			rotated = True

	fnt = ImageFont.truetype("arial.ttf", fontSize)
	textSize = fnt.getsize(text)
	textIm=Image.new('L', textSize)
	textDraw = ImageDraw.Draw(textIm)
	textDraw.text((0.5 * textSize[0], 0.5 * textSize[1]), text, font=fnt, anchor="mm", align="center", fill=255)

	if rotated:
		w = textIm.rotate(90, expand=True)
	else:
		w = textIm

	px = bounds[0] + (0.5 * (width - w.width))
	py = bounds[3] + (0.5 * (height - w.height))

	image.paste(ImageOps.colorize(w, "black", "white"), (int(px), int(py)), w)
	
def ViewGuideFile(guideFileName:str, macroPlacementFileName:str):
	if not os.path.exists(guideFileName):
		print(f"Can't find guide file '{guideFileName}' to render")
		return

	if os.path.splitext(guideFileName)[1] != ".guide":
		print(f"Can't find file '{guideFileName}' as it isn't a guide file")
		return

	data = ParseGuideFile(guideFileName)

	chipWidth = 2908.58
	chipHeight = 3497.92
	boarder = 100
	imageScale = 2

	imageWidth = int((chipWidth + boarder + boarder) * imageScale) + 1
	imageHeight = int((chipHeight + boarder + boarder) * imageScale) + 1
	
	imBase = Image.new(mode="RGBA", size=(imageWidth, imageHeight), color=(15, 15, 15, 255))
	draw = ImageDraw.Draw(imBase, "RGBA")

	textToDraw = []

	if macroPlacementFileName != "" and os.path.exists(macroPlacementFileName):
		root = LoadMacroPlacementFile(macroPlacementFileName)
		macroPlacement = root.GetEntry("macros")
		for item in macroPlacement:
			position = item.GetEntry("position")
			size = item.GetEntry("size")
			rotation = item.GetEntry("rotation")
			bounds = GetMacroBounds(
				position.GetEntry("x").AsFloat(),
				position.GetEntry("y").AsFloat(),
				size.GetEntry("x").AsFloat(),
				size.GetEntry("y").AsFloat(),
				rotation.AsString())
			px0 = (bounds[0] + boarder) * imageScale
			py0 = (chipHeight - bounds[1] + boarder) * imageScale
			px1 = (bounds[2] + boarder) * imageScale
			py1 = (chipHeight - bounds[3] + boarder) * imageScale
			draw.rectangle((px0, py0, px1, py1), fill=(50, 50, 50, 255), outline=(150, 150, 150, 255), width=5)

			if item.HasEntry("displayName"):
				textToDraw.append(((px0, py0, px1, py1), item.GetEntry("displayName").AsString()))			
	
	def drawRect(d, r, c):
		px0 = (r[0] + boarder) * imageScale
		py0 = (chipHeight - r[1] + boarder) * imageScale
		px1 = (r[2] + boarder) * imageScale
		py1 = (chipHeight - r[3] + boarder) * imageScale
		d.rectangle((px0, py0, px1, py1), fill=c, outline=None, width=0)

	def drawLayer(name, c):
		layerIm = imBase.copy()# Image.new(mode="RGBA", size=(imageWidth, imageHeight), color=(15, 15, 15, 255))
		layerDraw = ImageDraw.Draw(layerIm, "RGBA")

		if name in data:
			for	r in data[name]:
				drawRect(layerDraw, r, (c[0], c[1], c[2], 255))

		return Image.blend(imBase, layerIm, c[3] / 255.0)

	imBase = drawLayer("li1"  , (100, 100, 100, 200))
	imBase = drawLayer("met1" , (  0, 121, 198, 200))
	imBase = drawLayer("met2" , (164,   0, 164, 200))
	imBase = drawLayer("met3" , ( 30, 159,   0, 200))
	imBase = drawLayer("met4" , (205,  19,   5, 200))
	imBase = drawLayer("met5" , (239, 239,   0, 200))
	imBase = drawLayer("other", (255, 255, 255, 200))

	for item in textToDraw:
		DrawText(imBase, item[0], item[1])

	# write to stdout
	imBase.save(f"{guideFileName}.jpg", "PNG")
	print(f"Saved output image: '{guideFileName}.jpg'")

def main():
	if len(sys.argv) > 1:
		macroPlacementFile = ""
		for i in range(1, len(sys.argv)):
			item = sys.argv[i]
			if type(item) is str:
				if os.path.splitext(item)[1] == ".json":
					if macroPlacementFile == "":
						macroPlacementFile = item
					else:
						print("Multiple macro placement files specified")

		for i in range(1, len(sys.argv)):
			item = sys.argv[i]
			if type(item) is str:
				if os.path.splitext(item)[1] != ".json":
					ViewGuideFile(str(item), macroPlacementFile)
			else:
				print(f"Invalid argument '{item}' but be a path to a guide file")
	else:
		ViewGuideFile("docs/Scripts/detailed.guide", "openlane/user_project_wrapper/macros.json")

if __name__ == "__main__":
	main()