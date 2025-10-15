; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_1400026D0(i64 %rcx) local_unnamed_addr {
entry:
  %0 = load i8*, i8** @off_1400043A0, align 8
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 1
  %3 = icmp eq i16 %2, 23117
  br i1 %3, label %check_pe, label %ret0

check_pe:                                         ; preds = %entry
  %4 = getelementptr i8, i8* %0, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 1
  %7 = sext i32 %6 to i64
  %8 = getelementptr i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 1
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %check_magic, label %ret0

check_magic:                                      ; preds = %check_pe
  %12 = getelementptr i8, i8* %8, i64 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 1
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %load_sections, label %ret0

load_sections:                                    ; preds = %check_magic
  %16 = getelementptr i8, i8* %8, i64 6
  %17 = bitcast i8* %16 to i16*
  %18 = load i16, i16* %17, align 1
  %19 = icmp eq i16 %18, 0
  br i1 %19, label %ret0, label %prepare_loop

prepare_loop:                                     ; preds = %load_sections
  %20 = zext i16 %18 to i64
  %21 = getelementptr i8, i8* %8, i64 20
  %22 = bitcast i8* %21 to i16*
  %23 = load i16, i16* %22, align 1
  %24 = zext i16 %23 to i64
  %25 = add i64 %24, 24
  %26 = getelementptr i8, i8* %8, i64 %25
  %27 = add i64 %20, -1
  %28 = shl i64 %27, 2
  %29 = add i64 %28, %27
  %30 = shl i64 %29, 3
  %31 = add i64 %30, 40
  %32 = getelementptr i8, i8* %26, i64 %31
  br label %loop

loop:                                              ; preds = %cont, %prepare_loop
  %count = phi i64 [ %rcx, %prepare_loop ], [ %count.next, %cont ]
  %ptr = phi i8* [ %26, %prepare_loop ], [ %ptr.next, %cont ]
  %33 = getelementptr i8, i8* %ptr, i64 39
  %34 = load i8, i8* %33, align 1
  %35 = and i8 %34, 32
  %36 = icmp ne i8 %35, 0
  br i1 %36, label %dec_check, label %cont_no_dec

dec_check:                                        ; preds = %loop
  %37 = icmp eq i64 %count, 0
  br i1 %37, label %ret0, label %dec

dec:                                              ; preds = %dec_check
  %38 = add i64 %count, -1
  br label %cont

cont_no_dec:                                      ; preds = %loop
  br label %cont

cont:                                             ; preds = %cont_no_dec, %dec
  %count.next = phi i64 [ %38, %dec ], [ %count, %cont_no_dec ]
  %ptr.next = getelementptr i8, i8* %ptr, i64 40
  %39 = icmp ne i8* %ptr.next, %32
  br i1 %39, label %loop, label %exit

exit:                                             ; preds = %cont
  ret i32 0

ret0:                                             ; preds = %dec_check, %load_sections, %check_magic, %check_pe, %entry
  ret i32 0
}