#!/bin/bash

read -p "Test: " test_number

test_dir=$"./testset/test_$test_number"

if [ ! -d './testset' ]; then
    mkdir './testset'
fi

if [ -d $test_dir ]; then
	echo "Directory '$test_dir' already exists."
  	exit 1
fi

mkdir $test_dir


python3 config.py<<<"$test_number"

read test_number colored< <(sed -n '1p' config.txt)

read n_images n_images_x n_images_y < <(sed -n '2p' config.txt)


gfortran -o mandelbrot_read mandelbrot_read.f95



for image_index in $(seq 1 "$n_images"); do
	echo "Image: $image_index/$n_images" 
	./mandelbrot_read<<<"$image_index"
	python3 plot_mandelbrot_colored.py <<<"$image_index"
done

for y_index in $(seq 1 $n_images_y); do
	first_index=$((($y_index-1)*$n_images_x+1))
	second_index=$((($y_index)*$n_images_x))
	stack_file=""$y_index"_stacked.png"
	convert $(seq -f "%g.png" $first_index $second_index) +append $stack_file
done

convert $(seq -f "%g_stacked.png" 1 $n_images_y) -append "final_image.png"

mv final_image.png $test_dir

if [ "${colored,,}" = "true" ]; then
	for y_index in $(seq 1 $n_images_y); do
		first_index=$((($y_index-1)*$n_images_x+1))
		second_index=$((($y_index)*$n_images_x))
		stack_file=""$y_index"_stacked.png"
		convert $(seq -f "%g_colored.png" $first_index $second_index) +append $stack_file
	done

	convert $(seq -f "%g_stacked.png" 1 $n_images_y) -append "final_image_colored.png"
	mv final_image_colored.png $test_dir

	for y_index in $(seq 1 $n_images_y); do
		first_index=$((($y_index-1)*$n_images_x+1))
		second_index=$((($y_index)*$n_images_x))
		stack_file=""$y_index"_stacked.png"
		convert $(seq -f "%g_colormix.png" $first_index $second_index) +append $stack_file
	done

	convert $(seq -f "%g_stacked.png" 1 $n_images_y) -append "final_image_colormix.png"
	mv final_image__colormix.png $test_dir
fi

rm *.png *.dat