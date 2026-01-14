#!/usr/bin/env python3
import os
import sys
from pathlib import Path

# Tenta importar Pillow; instala se necessário
try:
    from PIL import Image
except Exception:
    import subprocess
    print('Pillow não encontrado. Instalando pillow...')
    subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'Pillow'])
    from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
IMG_DIR = ROOT / 'images'
OUT_DIR = IMG_DIR / 'opt'
OUT_DIR.mkdir(parents=True, exist_ok=True)

files = ['logo2.png','vava.png','cs2.png','blod.png','far.png']

print('Diretório de entrada:', IMG_DIR)
print('Diretório de saída:', OUT_DIR)

for fname in files:
    src = IMG_DIR / fname
    if not src.exists():
        print('Arquivo não encontrado:', src)
        continue
    name = src.stem
    try:
        with Image.open(src) as im:
            im = im.convert('RGBA')
            # define tamanho máximo
            max_dim = 300
            if 'logo' in name.lower():
                max_dim = 120
            # redimensiona mantendo proporção
            im.thumbnail((max_dim, max_dim), Image.LANCZOS)
            out_webp = OUT_DIR / f'{name}.webp'
            # salvar em WebP com boa compressão
            im.save(out_webp, 'WEBP', quality=75, method=6)
            print(f'Gerado: {out_webp.name} ({out_webp.stat().st_size//1024} KB)')
    except Exception as e:
        print('Erro processando', src, e)

print('Otimização concluída.')
