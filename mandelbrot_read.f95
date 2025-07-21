module mandelbrot_mod
    implicit none
    real :: Lx_pos
    real :: Lx_neg

    real :: Ly_pos
    real :: Ly_neg

    integer :: nx
    ! integer, parameter :: ny = 1000

    integer :: tmax

    real :: Lx
    real :: hx
    real :: Ly
    real :: hy
    integer :: ny

    integer :: image_number,image_number_total
    integer :: test_number,x_div,y_div
    logical :: colored

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
    real :: C_re_0,C_im_0

    integer :: ios
contains 
    subroutine c_parameterized()
        Z_re = Z_re_0
        Z_im = Z_im_0
        C_re = (x-1)*hx+Lx_neg
        C_im = (y-1)*hy+Ly_neg
    end subroutine c_parameterized

    subroutine z_parameterized()
        Z_re = (x-1)*hx+Lx_neg
        Z_im = (y-1)*hy+Ly_neg
        C_re = C_re_0
        C_im = C_im_0
    end subroutine z_parameterized
end module mandelbrot_mod

program mandelbrot
    use mandelbrot_mod
    implicit none
    
    read(*,*) image_number

    open(unit=10, file='config.txt', status='old', action='read', iostat=ios)
    if (ios /= 0) then
        print *, "Error opening file."
        stop
    end if

    read(10,*) test_number,colored
    read(10,*) image_number_total,x_div,y_div
    read(10,*) tmax

    do x = 4,image_number_total+4
        if (x == image_number+3) then
            read(10, *) Lx_neg, Lx_pos, Ly_neg, Ly_pos, nx
            exit
        else
            read(10,*)
        end if
    end do
        
    close(10)



    Lx = Lx_pos - Lx_neg
    hx = (Lx_pos - Lx_neg)/nx
    Ly = Ly_pos - Ly_neg

    hy = hx
    ny = ceiling((Ly_pos - Ly_neg)/hy)

    ! print*, "test_number", test_number, " tmax", tmax
    ! print*, "Image number", image_number, " nx", nx, " ny", ny
    ! print*, "Lx_neq", Lx_neg, "Lx_pos", Lx_pos
    ! print*, "Lx_neq", Ly_neg, "Lx_pos", Ly_pos

    allocate(color_map(nx,ny))
    
    color_map = 0
    

    C_re_0 = 0!0.65
    C_im_0 = 0!-0.65

    Z_re_0 = 0
    Z_im_0 = 0

    do x = 1,nx
        do y = 1,ny
            call c_parameterized()
            ! call z_parameterized()
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
        ! write(*,'(A,1F8.2,A)') "Progress: ", progress, '%'
    end do
    
    if (colored) then
        allocate(new_color_map(nx,ny))
        new_color_map = 0
        do x = 1,nx
            do y = 1,ny
                if (color_map(x,y) == 0) then
                    call c_parameterized()
                    ! call z_parameterized()
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
            ! write(*,'(A,1F8.2,A)') "Progress: ", progress, '%'
        end do
    end if

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

end program mandelbrot