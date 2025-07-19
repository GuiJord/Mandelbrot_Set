import numpy as np 
import matplotlib.pyplot as plt

c_0 = 1+0j


L = 2
n = 2000

C = np.full((n,n),c_0)

real_array = np.linspace(-L,L,n)
im_array = np.linspace(-L,L,n)

X, Y = np.meshgrid(real_array, im_array)

# Combine into complex numbers: Z = x + i*y
Z = X + 1j * Y

Z_old = np.zeros((n,n))+0j


t_min = 100
tolerance = 2
vmax = t_min + 1

time_to_converge = np.zeros((n,n))
error_simple = np.zeros((n,n))

continue_map = np.full((n,n),True)


for t in range(1,t_min):
    print(t)
    for x in range(n):
        for y in range(n):
            if continue_map[x,y]:
                Z[x,y] = Z[x,y]*Z[x,y] + C[x,y]

                error_simple[x,y] = np.abs(Z[x,y]-Z_old[x,y])
        
                Z_old[x,y] = Z[x,y]

                if t > 2:
                    if error_simple[x,y] < tolerance:
                        time_to_converge[x,y] = t
                    elif Z[x,y] > 1e10:
                        time_to_converge[x,y] = vmax
                        continue_map[x,y] = False

plt.figure(figsize=(10,10))
plt.imshow(time_to_converge, cmap='viridis',vmin=2,vmax=vmax)
plt.axis('off')
plt.savefig('geometry.png',dpi = 500, bbox_inches='tight', pad_inches=0)
plt.close()