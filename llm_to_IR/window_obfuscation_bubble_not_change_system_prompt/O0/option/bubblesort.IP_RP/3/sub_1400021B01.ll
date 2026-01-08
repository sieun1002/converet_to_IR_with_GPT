; ModuleID = 'sub_1400021B0'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @sub_140002700(i8*)

define i8* @sub_1400021B0(i8* %0) {
entry:
  %1 = call i64 @sub_140002700(i8* %0)
  %2 = icmp ugt i64 %1, 8
  br i1 %2, label %ret_zero, label %check_mz

ret_zero:
  ret i8* null

check_mz:
  %3 = load i8*, i8** @off_1400043C0, align 8
  %4 = bitcast i8* %3 to i16*
  %5 = load i16, i16* %4, align 1
  %6 = icmp eq i16 %5, 23117
  br i1 %6, label %nt_parse, label %ret_zero

nt_parse:
  %7 = getelementptr i8, i8* %3, i64 60
  %8 = bitcast i8* %7 to i32*
  %9 = load i32, i32* %8, align 1
  %10 = sext i32 %9 to i64
  %11 = getelementptr i8, i8* %3, i64 %10
  %12 = bitcast i8* %11 to i32*
  %13 = load i32, i32* %12, align 1
  %14 = icmp eq i32 %13, 17744
  br i1 %14, label %check_opt_magic, label %ret_zero

check_opt_magic:
  %15 = getelementptr i8, i8* %11, i64 24
  %16 = bitcast i8* %15 to i16*
  %17 = load i16, i16* %16, align 1
  %18 = icmp eq i16 %17, 523
  br i1 %18, label %check_numsects, label %ret_zero

check_numsects:
  %19 = getelementptr i8, i8* %11, i64 6
  %20 = bitcast i8* %19 to i16*
  %21 = load i16, i16* %20, align 1
  %22 = icmp eq i16 %21, 0
  br i1 %22, label %ret_zero, label %prep_loop

prep_loop:
  %23 = getelementptr i8, i8* %11, i64 20
  %24 = bitcast i8* %23 to i16*
  %25 = load i16, i16* %24, align 1
  %26 = zext i16 %25 to i64
  %27 = add i64 %26, 24
  %28 = getelementptr i8, i8* %11, i64 %27
  %29 = zext i16 %21 to i32
  br label %loop

loop:
  %30 = phi i32 [ 0, %prep_loop ], [ %36, %loop.next ]
  %31 = phi i8* [ %28, %prep_loop ], [ %35, %loop.next ]
  %32 = bitcast i64 (i8*)* @sub_140002700 to i8*
  %33 = getelementptr i8, i8* %32, i64 8
  %34 = bitcast i8* %33 to i32 (i8*, i8*, i32)*
  %call = call i32 %34(i8* %31, i8* %0, i32 8)
  %cmp = icmp eq i32 %call, 0
  br i1 %cmp, label %found, label %loop.next

found:
  ret i8* %31

loop.next:
  %35 = getelementptr i8, i8* %31, i64 40
  %36 = add i32 %30, 1
  %37 = icmp ult i32 %36, %29
  br i1 %37, label %loop, label %ret_zero
}