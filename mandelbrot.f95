program test
    implicit none
    real, parameter :: Lx_pos = 0.5
    real, parameter :: Lx_neg = 1.5

    real, parameter :: Ly_pos = 0.5
    real, parameter :: Ly_neg = 0.5

    integer, parameter :: nx = 1000
    ! integer, parameter :: ny = 1000

    integer, parameter :: tmax = 1000

    real :: Lx = Lx_pos + Lx_neg
    real :: hx = (Lx_pos + Lx_neg)/nx
    real :: Ly = Ly_pos + Ly_neg
    ! real :: hy = (Ly_pos - Ly_neg)/ny
    real :: hy
    integer :: ny

    character(len=15) :: mandelbrot_format
    character(len=15) :: mandelbrot_new_format
    real :: progress
    integer, allocatable :: color_map(:,:)
    real, allocatable :: new_color_map(:,:)

    integer :: x,y,t
    real :: Z_re,Z_im
    real :: Z_re_,Z_im_
    real :: Z_re_0,Z_im_0
    real :: Z_abs
    real :: C_re,C_im

    hy = hx
    ny = int((Ly_pos + Ly_neg)/hy)

    allocate(color_map(nx,ny))
    allocate(new_color_map(nx,ny))

    color_map = 0
    new_color_map = 0

    C_re = 0
    C_im = 0

    Z_re_0 = 0
    Z_im_0 = 0

    do x = 1,nx
        do y = 1,ny
            Z_re = Z_re_0
            Z_im = Z_im_0
            C_re = (x-1)*hx-Lx_neg
            C_im = (y-1)*hy-Ly_neg
            do t = 1,tmax
                Z_re_ = (Z_re*Z_re-Z_im*Z_im) + C_re 
                Z_im_ = (2*Z_re*Z_im) + C_im 

                Z_re = Z_re_
                Z_im = Z_im_

                Z_abs = sqrt(Z_re*Z_re+Z_im*Z_im)
                if ( Z_abs > 1e2 ) then
                    color_map(x,y) = t
                    exit
                end if
            end do
        end do
        progress = 100.0*x/nx
        write(*,'(A,1F8.2,A)') "Progress: ", progress, '%'
    end do

    do x = 1,nx
        do y = 1,ny
            if (color_map(x,y) == 0) then
                Z_re = Z_re_0
                Z_im = Z_im_0
                C_re = (x-1)*hx-Lx_neg
                C_im = (y-1)*hy-Ly_neg
                do t = 1,tmax
                    Z_re_ = (Z_re*Z_re-Z_im*Z_im) + C_re 
                    Z_im_ = (2*Z_re*Z_im) + C_im 

                    Z_re = Z_re_
                    Z_im = Z_im_

                    Z_abs = sqrt(Z_re*Z_re+Z_im*Z_im)
                    new_color_map(x,y) = Z_abs + new_color_map(x,y)
                end do
            end if
        end do
        progress = 100.0*x/nx
        write(*,'(A,1F8.2,A)') "Progress: ", progress, '%'
    end do

    open(10,file='mandelbrot.dat',status='replace')
    close(10)

    open(10,file='mandelbrot.dat',position="append")
    write(10,'(I0,A,I0)') nx,' ',ny
    close(10)

    write(mandelbrot_format,'(A,I0,A,I0,A)') "(",nx,"I",int(log(real(tmax))+2),")"

    do y = 1,ny
        open(10,file='mandelbrot.dat',position="append")
        write(10,mandelbrot_format) color_map(:,y)
        close(10)
    end do

    open(10,file='mandelbrot_new.dat',status='replace')
    close(10)

    open(10,file='mandelbrot_new.dat',position="append")
    write(10,'(I0,A,I0)') nx,' ',ny
    close(10)

    write(mandelbrot_new_format,'(A,I0,A)') "(",nx,"G10.4)"

    do y = 1,ny
        open(10,file='mandelbrot_new.dat',position="append")
        write(10,mandelbrot_new_format) new_color_map(:,y)
        close(10)
    end do

end program test