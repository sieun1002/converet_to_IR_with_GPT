; ModuleID = 'pe_check'
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @sub_1400024F0(i8* %rcx) {
entry:
  %mzwptr = bitcast i8* %rcx to i16*
  %mz = load i16, i16* %mzwptr, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %is_mz, label %ret0

ret0:
  ret i32 0

is_mz:
  %offptr_i8 = getelementptr i8, i8* %rcx, i64 60
  %offptr = bitcast i8* %offptr_i8 to i32*
  %off = load i32, i32* %offptr, align 1
  %off64 = sext i32 %off to i64
  %ntptr_i8 = getelementptr i8, i8* %rcx, i64 %off64
  %sigptr = bitcast i8* %ntptr_i8 to i32*
  %sig = load i32, i32* %sigptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %magicptr_i8 = getelementptr i8, i8* %ntptr_i8, i64 24
  %magicptr = bitcast i8* %magicptr_i8 to i16*
  %magic = load i16, i16* %magicptr, align 1
  %is_peplus = icmp eq i16 %magic, 523
  %res = zext i1 %is_peplus to i32
  ret i32 %res
}