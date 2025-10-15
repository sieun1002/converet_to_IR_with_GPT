target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002690() local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr_i8 = getelementptr inbounds i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_hdr_ptr_i8 = getelementptr inbounds i8, i8* %base_ptr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %nt_hdr_ptr_i8 to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptr_i8 = getelementptr inbounds i8, i8* %nt_hdr_ptr_i8, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %load_sections, label %ret0

load_sections:
  %num_sections_ptr_i8 = getelementptr inbounds i8, i8* %nt_hdr_ptr_i8, i64 6
  %num_sections_ptr = bitcast i8* %num_sections_ptr_i8 to i16*
  %num_sections16 = load i16, i16* %num_sections_ptr, align 1
  %num_sections32 = zext i16 %num_sections16 to i32
  ret i32 %num_sections32

ret0:
  ret i32 0
}