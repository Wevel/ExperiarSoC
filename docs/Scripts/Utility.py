import dataclasses
from datetime import datetime
import os


def Join(path: str, *paths) -> str:
	return os.path.join(path, *paths).replace('\\', '/')


def GetMostRecentRunPath(macroPath: str) -> str | None:
	runsPath = Join(macroPath, "runs")
	if not os.path.exists(runsPath):
		return None

	possibleRuns = [os.path.split(f.path)[1] for f in os.scandir(runsPath) if f.is_dir()]
	if len(possibleRuns) == 0:
		return None

	runDateTimes = [datetime.strptime(item, r"%y_%m_%d_%H_%M") for item in possibleRuns]
	mostRecentIndex = max(range(len(runDateTimes)), key=runDateTimes.__getitem__)
	return Join(runsPath, possibleRuns[mostRecentIndex])


@dataclasses.dataclass
class FileReference:
	filePath: str
	_lines: list[str] = dataclasses.field(default_factory=list, init=False)
	_currentLine: int = dataclasses.field(default=0, init=False)
	_loaded: bool = dataclasses.field(default=False, init=False)

	@property
	def directory(self) -> str:
		return os.path.dirname(self.filePath)

	@property
	def extension(self) -> str:
		return os.path.splitext(self.filePath)[1]

	def ReplaceExtension(self, newExtension: str) -> "FileReference":
		return FileReference(os.path.splitext(self.filePath)[0] + newExtension)

	def Load(self) -> None:
		if self._loaded:
			return
		self._loaded = True

		if not self.Exists():
			raise FileNotFoundError(f"File '{self.filePath}' does not exist")

		with open(self.filePath, "r") as f:
			self._lines = f.readlines()

		self._currentLine = 0

	def IsLoaded(self) -> bool:
		return self._loaded

	def Exists(self) -> bool:
		return os.path.exists(self.filePath)

	def NextLine(self) -> str | None:
		if self._currentLine < len(self._lines):
			self._currentLine += 1
			return self._lines[self._currentLine - 1].strip()
		else:
			return None