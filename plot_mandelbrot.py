import numpy as np 
import matplotlib.pyplot as plt

image_index = int(input())

def interpret_dat_file(file_path):
    with open(file_path, 'r') as f:
        first_line = f.readline()
        nx, ny = map(int, first_line.strip().split())
    matrix = np.loadtxt(file_path, skiprows=1).astype(float)
    return nx,ny,matrix

open("config.txt","r"):


file = "mandelbrot.dat"

nx,ny,matrix = interpret_dat_file(file)


plt.figure(figsize=(nx/200,ny/200))
plt.imshow(matrix, cmap='bone',vmin=0,vmax=100) #bone
plt.axis('off')
plt.savefig(f'{image_index}.png',dpi = 400, bbox_inches='tight', pad_inches=0)
plt.close()