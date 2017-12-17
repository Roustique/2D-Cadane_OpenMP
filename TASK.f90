module Homework
use :: omp_lib
contains
subroutine FindMaxCoordinates(A, x1, y1, x2, y2)
real(8), intent(in), dimension(:,:) :: A
real(8), dimension(size(A(:,1))) :: B
integer(4), intent(out) :: x1, y1, x2, y2
integer(4) thread_x1, thread_x2, thread_y1, thread_y2
integer(4) Alength, Aheight, i, j, k, bottom_border, upper_border, x, y
real(8) previous_Summ, Summ, maxSumm, thread_maxSumm

thread_x1=1; thread_x2=1; thread_y1=1; thread_y2=1; maxSumm=A(1,1); thread_maxSumm=A(1,1)
Aheight=size(A(:,1))
Alength=size(A(1,:))
!$omp parallel default(firstprivate) shared(A, x1, x2, y1, y2, maxSumm)
do i=(omp_get_thread_num()+1),Alength,omp_get_num_threads()

 do k=1,Aheight
  B(k)=0
 enddo

 do j=i,Alength
  B=B+A(:,j)
  previous_Summ=B(1); x=1; y=1
  Summ=previous_Summ; bottom_border=x; upper_border=y
  do k=2,Aheight
   if (B(k)>(B(k)+previous_Summ)) then
    x=k
    y=k
    previous_Summ=B(k)
   else
    y=k
    previous_Summ=B(k)+previous_Summ
   endif
   if (previous_Summ>Summ) then
    Summ=previous_Summ
    bottom_border=x
    upper_border=y
   endif
   !write(*,*)B,S
  enddo
  if (Summ>thread_maxSumm) then
   thread_maxSumm=Summ
   thread_x1=i
   thread_x2=j
   thread_y1=bottom_border
   thread_y2=upper_border
  endif
 enddo
enddo
  !$omp critical
  if (thread_maxSumm>maxSumm) then
   maxSumm=thread_maxSumm
   y1=thread_x1
   y2=thread_x2
   x1=thread_y1
   x2=thread_y2
  endif
  !$omp end critical
!$omp end parallel
!write(*,*)maxS
end subroutine
end module
