; ModuleID = 'pe_utils'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002690() local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr_i16 = bitcast i8* %base_ptr to i16*
  %mz_val = load i16, i16* %mz_ptr_i16, align 1
  %is_mz = icmp eq i16 %mz_val, 23117
  br i1 %is_mz, label %chk_pe, label %ret_zero

chk_pe:
  %e_lfanew_ptr_i8 = getelementptr inbounds i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_hdr_i8 = getelementptr inbounds i8, i8* %base_ptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nt_hdr_i8 to i32*
  %sig_val = load i32, i32* %sig_ptr, align 1
  %is_pe_sig = icmp eq i32 %sig_val, 17744
  br i1 %is_pe_sig, label %chk_opt, label %ret_zero

chk_opt:
  %magic_ptr_i8 = getelementptr inbounds i8, i8* %nt_hdr_i8, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic_val = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic_val, 523
  br i1 %is_pe32plus, label %get_sections, label %ret_zero

get_sections:
  %sections_ptr_i8 = getelementptr inbounds i8, i8* %nt_hdr_i8, i64 6
  %sections_ptr = bitcast i8* %sections_ptr_i8 to i16*
  %sections_val = load i16, i16* %sections_ptr, align 1
  %sections_zext = zext i16 %sections_val to i32
  ret i32 %sections_zext

ret_zero:
  ret i32 0
}