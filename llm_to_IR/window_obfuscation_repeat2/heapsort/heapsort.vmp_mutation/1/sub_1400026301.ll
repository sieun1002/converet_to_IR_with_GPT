; ModuleID = 'pe_check_module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i32 @sub_140002630() {
entry:
  %base = load i8*, i8** @off_1400043A0, align 1
  %base_i16 = bitcast i8* %base to i16*
  %mz = load i16, i16* %base_i16, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %mz_ok, label %ret_zero

ret_zero:
  ret i32 0

mz_ok:
  %ofs_ptr_i8 = getelementptr i8, i8* %base, i64 60
  %ofs_ptr = bitcast i8* %ofs_ptr_i8 to i32*
  %ofs = load i32, i32* %ofs_ptr, align 1
  %ofs64 = sext i32 %ofs to i64
  %pehdr = getelementptr i8, i8* %base, i64 %ofs64
  %sig_ptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %pe_ok, label %ret_zero

pe_ok:
  %magic_ptr_i8 = getelementptr i8, i8* %pehdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %read_sections, label %ret_zero

read_sections:
  %sec_ptr_i8 = getelementptr i8, i8* %pehdr, i64 6
  %sec_ptr = bitcast i8* %sec_ptr_i8 to i16*
  %sec = load i16, i16* %sec_ptr, align 1
  %zext = zext i16 %sec to i32
  ret i32 %zext
}