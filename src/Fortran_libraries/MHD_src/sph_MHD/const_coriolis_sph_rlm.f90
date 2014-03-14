!>@file   const_coriolis_sph_rlm.f90
!!@brief  module const_coriolis_sph_rlm
!!
!!@author H. Matsui
!!@date Programmed in June, 2007
!
!>@brief  Evaluate Coriolis term
!!
!!
!!@verbatim
!!      subroutine init_sum_coriolis_rlm
!!      subroutine sum_coriolis_rlm(ncomp_trans, sp_rlm)
!!      subroutine copy_coriolis_terms_rlm(ncomp_trans, sp_rlm)
!!@endverbatim
!
      module const_coriolis_sph_rlm
!
      use m_precision
!
      use m_constants
      use m_machine_parameter
      use m_control_parameter
      use m_physical_property
      use m_spheric_parameter
!
      implicit none
!
! -----------------------------------------------------------------------
!
      contains
!
! -----------------------------------------------------------------------
!
      subroutine init_sum_coriolis_rlm
!
      use m_boundary_params_sph_MHD
      use m_gaunt_coriolis_rlm
      use m_coriolis_terms_rlm
      use interact_coriolis_rlm
!
      integer(kind = kint) :: m, j_gl
!
!
      call alloacte_gaunt_coriolis_rlm(nidx_rlm(2))
      call alloc_coriolis_coef_tri_rlm(nidx_rlm(2))
      call allocate_d_coriolis_rlm
!
!
      idx_rlm_ICB = find_local_radius_rlm_address(nidx_rlm(1),          &
     &             idx_gl_1d_rlm_r, sph_bc_U%kr_in)
      idx_rlm_degree_zero = find_local_sph_rlm_address(nidx_rlm(2),     &
     &                          idx_gl_1d_rlm_j, izero)
      do m = -1, 1
        j_gl = ione*(ione+1) + m
        idx_rlm_degree_one(m) = find_local_sph_rlm_address(nidx_rlm(2), &
     &                          idx_gl_1d_rlm_j, j_gl)
      end do
!
!
      if(iflag_debug.eq.1) write(*,*) 'cal_gaunt_coriolis_rlm'
      call cal_gaunt_coriolis_rlm(l_truncation,                         &
     &    nidx_rlm(2), idx_gl_1d_rlm_j)
!
      if(iflag_debug.eq.1) write(*,*) 'interact_rot_coriolis_rlm'
      call interact_rot_coriolis_rlm(nidx_rlm(2))
!
      end subroutine init_sum_coriolis_rlm
!
! -----------------------------------------------------------------------
!
      subroutine sum_coriolis_rlm(ncomp_trans, sp_rlm)
!
      use t_boundary_params_sph_MHD
      use m_boundary_params_sph_MHD
      use m_coriolis_terms_rlm
      use sum_coriolis_terms_rlm
!
      integer(kind = kint), intent(in) :: ncomp_trans
      real(kind = kreal), intent(in) :: sp_rlm(ncomp_trans*nnod_rlm)
!
      if( iflag_4_coriolis .eq. id_turn_OFF) return
!
!
      call sum_rot_coriolis_rlm_10(ncomp_trans, sp_rlm)
!
      if(sph_bc_U%iflag_icb .eq. iflag_rotatable_ic) then
        call inner_core_rot_z_coriolis_rlm(ncomp_trans, sp_rlm)
      end if
!
!      call sum_div_coriolis_rlm_10(ncomp_trans, sp_rlm)
!      call sum_r_coriolis_bc_rlm_10(ncomp_trans, kr_in_U_rlm,          &
!     &    sp_rlm, d_cor_in_rlm)
!      call sum_r_coriolis_bc_rlm_10(ncomp_trans, kr_out_U_rlm,         &
!     &    sp_rlm, d_cor_out_rlm)
!
      end subroutine sum_coriolis_rlm
!
! -----------------------------------------------------------------------
!
      subroutine copy_coriolis_terms_rlm(ncomp_trans, sp_rlm)
!
      use m_coriolis_terms_rlm
!
      integer(kind = kint), intent(in) :: ncomp_trans
      real(kind = kreal), intent(inout) :: sp_rlm(ncomp_trans*nnod_rlm)
!
      if( iflag_4_coriolis .eq. id_turn_OFF) return
!
!
      call copy_rot_coriolis_rlm(ncomp_trans, sp_rlm)
!      call copy_div_coriolis_rlm(ncomp_trans, sp_rlm)
!      call copy_r_coriolis_bc_rlm(ncomp_trans, sp_rlm)
!
      end subroutine copy_coriolis_terms_rlm
!
! -----------------------------------------------------------------------
!
      end module  const_coriolis_sph_rlm