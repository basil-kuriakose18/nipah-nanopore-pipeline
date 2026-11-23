import sys
from PIL import Image, ImageOps
def flat(f): im = Image.open(f).convert("RGBA"); bg = Image.new("RGB", im.size, "white"); bg.paste(im, mask=im.split()[3]); ImageOps.expand(bg, border=60, fill="white").save(f)
for f in sys.argv[1:]: flat(f)
