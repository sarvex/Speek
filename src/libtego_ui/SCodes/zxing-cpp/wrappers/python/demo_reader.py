import sys, zxingcpp
from PIL import Image

img = Image.open(sys.argv[1])
result = zxingcpp.read_barcode(img)
if result.valid:
	print(
		f"Found barcode:\n Text:    '{result.text}'\n Format:   {result.format}\n Position: {result.position}"
	)
else:
	print("Could not read barcode")
