; ModuleID = 'sub_1400021B0.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @sub_140002700()
declare i32 @sub_140002708(i8*, i8*, i32)

define i8* @sub_1400021B0(i8* %0) {
entry:
  %1 = call i64 @sub_140002700()
  %2 = icmp ugt i64 %1, 8
  br i1 %2, label %fail, label %after_cmp

after_cmp:
  %3 = load i8*, i8** @off_1400043C0, align 8
  %4 = bitcast i8* %3 to i16*
  %5 = load i16, i16* %4, align 1
  %6 = icmp eq i16 %5, 23117
  br i1 %6, label %parse, label %fail

parse:
  %7 = getelementptr i8, i8* %3, i64 60
  %8 = bitcast i8* %7 to i32*
  %9 = load i32, i32* %8, align 1
  %10 = sext i32 %9 to i64
  %11 = getelementptr i8, i8* %3, i64 %10
  %12 = bitcast i8* %11 to i32*
  %13 = load i32, i32* %12, align 1
  %14 = icmp eq i32 %13, 17744
  br i1 %14, label %check_optmagic, label %fail

check_optmagic:
  %15 = getelementptr i8, i8* %11, i64 24
  %16 = bitcast i8* %15 to i16*
  %17 = load i16, i16* %16, align 1
  %18 = icmp eq i16 %17, 523
  br i1 %18, label %check_numsections_nonzero, label %fail

check_numsections_nonzero:
  %19 = getelementptr i8, i8* %11, i64 6
  %20 = bitcast i8* %19 to i16*
  %21 = load i16, i16* %20, align 1
  %22 = icmp eq i16 %21, 0
  br i1 %22, label %fail, label %prep_loop

prep_loop:
  %23 = getelementptr i8, i8* %11, i64 20
  %24 = bitcast i8* %23 to i16*
  %25 = load i16, i16* %24, align 1
  %26 = zext i16 %25 to i32
  %27 = zext i32 %26 to i64
  %28 = add i64 %27, 24
  %29 = getelementptr i8, i8* %11, i64 %28
  br label %loop

loop:
  %30 = phi i8* [ %29, %prep_loop ], [ %34, %cont2 ]
  %31 = phi i32 [ 0, %prep_loop ], [ %33, %cont2 ]
  %32 = call i32 @sub_140002708(i8* %30, i8* %0, i32 8)
  %iszero = icmp eq i32 %32, 0
  br i1 %iszero, label %success_return, label %cont1

success_return:
  ret i8* %30

cont1:
  %33 = add i32 %31, 1
  %34 = getelementptr i8, i8* %30, i64 40
  %35 = zext i16 %21 to i32
  %36 = icmp ult i32 %33, %35
  br i1 %36, label %cont2, label %fail

cont2:
  br label %loop

fail:
  ret i8* null
}