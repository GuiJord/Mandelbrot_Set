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


gfortran -o mandelbrot mandelbrot.f95
./mandelbrot
python3 plot_mandelbrot.py

rm mandelbrot.dat