; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_1400026D0(i64 %rcx) {
entry:
  %0 = load i8*, i8** @off_1400043A0, align 8
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 2
  %3 = icmp eq i16 %2, 23117
  br i1 %3, label %check_pe, label %ret0

check_pe:                                        ; preds = %entry
  %4 = getelementptr i8, i8* %0, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 4
  %7 = sext i32 %6 to i64
  %8 = getelementptr i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 4
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %after_pe, label %ret0

after_pe:                                        ; preds = %check_pe
  %12 = getelementptr i8, i8* %8, i64 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 2
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %cont1, label %ret0

cont1:                                           ; preds = %after_pe
  %16 = getelementptr i8, i8* %8, i64 6
  %17 = bitcast i8* %16 to i16*
  %18 = load i16, i16* %17, align 2
  %19 = icmp eq i16 %18, 0
  br i1 %19, label %ret0, label %cont2

cont2:                                           ; preds = %cont1
  %20 = getelementptr i8, i8* %8, i64 20
  %21 = bitcast i8* %20 to i16*
  %22 = load i16, i16* %21, align 2
  %23 = zext i16 %22 to i64
  %24 = getelementptr i8, i8* %8, i64 24
  %25 = getelementptr i8, i8* %24, i64 %23
  %26 = zext i16 %18 to i64
  %27 = mul i64 %26, 40
  %28 = getelementptr i8, i8* %25, i64 %27
  br label %loop

loop:                                             ; preds = %loop_continue, %cont2
  %curr = phi i8* [ %25, %cont2 ], [ %33, %loop_continue ]
  %rem = phi i64 [ %rcx, %cont2 ], [ %rem_after, %loop_continue ]
  %29 = getelementptr i8, i8* %curr, i64 39
  %30 = load i8, i8* %29, align 1
  %31 = and i8 %30, 32
  %32 = icmp ne i8 %31, 0
  br i1 %32, label %if_has20, label %after_test

if_has20:                                        ; preds = %loop
  %33rem_is_zero = icmp eq i64 %rem, 0
  br i1 %33rem_is_zero, label %ret0, label %dec

dec:                                             ; preds = %if_has20
  %34 = add i64 %rem, -1
  br label %after_test

after_test:                                      ; preds = %dec, %loop
  %rem_after = phi i64 [ %rem, %loop ], [ %34, %dec ]
  %33 = getelementptr i8, i8* %curr, i64 40
  %35 = icmp ne i8* %33, %28
  br i1 %35, label %loop_continue, label %exit

loop_continue:                                   ; preds = %after_test
  br label %loop

exit:                                            ; preds = %after_test
  ret i32 0

ret0:                                            ; preds = %if_has20, %cont1, %after_pe, %check_pe, %entry
  ret i32 0
}