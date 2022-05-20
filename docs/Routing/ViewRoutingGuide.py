from PIL import Image, ImageDraw

import os
import sys

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

def ViewGuideFile(fileName:str):
	if not os.path.exists(fileName):
		print(f"Can't find file '{fileName}' to render")
		return

	if os.path.splitext(fileName)[1] != ".guide":
		print(f"Can't find file '{fileName}' as it isn't a guide file")
		return

	data = ParseGuideFile(fileName)

	chipWidth = 2908.58
	chipHeight = 3497.92
	boarder = 100
	imageScale = 2

	imageWidth = int((chipWidth + boarder + boarder) * imageScale) + 1
	imageHeight = int((chipHeight + boarder + boarder) * imageScale) + 1
	
	imBase = Image.new(mode="RGBA", size=(imageWidth, imageHeight), color=(15, 15, 15, 255))
	draw = ImageDraw.Draw(imBase)

	def drawRect(r, c):
		px0 = (r[0] + boarder) * imageScale
		py0 = (chipHeight - r[1] + boarder) * imageScale
		px1 = (r[2] + boarder) * imageScale
		py1 = (chipHeight - r[3] + boarder) * imageScale
		draw.rectangle((px0, py0, px1, py1), fill=c, outline=None, width=0)

	def drawLayer(name, c):
		for	r in data[name]:
			drawRect(r, c)

	drawLayer("li1"  , (100, 100, 100, 127))
	drawLayer("met1" , (  0,   0, 255, 127))
	drawLayer("met2" , (255,   0, 255, 127))
	drawLayer("met3" , (  0, 255,   0, 127))
	drawLayer("met4" , (255,   0,   0, 127))
	drawLayer("met5" , (255, 255,   0, 127))
	drawLayer("other", (255, 255, 255, 127))

	# write to stdout
	imBase.save(f"{fileName}.jpg", "PNG")
	print(f"Saved output image: '{fileName}.jpg'")

def main():
	if len(sys.argv) > 1:
		for i in range(1, len(sys.argv)):
			item = sys.argv[i]
			if type(item) is str:
				ViewGuideFile(str(item))
			else:
				print(f"Invalid argument '{item}' but be a path to a guide file")
	else:
		ViewGuideFile("docs/Routing/17-global.guide")
		ViewGuideFile("docs/Routing/detailed.guide")

if __name__ == "__main__":
	main()