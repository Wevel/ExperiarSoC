import os
import sys

import odb


class OdbReader:

	def __init__(self, *args):
		self.db = odb.dbDatabase.create()
		if len(args) == 1:
			db_in = args[0]
			self.db = odb.read_db(self.db, db_in)
		elif len(args) == 2:
			lef_in, def_in = args
			if not (isinstance(lef_in, list) or isinstance(lef_in, tuple)):
				lef_in = [lef_in]
			for lef in lef_in:
				odb.read_lef(self.db, lef)
			if def_in is not None:
				odb.read_def(self.db, def_in)

		self.tech = self.db.getTech()
		self.chip = self.db.getChip()
		if self.chip is not None:
			self.block = self.db.getChip().getBlock()
			self.name = self.block.getName()
			self.rows = self.block.getRows()
			self.dbUnits = self.block.getDefUnits()
			self.instances = self.block.getInsts()

	def add_lef(self, new_lef):
		odb.read_lef(self.db, new_lef)


db = OdbReader("openlane/user_project_wrapper/runs/23_05_12_14_15/results/routing/user_project_wrapper.odb")
print(db)