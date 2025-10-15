; ModuleID = 'pecheck'
source_filename = "pecheck.ll"
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @sub_1400024F0(i8* %p) {
entry:
  %p_to_i16 = bitcast i8* %p to i16*
  %mz = load i16, i16* %p_to_i16, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %mz_ok, label %ret_zero

ret_zero:
  ret i32 0

mz_ok:
  %p_to_i32 = bitcast i8* %p to i32*
  %e_lfanew_ptr = getelementptr inbounds i32, i32* %p_to_i32, i64 15
  %e_lfanew_val = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew_val to i64
  %pe_hdr_ptr_i8 = getelementptr inbounds i8, i8* %p, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %pe_hdr_ptr_i8 to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %pe_ok, label %ret_zero

pe_ok:
  %opt_magic_off = getelementptr inbounds i8, i8* %pe_hdr_ptr_i8, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_off to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  %ret = zext i1 %is_pe32plus to i32
  ret i32 %ret
}