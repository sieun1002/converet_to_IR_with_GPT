; ModuleID = 'pe_check_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @sub_1400024F0(i8* %rcx) {
entry:
  %0 = bitcast i8* %rcx to i16*
  %1 = load i16, i16* %0, align 1
  %2 = icmp eq i16 %1, 23117
  br i1 %2, label %check_pe, label %ret0

check_pe:
  %3 = getelementptr i8, i8* %rcx, i64 60
  %4 = bitcast i8* %3 to i32*
  %5 = load i32, i32* %4, align 1
  %6 = sext i32 %5 to i64
  %7 = getelementptr i8, i8* %rcx, i64 %6
  %8 = bitcast i8* %7 to i32*
  %9 = load i32, i32* %8, align 1
  %10 = icmp eq i32 %9, 17744
  br i1 %10, label %check_magic, label %ret0

check_magic:
  %11 = getelementptr i8, i8* %7, i64 24
  %12 = bitcast i8* %11 to i16*
  %13 = load i16, i16* %12, align 1
  %14 = icmp eq i16 %13, 523
  %15 = zext i1 %14 to i32
  ret i32 %15

ret0:
  ret i32 0
}