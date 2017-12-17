module Homework
use :: omp_lib
contains
subroutine FindMaxCoordinates(A, x1, y1, x2, y2)
real(8), intent(in), dimension(:,:) :: A
real(8), dimension(size(A(:,1))) :: B
integer(4), intent(out) :: x1, y1, x2, y2
integer(4) tx1, tx2, ty1, ty2
integer(4) n, m, i, j, k, minn, maxx, x, y
real(8) pr, S, maxS, tmaxS

X=0; tx1=1; tx2=1; ty1=1; ty2=1; maxS=A(1,1); tmaxS=A(1,1)
m=size(A(:,1))
n=size(A(1,:))
!$omp parallel default(firstprivate) shared(A, x1, x2, y1, y2, maxS)
do i=(omp_get_thread_num()+1),n,omp_get_num_threads()

 do k=1,m
  B(k)=0
 enddo

 do j=i,n
  B=B+A(:,j)
  pr=B(1); x=1; y=1
  S=pr; minn=x; maxx=y
  do k=2,m
   if (B(k)>(B(k)+pr)) then
    x=k
    y=k
    pr=B(k)
   else
    y=k
    pr=B(k)+pr
   endif
   if (pr>S) then
    S=pr
    minn=x
    maxx=y
   endif
   !write(*,*)B,S
  enddo
  if (S>tmaxS) then
   tmaxS=S
   tx1=i
   tx2=j
   ty1=minn
   ty2=maxx
  endif
 enddo
 
enddo
  !$omp critical
  if ((tmaxS>maxS).AND.(tx1/=0)) then
   maxS=tmaxS
   y1=tx1
   y2=tx2
   x1=ty1
   x2=ty2
  endif
  !$omp end critical
!$omp end parallel
!write(*,*)maxS
end subroutine
end module
