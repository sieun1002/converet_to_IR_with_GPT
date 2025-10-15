target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i8* @sub_1400026F0() {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %dos_ptr = bitcast i8* %base to i16*
  %dos = load i16, i16* %dos_ptr, align 1
  %is_mz = icmp eq i16 %dos, 23117
  br i1 %is_mz, label %check_pe, label %ret_null

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr_i8 = getelementptr i8, i8* %base, i64 %e_lfanew_sext
  %pehdr = bitcast i8* %pehdr_i8 to i32*
  %sig = load i32, i32* %pehdr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_null

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %pehdr_i8, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %ret_base, label %ret_null

ret_null:
  ret i8* null

ret_base:
  ret i8* %base
}