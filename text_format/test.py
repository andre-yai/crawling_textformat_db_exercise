import unittest
from text_format import limit_line_by_width

text_test = "and the earth. Now the earth was";
def sum(x,y):
	return x + y

class MyTest(unittest.TestCase):
	def test (self):
		self.assertEqual(sum(2,2),4)

	def test_format_justified(self):
		line = limit_line_by_width(text_test,1)[0];
		self.assertEqual(line,"and   the   earth.  Now  the  earth  was")
		self.assertEqual(len(line),40);

	def test_format_not_justified(self):
		line = limit_line_by_width(text_test,0)[0];
		self.assertEqual(line,"and the earth. Now the earth was")
		self.assertEqual(len(line),32);


unittest.main();