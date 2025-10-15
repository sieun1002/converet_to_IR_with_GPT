; ModuleID = 'pe_check'
target triple = "x86_64-pc-windows-msvc"

define i32 @sub_1400025D0(i8* %rcx) {
entry:
  %p_mz_ptr = bitcast i8* %rcx to i16*
  %mz = load i16, i16* %p_mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_nt, label %ret0

check_nt:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %rcx, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew = sext i32 %e_lfanew32 to i64
  %nt_hdr = getelementptr i8, i8* %rcx, i64 %e_lfanew
  %sig_ptr = bitcast i8* %nt_hdr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  %retv = zext i1 %is_pe32plus to i32
  ret i32 %retv

ret0:
  ret i32 0
}