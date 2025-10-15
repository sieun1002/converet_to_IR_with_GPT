; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_1400026D0(i64 %rcx) {
entry:
  %0 = load i8*, i8** @off_1400043A0, align 8
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 1
  %cmp_mz = icmp eq i16 %2, 23117
  br i1 %cmp_mz, label %check_pe, label %ret0

check_pe:                                         ; preds = %entry
  %pe_off_ptr = getelementptr i8, i8* %0, i64 60
  %3 = bitcast i8* %pe_off_ptr to i32*
  %4 = load i32, i32* %3, align 1
  %5 = sext i32 %4 to i64
  %pe_ptr = getelementptr i8, i8* %0, i64 %5
  %6 = bitcast i8* %pe_ptr to i32*
  %7 = load i32, i32* %6, align 1
  %cmp_pe = icmp eq i32 %7, 17744
  br i1 %cmp_pe, label %check_magic, label %ret0

check_magic:                                      ; preds = %check_pe
  %magic_ptr = getelementptr i8, i8* %pe_ptr, i64 24
  %8 = bitcast i8* %magic_ptr to i16*
  %9 = load i16, i16* %8, align 1
  %is_pe32plus = icmp eq i16 %9, 523
  br i1 %is_pe32plus, label %load_sections, label %ret0

load_sections:                                    ; preds = %check_magic
  %numsec_ptr = getelementptr i8, i8* %pe_ptr, i64 6
  %10 = bitcast i8* %numsec_ptr to i16*
  %11 = load i16, i16* %10, align 1
  %numsec_zero = icmp eq i16 %11, 0
  br i1 %numsec_zero, label %ret0, label %calc_first

calc_first:                                       ; preds = %load_sections
  %szopt_ptr = getelementptr i8, i8* %pe_ptr, i64 20
  %12 = bitcast i8* %szopt_ptr to i16*
  %13 = load i16, i16* %12, align 1
  %szopt_z = zext i16 %13 to i64
  %first_off = add i64 %szopt_z, 24
  %first_ptr = getelementptr i8, i8* %pe_ptr, i64 %first_off
  %numsec_z = zext i16 %11 to i64
  %span = mul i64 %numsec_z, 40
  %end_ptr = getelementptr i8, i8* %first_ptr, i64 %span
  br label %loop

loop:                                             ; preds = %loop_tail, %calc_first
  %cur_ptr = phi i8* [ %first_ptr, %calc_first ], [ %next_ptr, %loop_tail ]
  %rcx_phi = phi i64 [ %rcx, %calc_first ], [ %rcx_next, %loop_tail ]
  %char_ptr = getelementptr i8, i8* %cur_ptr, i64 39
  %14 = load i8, i8* %char_ptr, align 1
  %masked = and i8 %14, 32
  %has_flag = icmp ne i8 %masked, 0
  br i1 %has_flag, label %flag_check, label %loop_tail

flag_check:                                       ; preds = %loop
  %is_zero = icmp eq i64 %rcx_phi, 0
  br i1 %is_zero, label %ret0, label %decr

decr:                                             ; preds = %flag_check
  %rcx_dec = add i64 %rcx_phi, -1
  br label %loop_tail

loop_tail:                                        ; preds = %decr, %loop
  %rcx_next = phi i64 [ %rcx_phi, %loop ], [ %rcx_dec, %decr ]
  %next_ptr = getelementptr i8, i8* %cur_ptr, i64 40
  %done = icmp eq i8* %end_ptr, %next_ptr
  br i1 %done, label %ret0, label %loop

ret0:                                             ; preds = %loop_tail, %flag_check, %load_sections, %check_magic, %check_pe, %entry
  ret i32 0
}