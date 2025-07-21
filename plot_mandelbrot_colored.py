import numpy as np 
import matplotlib.pyplot as plt

def interpret_dat_file(file_path):
    with open(file_path, 'r') as f:
        first_line = f.readline()
        nx, ny = map(int, first_line.strip().split())
    matrix = np.loadtxt(file_path, skiprows=1).astype(float)
    return nx,ny,matrix

image_index = int(input())

with open('config.txt', 'r') as file:
    first_line = file.readline()         # Read only the first line
    parts = first_line.strip().split()   # Split into separate words/numbers

colored = str(parts[1])

file = "mandelbrot.dat"
nx,ny,mandelbrot_map = interpret_dat_file(file)

plt.figure(figsize=(nx/300,ny/300))
plt.imshow(mandelbrot_map, cmap='bone',vmin=0,vmax=50)
plt.axis('off')
plt.savefig(f'{image_index}.png',dpi = 300, bbox_inches='tight', pad_inches=0)
plt.close()

if colored == "True":
    file = "mandelbrot_new.dat"
    nx,ny,matrix = interpret_dat_file(file)
    mandelbrot_map_colored = np.ma.masked_where(matrix == 0, matrix)

    plt.figure(figsize=(nx/300,ny/300))
    plt.imshow(mandelbrot_map_colored, cmap='magma',vmin=0,vmax=400)
    plt.axis('off')
    plt.savefig(f'{image_index}_colored.png',dpi = 300, bbox_inches='tight', pad_inches=0)
    plt.close()


    plt.figure(figsize=(nx/300,ny/300))
    plt.imshow(mandelbrot_map, cmap='bone',vmin=0,vmax=10)
    plt.imshow(mandelbrot_map_colored, cmap='magma',vmin=0,vmax=400)
    plt.axis('off')
    plt.savefig(f'{image_index}_colormix.png',dpi = 300, bbox_inches='tight', pad_inches=0)
    plt.close()