from PIL import Image
from pathlib import Path
img_dir = Path(__file__).resolve().parents[1] / 'images' / 'opt'
print('Converting in', img_dir)
for p in img_dir.glob('*.png'):
    out = p.with_suffix('.webp')
    try:
        im = Image.open(p).convert('RGBA')
        im.save(out, 'WEBP', quality=75, method=6)
        print('Saved', out)
    except Exception as e:
        print('Error', p, e)
print('Done')
