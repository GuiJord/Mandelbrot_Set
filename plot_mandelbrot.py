import numpy as np 
import matplotlib.pyplot as plt

def interpret_dat_file(file_path):
    with open(file_path, 'r') as f:
        first_line = f.readline()
        nx, ny = map(int, first_line.strip().split())
    matrix = np.loadtxt(file_path, skiprows=1).astype(float)
    return nx,ny,matrix

file = "mandelbrot.dat"

nx,ny,matrix = interpret_dat_file(file)


plt.figure(figsize=(10,(ny/nx)*10))
plt.imshow(matrix, cmap='plasma',vmin=5,vmax=20)
plt.axis('off')
plt.savefig('mandelbrot_set.png',dpi = 100, bbox_inches='tight', pad_inches=0)
plt.close()