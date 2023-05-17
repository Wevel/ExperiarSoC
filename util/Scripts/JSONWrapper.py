class JSONWrapper:
	def __init__(self, baseFileName:str, dataPath:str, key:str|int, value) -> None:
		self.baseFileName = baseFileName
		self.dataPath = dataPath
		self.key = key
		self.value = value

	def __iter__(self):
		self.__index = 0
		if type(self.value) is list:
			self.__iterData = [ JSONWrapper(self.baseFileName, f"{self.dataPath}[{i}]", i, item) for i, item in enumerate(self.value)]
		elif type(self.value) is dict:
			#self.__iterData = [ MetaData.Entry(self.metaData, f"{self.dataPath}/{key}", item) for key, item in self.value.items()]
			self.__iterData = list(self.value.keys())
		else:
			raise Exception(f"Can't iterate over object of type '{type(self.value)}'")
		return self

	def __next__(self):
		if self.__index < len(self.__iterData):
			self.__index += 1
			return self.__iterData[self.__index - 1]
		else:
			raise StopIteration
	
	def EntryCount(self) -> int:
		if type(self.value) is dict:
			return len(self.value)
		elif type(self.value) is list:
			return len(self.value)
		return 0

	def HasEntry(self, key) -> bool:
		if type(self.value) is dict:
			return key in self.value
		elif type(self.value) is list:
			if type(key) is int:
				return key >= 0 and key < len(self.value)
		return False

	def SetEntry(self, key, value):
		if type(self.value) is dict:
			self.value[key] = value
		elif type(self.value) is list:
			if type(key) is int:
				if key >= 0 and key < len(self.value):
					self.value[key] = value
				else:
					self.value.append(value)
			else:
				raise Exception(f"Invalid list index for entry '{self.dataPath}[{key}]' in meta data '{self.baseFileName}'")
		else:
			raise Exception(f"Can't set entry '{self.dataPath}/{key}' to entry of type '{type(self.value)}' in meta data '{self.baseFileName}'")

	def GetEntry(self, key) -> "JSONWrapper":
		if type(self.value) is dict:
			if key in self.value:
				return JSONWrapper(self.baseFileName, f"{self.dataPath}/{key}", key, self.value[key])
			else:
				raise Exception(f"Missing entry '{self.dataPath}/{key}' in meta data '{self.baseFileName}'")
		elif type(self.value) is list:
			if type(key) is int:
				if key >= 0 and key < len(self.value):
					return JSONWrapper(self.baseFileName, f"{self.dataPath}[{key}]", key, self.value[key])
				else:
					raise Exception(f"List index out of range for entry '{self.dataPath}[{key}]' in meta data '{self.baseFileName}'")
			else:
				raise Exception(f"Invalid list index for entry '{self.dataPath}[{key}]' in meta data '{self.baseFileName}'")
		else:
			raise Exception(f"Can't get entry '{self.dataPath}/{key}' from entry of type '{type(self.value)}' in meta data '{self.baseFileName}'")

	def AsInt(self) -> int:
		if type(self.value) is int:
			return self.value
		else:
			raise Exception(f"Value '{self.dataPath}' must have type 'int' but found type '{type(self.value)}' in meta data '{self.baseFileName}'")

	def AsFloat(self) -> float:
		if type(self.value) is float:
			return self.value
		elif type(self.value) is int:
			return float(self.value)
		else:
			raise Exception(f"Value '{self.dataPath}' must have type 'float' but found type '{type(self.value)}' in meta data '{self.baseFileName}'")

	def AsString(self) -> str:
		if type(self.value) is str:
			return self.value
		else:
			raise Exception(f"Value '{self.dataPath}' must have type 'string' but found type '{type(self.value)}' in meta data '{self.baseFileName}'")

	def AsBool(self) -> bool:
		if type(self.value) is bool:
			return self.value
		else:
			raise Exception(f"Value '{self.dataPath}' must have type 'bool' but found type '{type(self.value)}' in meta data '{self.baseFileName}'")

	def AsList(self) -> list:
		if type(self.value) is list:
			return self.value
		else:
			raise Exception(f"Value '{self.dataPath}' must have type 'list' but found type '{type(self.value)}' in meta data '{self.baseFileName}'")

	def AsDict(self) -> dict:
		if type(self.value) is dict:
			return self.value
		else:
			raise Exception(f"Value '{self.dataPath}' must have type 'dict' but found type '{type(self.value)}' in meta data '{self.baseFileName}'")

	def AsParameter(self) -> float | int | str | bool:
		if type(self.value) in [float, int, str, bool]:
			return self.value
		else:
			raise Exception(f"Value '{self.dataPath}' must have type 'float' or 'int' or 'str' or 'bool' but found type '{type(self.value)}' in meta data '{self.baseFileName}'")