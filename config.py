import math
import numpy as np
import matplotlib.pyplot as plt

test_number = int(input())

colored = False

Lx_pos = 1.3
Lx_neg = 2.2

Ly_pos = 1.5
Ly_neg = 1.5

nx_per_unit = 1000
tmax = 1000

Lx = Lx_pos + Lx_neg
Ly = Ly_pos + Ly_neg

nx_divisions_min = math.floor(Lx)
Lx_pos_floor = math.floor(Lx_pos)


ny_divisions_min = math.floor(Ly)
Ly_pos_floor = math.floor(Ly_pos)


Lx_neg_limits = np.linspace(-Lx_neg,nx_divisions_min-Lx_neg-1,nx_divisions_min)
Lx_pos_limits = Lx_neg_limits + 1

extra_x = Lx_pos-Lx_pos_limits[-1]

Ly_neg_limits = np.linspace(-Ly_neg,ny_divisions_min-Ly_neg-1,ny_divisions_min)
Ly_pos_limits = Ly_neg_limits + 1

extra_y = Ly_pos-Ly_pos_limits[-1]

if extra_x != 0:
    Lx_neg_limits = np.append(Lx_neg_limits,Lx_pos_limits[-1])
    Lx_pos_limits = np.append(Lx_pos_limits,Lx_neg_limits[-1]+extra_x)

if extra_y != 0:
    Ly_neg_limits = np.append(Ly_neg_limits,Ly_pos_limits[-1])
    Ly_pos_limits = np.append(Ly_pos_limits,Ly_neg_limits[-1]+extra_y)

nx_divisions = len(Lx_neg_limits)
ny_divisions = len(Ly_neg_limits)

n_images = nx_divisions*ny_divisions

resollution = (Lx_pos_limits-Lx_neg_limits)*nx_per_unit


# plt.figure(figsize=(10,10))
for i in range(nx_divisions):
    plt.vlines(Lx_neg_limits[i],-Ly_neg,Ly_pos)
    plt.vlines(Lx_pos_limits[i],-Ly_neg,Ly_pos)
for i in range(ny_divisions):
    plt.hlines(Ly_neg_limits[i],-Lx_neg,Lx_pos)
    plt.hlines(Ly_pos_limits[i],-Lx_neg,Lx_pos)


plt.axis('equal')
plt.savefig('divisions.png', bbox_inches='tight', pad_inches=0.1)
plt.close()


with open("config.txt","w") as f:
    f.write(f"{test_number} {colored}\n")
    f.write(f"{n_images} {nx_divisions} {ny_divisions}\n")
    f.write(f"{tmax}\n")
    for j in range(ny_divisions):
        for i in range(nx_divisions):    
            f.write(f"{Lx_neg_limits[i]} {Lx_pos_limits[i]} {Ly_neg_limits[j]} {Ly_pos_limits[j]} {int(resollution[i])}\n")