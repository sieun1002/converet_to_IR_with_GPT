; ModuleID = 'pe_check'
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @sub_1400024F0(i8* %p) {
entry:
  %mz.ptr = bitcast i8* %p to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %after_mz, label %ret0

after_mz:
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %p, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew.ptr, align 1
  %off64 = sext i32 %e_lfanew32 to i64
  %nt.i8 = getelementptr i8, i8* %p, i64 %off64
  %nt.dword.ptr = bitcast i8* %nt.i8 to i32*
  %pe_sig = load i32, i32* %nt.dword.ptr, align 1
  %pe_ok = icmp eq i32 %pe_sig, 17744
  br i1 %pe_ok, label %check_magic, label %ret0

check_magic:
  %opt_hdr_magic.ptr.i8 = getelementptr i8, i8* %nt.i8, i64 24
  %opt_hdr_magic.ptr = bitcast i8* %opt_hdr_magic.ptr.i8 to i16*
  %magic = load i16, i16* %opt_hdr_magic.ptr, align 1
  %is_pe_plus = icmp eq i16 %magic, 523
  %res = zext i1 %is_pe_plus to i32
  ret i32 %res

ret0:
  ret i32 0
}