; ModuleID = 'pecheck'
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @sub_1400024F0(i8* %p) {
entry:
  %p_i16ptr = bitcast i8* %p to i16*
  %mzw = load i16, i16* %p_i16ptr, align 1
  %is_mz = icmp eq i16 %mzw, 23117
  br i1 %is_mz, label %if_mz, label %ret0

ret0:
  ret i32 0

if_mz:
  %off_ptr = getelementptr i8, i8* %p, i64 60
  %off_ptr32 = bitcast i8* %off_ptr to i32*
  %e_lfanew = load i32, i32* %off_ptr32, align 1
  %e_lfanew64 = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %p, i64 %e_lfanew64
  %pe_sig_ptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptri8 = getelementptr i8, i8* %pehdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptri8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  %res = zext i1 %is_pe32plus to i32
  ret i32 %res
}