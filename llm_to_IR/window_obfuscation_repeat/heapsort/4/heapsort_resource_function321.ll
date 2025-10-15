; ModuleID = 'pe_section_iter'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i64 @sub_1400026D0(i64 %rcx) local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:                                         ; preds = %entry
  %e_lfanew_ptr = getelementptr inbounds i8, i8* %baseptr, i64 60
  %e_lfanew_ptr32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr32, align 4
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_ptr = getelementptr inbounds i8, i8* %baseptr, i64 %e_lfanew_sext
  %pe_sig_ptr32 = bitcast i8* %nt_ptr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr32, align 4
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:                                        ; preds = %check_pe
  %opt_magic_ptr = getelementptr inbounds i8, i8* %nt_ptr, i64 24
  %opt_magic_ptr16 = bitcast i8* %opt_magic_ptr to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr16, align 2
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %load_numsec, label %ret0

load_numsec:                                      ; preds = %check_opt
  %numsec_ptr_b = getelementptr inbounds i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_b to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 2
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret0, label %calc_first_sh

calc_first_sh:                                    ; preds = %load_numsec
  %soh_ptr_b = getelementptr inbounds i8, i8* %nt_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_b to i16*
  %soh16 = load i16, i16* %soh_ptr, align 2
  %soh_zext = zext i16 %soh16 to i64
  %after_opt = getelementptr inbounds i8, i8* %nt_ptr, i64 24
  %first_sh = getelementptr inbounds i8, i8* %after_opt, i64 %soh_zext
  %numsec64 = zext i16 %numsec16 to i64
  %n40 = mul nuw i64 %numsec64, 40
  %end_ptr = getelementptr inbounds i8, i8* %first_sh, i64 %n40
  br label %loop

loop:                                             ; preds = %loop_next, %calc_first_sh
  %ptr_phi = phi i8* [ %first_sh, %calc_first_sh ], [ %next_ptr, %loop_next ]
  %count_phi = phi i64 [ %rcx, %calc_first_sh ], [ %count_next, %loop_next ]
  %done = icmp eq i8* %ptr_phi, %end_ptr
  br i1 %done, label %ret0, label %check_exec

check_exec:                                       ; preds = %loop
  %char_byte_ptr = getelementptr inbounds i8, i8* %ptr_phi, i64 39
  %char_byte = load i8, i8* %char_byte_ptr, align 1
  %mask = and i8 %char_byte, 32
  %is_exec = icmp ne i8 %mask, 0
  br i1 %is_exec, label %if_exec, label %advance

if_exec:                                          ; preds = %check_exec
  %is_zero = icmp eq i64 %count_phi, 0
  br i1 %is_zero, label %ret0, label %dec_and_advance

dec_and_advance:                                  ; preds = %if_exec
  %count_dec = add i64 %count_phi, -1
  br label %advance

advance:                                          ; preds = %dec_and_advance, %check_exec
  %count_next = phi i64 [ %count_phi, %check_exec ], [ %count_dec, %dec_and_advance ]
  %next_ptr = getelementptr inbounds i8, i8* %ptr_phi, i64 40
  br label %loop_next

loop_next:                                        ; preds = %advance
  br label %loop

ret0:                                             ; preds = %if_exec, %loop, %load_numsec, %check_opt, %check_pe, %entry
  ret i64 0
}