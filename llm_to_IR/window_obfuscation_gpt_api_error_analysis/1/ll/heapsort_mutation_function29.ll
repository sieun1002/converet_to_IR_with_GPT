target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002690() local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz_val = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz_val, 23117
  br i1 %is_mz, label %check_peptr, label %ret_zero

check_peptr:
  %lfanew_ptr_i8 = getelementptr inbounds i8, i8* %base_ptr, i64 60
  %lfanew_ptr = bitcast i8* %lfanew_ptr_i8 to i32*
  %lfanew_val = load i32, i32* %lfanew_ptr, align 1
  %lfanew_sext = sext i32 %lfanew_val to i64
  %pe_hdr_i8 = getelementptr inbounds i8, i8* %base_ptr, i64 %lfanew_sext
  %pe_sig_ptr = bitcast i8* %pe_hdr_i8 to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_zero

check_magic:
  %magic_ptr_i8 = getelementptr inbounds i8, i8* %pe_hdr_i8, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic_val = load i16, i16* %magic_ptr, align 1
  %is_pe_plus = icmp eq i16 %magic_val, 523
  br i1 %is_pe_plus, label %read_sections, label %ret_zero

read_sections:
  %numsect_ptr_i8 = getelementptr inbounds i8, i8* %pe_hdr_i8, i64 6
  %numsect_ptr = bitcast i8* %numsect_ptr_i8 to i16*
  %numsect16 = load i16, i16* %numsect_ptr, align 1
  %numsect32 = zext i16 %numsect16 to i32
  ret i32 %numsect32

ret_zero:
  ret i32 0
}