from PIL import Image, ImageOps
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'images' / 'farlight 84.png'
OUT = ROOT / 'images' / 'opt'
OUT.mkdir(parents=True, exist_ok=True)

if not SRC.exists():
    print('Fonte não encontrada:', SRC)
    raise SystemExit(1)

print('Lendo:', SRC)
with Image.open(SRC) as im:
    im = im.convert('RGBA')
    # tamanhos: base 88x88, @2x 176x176
    size2x = (176, 176)
    size1x = (88, 88)
    # crop e redimensiona mantendo o foco central
    img2x = ImageOps.fit(im, size2x, Image.LANCZOS, centering=(0.5, 0.5))
    img1x = ImageOps.fit(im, size1x, Image.LANCZOS, centering=(0.5, 0.5))

    out2x = OUT / 'far@2x.png'
    out1x = OUT / 'far.png'
    img2x.save(out2x, 'PNG')
    img1x.save(out1x, 'PNG')
    print('Gerado:', out1x, out2x)

print('Pronto')
