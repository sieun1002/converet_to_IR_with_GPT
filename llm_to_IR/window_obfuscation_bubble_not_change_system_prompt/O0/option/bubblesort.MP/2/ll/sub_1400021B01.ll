target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*

declare dso_local i64 @sub_140002700()
declare dso_local i32 @sub_140002708(i8*, i8*, i32)

define dso_local i8* @sub_1400021B0(i8* %0) {
entry:
  %1 = call i64 @sub_140002700()
  %2 = icmp ugt i64 %1, 8
  br i1 %2, label %fail, label %load_base

load_base:
  %3 = load i8*, i8** @off_1400043C0, align 8
  %4 = bitcast i8* %3 to i16*
  %5 = load i16, i16* %4, align 1
  %6 = icmp eq i16 %5, 23117
  br i1 %6, label %nt_prep, label %fail

nt_prep:
  %7 = getelementptr i8, i8* %3, i64 60
  %8 = bitcast i8* %7 to i32*
  %9 = load i32, i32* %8, align 1
  %10 = sext i32 %9 to i64
  %11 = getelementptr i8, i8* %3, i64 %10
  %12 = bitcast i8* %11 to i32*
  %13 = load i32, i32* %12, align 1
  %14 = icmp eq i32 %13, 17744
  br i1 %14, label %check_opt, label %fail

check_opt:
  %15 = getelementptr i8, i8* %11, i64 24
  %16 = bitcast i8* %15 to i16*
  %17 = load i16, i16* %16, align 1
  %18 = icmp eq i16 %17, 523
  br i1 %18, label %check_num, label %fail

check_num:
  %19 = getelementptr i8, i8* %11, i64 6
  %20 = bitcast i8* %19 to i16*
  %21 = load i16, i16* %20, align 1
  %22 = icmp eq i16 %21, 0
  br i1 %22, label %fail, label %init

init:
  %23 = getelementptr i8, i8* %11, i64 20
  %24 = bitcast i8* %23 to i16*
  %25 = load i16, i16* %24, align 1
  %26 = zext i16 %25 to i64
  %27 = add i64 %26, 24
  %28 = getelementptr i8, i8* %11, i64 %27
  br label %loop

loop:
  %29 = phi i32 [ 0, %init ], [ %35, %cont ]
  %30 = phi i8* [ %28, %init ], [ %34, %cont ]
  %31 = call i32 @sub_140002708(i8* %30, i8* %0, i32 8)
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %found, label %cont

found:
  ret i8* %30

cont:
  %33 = load i16, i16* %20, align 1
  %34 = getelementptr i8, i8* %30, i64 40
  %35 = add i32 %29, 1
  %36 = zext i16 %33 to i32
  %37 = icmp ult i32 %35, %36
  br i1 %37, label %loop, label %fail

fail:
  ret i8* null
}