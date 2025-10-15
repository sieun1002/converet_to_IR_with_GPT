; ModuleID: 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002610(i8* %rcx) local_unnamed_addr {
entry:
  %0 = load i8*, i8** @off_1400043A0, align 8
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 1
  %3 = icmp eq i16 %2, 23117
  br i1 %3, label %check_pe, label %ret0

check_pe:                                           ; preds = %entry
  %4 = getelementptr i8, i8* %0, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 1
  %7 = sext i32 %6 to i64
  %8 = getelementptr i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 1
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %check_magic, label %ret0

check_magic:                                        ; preds = %check_pe
  %12 = getelementptr i8, i8* %8, i64 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 1
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %check_numsecs, label %ret0

check_numsecs:                                      ; preds = %check_magic
  %16 = getelementptr i8, i8* %8, i64 6
  %17 = bitcast i8* %16 to i16*
  %18 = load i16, i16* %17, align 1
  %19 = icmp eq i16 %18, 0
  br i1 %19, label %ret0, label %after_numsecs

after_numsecs:                                      ; preds = %check_numsecs
  %20 = getelementptr i8, i8* %8, i64 20
  %21 = bitcast i8* %20 to i16*
  %22 = load i16, i16* %21, align 1
  %23 = zext i16 %22 to i32
  %24 = zext i32 %23 to i64
  %25 = ptrtoint i8* %rcx to i64
  %26 = ptrtoint i8* %0 to i64
  %27 = sub i64 %25, %26
  %28 = getelementptr i8, i8* %8, i64 24
  %29 = getelementptr i8, i8* %28, i64 %24
  %30 = zext i16 %18 to i32
  %31 = zext i32 %30 to i64
  %32 = mul nuw i64 %31, 40
  %33 = getelementptr i8, i8* %29, i64 %32
  br label %loop

loop:                                              ; preds = %cont_loop, %after_numsecs
  %cur = phi i8* [ %29, %after_numsecs ], [ %next, %cont_loop ]
  %34 = icmp eq i8* %cur, %33
  br i1 %34, label %exit, label %check_section

check_section:                                      ; preds = %loop
  %35 = getelementptr i8, i8* %cur, i64 12
  %36 = bitcast i8* %35 to i32*
  %37 = load i32, i32* %36, align 1
  %38 = zext i32 %37 to i64
  %39 = icmp ult i64 %27, %38
  br i1 %39, label %cont_loop, label %check_upper

check_upper:                                        ; preds = %check_section
  %40 = getelementptr i8, i8* %cur, i64 8
  %41 = bitcast i8* %40 to i32*
  %42 = load i32, i32* %41, align 1
  %43 = add i32 %37, %42
  %44 = zext i32 %43 to i64
  %45 = icmp ult i64 %27, %44
  br i1 %45, label %ret0, label %cont_loop

cont_loop:                                          ; preds = %check_upper, %check_section
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

exit:                                               ; preds = %loop
  ret i32 0

ret0:                                               ; preds = %check_upper, %check_numsecs, %check_magic, %check_pe, %entry
  ret i32 0
}