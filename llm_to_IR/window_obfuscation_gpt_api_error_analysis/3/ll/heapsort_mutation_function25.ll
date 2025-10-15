; ModuleID = 'sub_1400024F0'
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @sub_1400024F0(i8* nocapture readonly %rcx) local_unnamed_addr {
entry:
  %p_word = bitcast i8* %rcx to i16*
  %mz = load i16, i16* %p_word, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe_sig, label %ret_zero

check_pe_sig:
  %e_lfanew_ptr_i8 = getelementptr inbounds i8, i8* %rcx, i32 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew_val32 = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_val64 = sext i32 %e_lfanew_val32 to i64
  %nt_hdr_i8 = getelementptr inbounds i8, i8* %rcx, i64 %e_lfanew_val64
  %nt_sig_ptr = bitcast i8* %nt_hdr_i8 to i32*
  %pe_sig = load i32, i32* %nt_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_opt_magic, label %ret_zero

check_opt_magic:
  %opt_magic_ptr_i8 = getelementptr inbounds i8, i8* %nt_hdr_i8, i32 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_20b = icmp eq i16 %opt_magic, 523
  %res = zext i1 %is_20b to i32
  ret i32 %res

ret_zero:
  ret i32 0
}