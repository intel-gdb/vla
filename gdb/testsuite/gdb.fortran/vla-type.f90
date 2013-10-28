! Copyright 2013 Free Software Foundation, Inc.
!
! This program is free software; you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation; either version 2 of the License, or
! (at your option) any later version.
!
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with this program; if not, write to the Free Software
! Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

program vla_struct
  type :: one
    real, allocatable :: ivla (:, :, :)
  end type one
  type :: two
    real, allocatable :: ivla1 (:, :, :)
    real, allocatable :: ivla2 (:, :)
  end type two
  type :: three
    real :: ivar
    real, allocatable :: ivla (:)
  end type three
  type :: four
    real, allocatable :: ivla (:)
    real :: ivar
  end type four
  type :: five
    type(one) :: tone
  end type five

  type(one), target        :: onev
  type(two)                :: twov
  type(three)              :: threev
  type(four)               :: fourv
  type(five)               :: fivev
  type(one), allocatable   :: onevla(:, :)
  type(one), pointer       :: onep
  logical                  :: l
  integer                  :: i, j

  allocate (onev%ivla (11,22,33))         ! before-allocated
  l = allocated(onev%ivla)

  onev%ivla(:, :, :) = 1
  onev%ivla(1, 2, 3) = 123
  onev%ivla(3, 2, 1) = 321

  allocate (twov%ivla1 (5,12,99))         ! onev-filled
  l = allocated(twov%ivla1)
  allocate (twov%ivla2 (9,12))
  l = allocated(twov%ivla2)

  twov%ivla1(:, :, :) = 1
  twov%ivla1(1, 2, 3) = 123
  twov%ivla1(3, 2, 1) = 321

  twov%ivla2(:, :) = 1
  twov%ivla2(1, 2) = 12
  twov%ivla2(2, 1) = 21

  threev%ivar = 3.14                      ! twov-filled
  allocate (threev%ivla (20))
  l = allocated(threev%ivla)

  threev%ivla(:) = 1
  threev%ivla(5) = 42
  threev%ivla(14) = 24

  allocate (fourv%ivla (10))             ! threev-filled
  l = allocated(fourv%ivla)

  fourv%ivar = 3.14
  fourv%ivla(:) = 1
  fourv%ivla(2) = 2
  fourv%ivla(7) = 7


  allocate (onevla (10, 10))             ! fourv-filled
  do i = 1, 10
    do j = 1, 10
      allocate (onevla(i,j)%ivla(10,10,10))
      l = allocated(onevla(i,j)%ivla)

      onevla(i,j)%ivla(3, 6, 9) = 369
      onevla(i,j)%ivla(9, 3, 6) = 936
    end do
  end do

  allocate (fivev%tone%ivla (10, 10, 10))         ! onevla-filled
  l = allocated(fivev%tone%ivla)
  fivev%tone%ivla(:, :, :) = 1
  fivev%tone%ivla(1, 2, 3) = 123
  fivev%tone%ivla(3, 2, 1) = 321


  onev%ivla(:,:,:) = 2                            ! fivev-filled
  onep => onev

  ! dummy statement for bp
  l = allocated(fivev%tone%ivla)                  ! onep-associated
end program vla_struct
