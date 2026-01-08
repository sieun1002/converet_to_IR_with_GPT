target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @sub_140002700(i8*)
declare i32 @sub_140002708(i8*, i8*, i32)

define i8* @sub_1400021B0(i8* %0) {
entry:
  %1 = call i64 @sub_140002700(i8* %0)
  %2 = icmp ugt i64 %1, 8
  br i1 %2, label %fail, label %cmz

cmz:
  %3 = load i8*, i8** @off_1400043C0, align 8
  %4 = bitcast i8* %3 to i16*
  %5 = load i16, i16* %4, align 1
  %6 = icmp eq i16 %5, 23117
  br i1 %6, label %after_mz, label %fail

after_mz:
  %7 = getelementptr i8, i8* %3, i64 60
  %8 = bitcast i8* %7 to i32*
  %9 = load i32, i32* %8, align 1
  %10 = sext i32 %9 to i64
  %11 = getelementptr i8, i8* %3, i64 %10
  %12 = bitcast i8* %11 to i32*
  %13 = load i32, i32* %12, align 1
  %14 = icmp eq i32 %13, 17744
  br i1 %14, label %check_magic, label %fail

check_magic:
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
  br i1 %22, label %fail, label %calc_first

calc_first:
  %23 = getelementptr i8, i8* %11, i64 20
  %24 = bitcast i8* %23 to i16*
  %25 = load i16, i16* %24, align 1
  %26 = zext i16 %25 to i64
  %27 = add i64 %26, 24
  %28 = getelementptr i8, i8* %11, i64 %27
  br label %loop

loop:
  %29 = phi i32 [ 0, %calc_first ], [ %34, %cont ]
  %30 = phi i8* [ %28, %calc_first ], [ %33, %cont ]
  %31 = call i32 @sub_140002708(i8* %30, i8* %0, i32 8)
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %ret_match, label %cont

cont:
  %33 = getelementptr i8, i8* %30, i64 40
  %34 = add i32 %29, 1
  %35 = getelementptr i8, i8* %11, i64 6
  %36 = bitcast i8* %35 to i16*
  %37 = load i16, i16* %36, align 1
  %38 = zext i16 %37 to i32
  %39 = icmp ult i32 %34, %38
  br i1 %39, label %loop, label %fail

ret_match:
  ret i8* %30

fail:
  ret i8* null
}