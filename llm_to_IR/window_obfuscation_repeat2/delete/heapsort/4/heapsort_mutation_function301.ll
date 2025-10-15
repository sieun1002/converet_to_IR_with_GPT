; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_1400026D0(i64 %rcx) local_unnamed_addr {
entry:
  %0 = load i8*, i8** @off_1400043A0, align 8
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 1
  %3 = icmp eq i16 %2, 23117
  br i1 %3, label %bb_peoff, label %bb_ret0

bb_peoff:                                         ; preds = %entry
  %4 = getelementptr i8, i8* %0, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 1
  %7 = sext i32 %6 to i64
  %8 = getelementptr i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 1
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %bb_after_sig, label %bb_ret0

bb_after_sig:                                     ; preds = %bb_peoff
  %12 = getelementptr i8, i8* %8, i64 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 1
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %bb_after_magic, label %bb_ret0

bb_after_magic:                                   ; preds = %bb_after_sig
  %16 = getelementptr i8, i8* %8, i64 6
  %17 = bitcast i8* %16 to i16*
  %18 = load i16, i16* %17, align 1
  %19 = icmp eq i16 %18, 0
  br i1 %19, label %bb_ret0, label %bb_have_sections

bb_have_sections:                                 ; preds = %bb_after_magic
  %20 = getelementptr i8, i8* %8, i64 20
  %21 = bitcast i8* %20 to i16*
  %22 = load i16, i16* %21, align 1
  %23 = zext i16 %22 to i64
  %24 = getelementptr i8, i8* %8, i64 24
  %25 = getelementptr i8, i8* %24, i64 %23
  %26 = zext i16 %18 to i64
  %27 = add i64 %26, -1
  %28 = mul i64 %27, 5
  %29 = shl i64 %28, 3
  %30 = getelementptr i8, i8* %25, i64 %29
  %31 = getelementptr i8, i8* %30, i64 40
  br label %loop

loop:                                             ; preds = %advance_join, %bb_have_sections
  %curr_ptr = phi i8* [ %25, %bb_have_sections ], [ %next_ptr, %advance_join ]
  %rcx_phi = phi i64 [ %rcx, %bb_have_sections ], [ %rcx_next, %advance_join ]
  %32 = getelementptr i8, i8* %curr_ptr, i64 39
  %33 = load i8, i8* %32, align 1
  %34 = and i8 %33, 32
  %35 = icmp eq i8 %34, 0
  br i1 %35, label %no_dec, label %maybe_dec

maybe_dec:                                        ; preds = %loop
  %36 = icmp eq i64 %rcx_phi, 0
  br i1 %36, label %bb_ret0, label %do_dec

do_dec:                                           ; preds = %maybe_dec
  %37 = add i64 %rcx_phi, -1
  br label %advance_join

no_dec:                                           ; preds = %loop
  br label %advance_join

advance_join:                                     ; preds = %no_dec, %do_dec
  %rcx_next = phi i64 [ %37, %do_dec ], [ %rcx_phi, %no_dec ]
  %next_ptr = getelementptr i8, i8* %curr_ptr, i64 40
  %38 = icmp ne i8* %31, %next_ptr
  br i1 %38, label %loop, label %done

done:                                             ; preds = %advance_join
  ret i32 0

bb_ret0:                                          ; preds = %maybe_dec, %bb_after_magic, %bb_after_sig, %bb_peoff, %entry
  ret i32 0
}