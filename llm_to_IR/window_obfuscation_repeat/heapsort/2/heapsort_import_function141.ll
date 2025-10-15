; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-f64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002610(i8* %rcx) local_unnamed_addr {
entry:
  %baseptr_ptr = load i8*, i8** @off_1400043A0, align 8
  %pMZ = bitcast i8* %baseptr_ptr to i16*
  %mz = load i16, i16* %pMZ, align 1
  %isMZ = icmp eq i16 %mz, 23117
  br i1 %isMZ, label %check_pe, label %ret0

check_pe:
  %p_e_lfanew_i8 = getelementptr inbounds i8, i8* %baseptr_ptr, i64 60
  %p_e_lfanew_i32 = bitcast i8* %p_e_lfanew_i8 to i32*
  %e_lfanew = load i32, i32* %p_e_lfanew_i32, align 1
  %e_lfanew_zext = zext i32 %e_lfanew to i64
  %pe_hdr = getelementptr inbounds i8, i8* %baseptr_ptr, i64 %e_lfanew_zext
  %pe_sig_ptr = bitcast i8* %pe_hdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %isPE = icmp eq i32 %pe_sig, 17744
  br i1 %isPE, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptr_i8 = getelementptr inbounds i8, i8* %pe_hdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %isPE32p = icmp eq i16 %opt_magic, 523
  br i1 %isPE32p, label %load_counts, label %ret0

load_counts:
  %numsec_ptr_i8 = getelementptr inbounds i8, i8* %pe_hdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %isZero = icmp eq i16 %numsec16, 0
  br i1 %isZero, label %ret0, label %cont

cont:
  %soh_ptr_i8 = getelementptr inbounds i8, i8* %pe_hdr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh_z = zext i16 %soh16 to i64
  %rcx_int = ptrtoint i8* %rcx to i64
  %base_int = ptrtoint i8* %baseptr_ptr to i64
  %delta = sub i64 %rcx_int, %base_int
  %numsec32 = zext i16 %numsec16 to i32
  %numsec_minus1 = add i32 %numsec32, 4294967295
  %mul4 = shl i32 %numsec_minus1, 2
  %fiveN1 = add i32 %numsec_minus1, %mul4
  %first_sec_hdr = getelementptr inbounds i8, i8* %pe_hdr, i64 %soh_z
  %first_sec_hdr2 = getelementptr inbounds i8, i8* %first_sec_hdr, i64 24
  %fiveN1_z8 = zext i32 %fiveN1 to i64
  %off_mult8 = shl i64 %fiveN1_z8, 3
  %end_pre = getelementptr inbounds i8, i8* %first_sec_hdr2, i64 %off_mult8
  %end_ptr = getelementptr inbounds i8, i8* %end_pre, i64 40
  br label %loop

loop:
  %cur = phi i8* [ %first_sec_hdr2, %cont ], [ %next, %loop_latch ]
  %at_end = icmp eq i8* %cur, %end_ptr
  br i1 %at_end, label %done, label %check_sec

check_sec:
  %va_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va to i64
  %cmp1 = icmp ult i64 %delta, %va64
  br i1 %cmp1, label %loop_latch, label %check_end

check_end:
  %vs_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs = load i32, i32* %vs_ptr, align 1
  %vs64 = zext i32 %vs to i64
  %end = add i64 %va64, %vs64
  %inrange = icmp ult i64 %delta, %end
  br i1 %inrange, label %ret0, label %loop_latch

loop_latch:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  br label %loop

done:
  br label %ret0

ret0:
  ret i32 0
}