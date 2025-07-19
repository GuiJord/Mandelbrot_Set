program mandelbrot
    implicit none
    real, parameter :: Lx_pos = -0.5
    real, parameter :: Lx_neg = -1.5

    real, parameter :: Ly_pos = 0.5
    real, parameter :: Ly_neg = -0.5

    integer, parameter :: nx = 1000
    integer, parameter :: ny = 1000

    integer, parameter :: tmax = 1000

    real, parameter :: tolerance = 1e-3

    real :: Z_im(nx,ny), Z_re(nx,ny)
    real :: Z_im_old(nx,ny), Z_re_old(nx,ny)
    real :: Z2_abs(nx,ny), Z2_abs_old(nx,ny)
    real :: C(nx,ny)

    integer, parameter :: cycle = 3
    integer :: cycle_pos
    real :: x_pos(nx,ny,cycle),y_pos(nx,ny,cycle)
    real :: x_med(nx,ny),y_med(nx,ny)

    logical :: continue_map(nx,ny)
    real :: error(nx,ny)
    real :: error_
    real :: error_medium

    integer :: t,x,y
    real :: x1,x2,x3,y1,y2,y3
    real :: xm,ym

    real :: Lx = Lx_pos - Lx_neg
    real :: hx = (Lx_pos - Lx_neg)/nx

    real :: Ly = Ly_pos - Ly_neg
    real :: hy = (Ly_pos - Ly_neg)/ny

    real :: z_im_,z_re_
    real :: z2_abs_,z2_abs_old_

    integer :: color_map(nx,ny)

    character(len=15) :: mandelbrot_format
    real :: progress

    C = 0

    x_pos = 0
    y_pos = 0

    x_med = 0
    y_med = 0

    xm = 1
    ym = 1

    error_medium = 1

    continue_map = .true.

    do x = 1,nx 
        do y = 1,ny
            Z_re(x,y) = (x-1)*hx+Lx_neg
            Z_im(x,y) = (y-1)*hy+Ly_neg
        end do
    end do      



    do t = 1,tmax
        cycle_pos = mod(t,cycle) + 1
        do x = 1,nx
            do y = 1,ny
                if (continue_map(x,y)) then
                    z_re_ = Z_re(x,y)
                    z_im_ = Z_im(x,y)

                    Z_re(x,y) = z_re_**2 - z_im_**2
                    Z_im(x,y) = 2*z_re_*z_im_

                    z2_abs_old_ = Z2_abs_old(x,y)
                    z2_abs_ = z_re_*z_re_ + z_im_*z_im_

                    if (z2_abs_ > 1e20) then
                        color_map(x,y) = tmax
                        continue_map(x,y) = .false.
                    end if

                    error_ = abs(z2_abs_ - z2_abs_old_)
                    error(x,y) = error_

                    x_pos(x,y,cycle_pos) = z_re_
                    y_pos(x,y,cycle_pos) = z_im_

                    if (t > 3) then
                        x1 = x_pos(x,y,1)
                        x2 = x_pos(x,y,2)
                        x3 = x_pos(x,y,3)
                        y1 = y_pos(x,y,1)
                        y2 = y_pos(x,y,2)
                        y3 = y_pos(x,y,3)

                        call medium_point(x1,x2,x3,y1,y2,y3,xm,ym)

                        error_medium = (xm - x_med(x,y))**2 + (ym - y_med(x,y))**2
                        x_med(x,y) = xm
                        y_med(x,y) = ym
                    end if

                    if (error_ < tolerance) then
                        color_map(x,y) = t
                        continue_map(x,y) = .false.
                    else if (error_medium < tolerance) then
                        color_map(x,y) = t
                        continue_map(x,y) = .false.
                        print*, 'here'
                    end if
                    


                    Z_re_old(x,y) = z_re_
                    Z_im_old(x,y) = z_im_
                    Z2_abs_old(x,y) = z2_abs_
                end if
            end do
        end do
        ! if (t < 10) then
        !     print*,x_pos(5,5,:),sum(x_pos(5,5,:))/3,x_med(5,5)
        ! end if
        progress = 100.0*real(t)/tmax
        write(*,'(A,1F8.2,A)') 'Progress: ', progress, '%'
    end do

    
    open(10,file='mandelbrot.dat',status='replace')
    close(10)

    write(mandelbrot_format,'(A,I0,A)') "(",nx,"I5)"

    open(10,file='mandelbrot.dat',position="append")
    write(10,'(I0,A,I0)') nx,' ',ny
    close(10)

    do y = 1,ny
        open(10,file='mandelbrot.dat',position="append")
        ! write(10,'(10G13.4)') Z2_abs_old(:,y)
        write(10,mandelbrot_format) color_map(:,y)
        close(10)
    end do

    ! open(10,file='x_pos.dat',status='replace')
    ! close(10)

    ! do y = 1,ny
    !     open(10,file='x_pos.dat',position="append")
    !     write(10,'(10G20.4)') x_pos(:,y,1)
    !     close(10)
    ! end do

    ! open(10,file='x_med.dat',status='replace')
    ! close(10)

    ! do y = 1,ny
    !     open(10,file='x_med.dat',position="append")
    !     write(10,'(10G20.4)') x_med(:,y)
    !     close(10)
    ! end do
    
    ! open(10,file='y_med.dat',status='replace')
    ! close(10)

    ! do y = 1,ny
    !     open(10,file='y_med.dat',position="append")
    !     write(10,'(10G20.4)') y_med(:,y)
    !     close(10)
    ! end do

    ! open(10,file='error_med.dat',status='replace')
    ! close(10)

    ! do y = 1,ny
    !     open(10,file='error_med.dat',position="append")
    !     write(10,'(10G20.4)') x_med(:,y)
    !     close(10)
    ! end do

end program mandelbrot

subroutine medium_point(x1,x2,x3,y1,y2,y3,xm,ym)
    real :: x1,x2,x3,y1,y2,y3
    real :: xm,ym

    xm = (x1+x2+x3)/3
    ym = (y1+y2+y3)/3
end subroutine medium_point