import numpy as np 
import matplotlib.pyplot as plt

def interpret_dat_file(file_path):
    with open(file_path, 'r') as f:
        first_line = f.readline()
        nx, ny = map(int, first_line.strip().split())
    matrix = np.loadtxt(file_path, skiprows=1).astype(float)
    return nx,ny,matrix

file = "mandelbrot_new.dat"

nx,ny,matrix = interpret_dat_file(file)


plt.figure(figsize=(10,(ny/nx)*10))
masked_data = np.ma.masked_where(matrix == 0, matrix)

file = "mandelbrot.dat"

nx,ny,matrix = interpret_dat_file(file)

plt.imshow(matrix, cmap='bone',vmin=0,vmax=100)

plt.imshow(masked_data, cmap='magma',vmin=0,vmax=650) #bone

plt.axis('off')
plt.savefig('new_mandelbrot_set.png',dpi = 400, bbox_inches='tight', pad_inches=0)
plt.close()