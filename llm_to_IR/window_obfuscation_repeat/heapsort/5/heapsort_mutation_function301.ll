; ModuleID = 'fixed_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_1400026D0(i64 %count) {
entry:
  %imgbase.ptr = load i8*, i8** @off_1400043A0, align 8
  %mzwptr = bitcast i8* %imgbase.ptr to i16*
  %mz = load i16, i16* %mzwptr, align 1
  %cmpmz = icmp eq i16 %mz, 23117
  br i1 %cmpmz, label %after_mz, label %ret0

after_mz:
  %e_lfanew_ptr = getelementptr i8, i8* %imgbase.ptr, i64 60
  %e_lfanew_ptr32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr32, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nthdr = getelementptr i8, i8* %imgbase.ptr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %nthdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %after_pe, label %ret0

after_pe:
  %opt_magic_ptr = getelementptr i8, i8* %nthdr, i64 24
  %opt_magic_p16 = bitcast i8* %opt_magic_ptr to i16*
  %opt_magic = load i16, i16* %opt_magic_p16, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %after_magic, label %ret0

after_magic:
  %numsec_ptr = getelementptr i8, i8* %nthdr, i64 6
  %numsec_p16 = bitcast i8* %numsec_ptr to i16*
  %numsec = load i16, i16* %numsec_p16, align 1
  %numsec_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_zero, label %ret0, label %cont1

cont1:
  %sizeopth_ptr = getelementptr i8, i8* %nthdr, i64 20
  %sizeopth_p16 = bitcast i8* %sizeopth_ptr to i16*
  %sizeopth = load i16, i16* %sizeopth_p16, align 1
  %sizeopth_zext = zext i16 %sizeopth to i64
  %first_sec_off = add i64 %sizeopth_zext, 24
  %first_sec_ptr = getelementptr i8, i8* %nthdr, i64 %first_sec_off
  %numsec_z = zext i16 %numsec to i64
  %sect_span = mul i64 %numsec_z, 40
  %end_ptr = getelementptr i8, i8* %first_sec_ptr, i64 %sect_span
  br label %loop

loop:
  %cur = phi i8* [ %first_sec_ptr, %cont1 ], [ %next, %loop_end ]
  %cnt = phi i64 [ %count, %cont1 ], [ %cnt_passthru, %loop_end ]
  %not_end = icmp ne i8* %cur, %end_ptr
  br i1 %not_end, label %loop_body, label %ret0

loop_body:
  %char_ptr = getelementptr i8, i8* %cur, i64 39
  %ch = load i8, i8* %char_ptr, align 1
  %mask = and i8 %ch, 32
  %is_exec = icmp ne i8 %mask, 0
  br i1 %is_exec, label %check_cnt, label %loop_end

check_cnt:
  %cnt_is_zero = icmp eq i64 %cnt, 0
  br i1 %cnt_is_zero, label %ret0, label %dec_and_continue

dec_and_continue:
  %cnt_next = add i64 %cnt, -1
  br label %loop_end

loop_end:
  %cnt_passthru = phi i64 [ %cnt, %loop_body ], [ %cnt_next, %dec_and_continue ]
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

ret0:
  ret i32 0
}