; target: 64-bit Windows PE parsing helper
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @sub_1400024F0(i8* nocapture readonly %rcx) local_unnamed_addr {
entry:
  %p_mz = bitcast i8* %rcx to i16*
  %mz = load i16, i16* %p_mz, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

ret0:                                             ; preds = %entry, %check_pe
  ret i32 0

check_pe:                                         ; preds = %entry
  %p_elfanew_i8 = getelementptr i8, i8* %rcx, i64 60
  %p_elfanew_i32 = bitcast i8* %p_elfanew_i8 to i32*
  %elfanew32 = load i32, i32* %p_elfanew_i32, align 1
  %elfanew64 = sext i32 %elfanew32 to i64
  %pehdr_i8 = getelementptr i8, i8* %rcx, i64 %elfanew64
  %p_sig_i32 = bitcast i8* %pehdr_i8 to i32*
  %sig = load i32, i32* %p_sig_i32, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:                                      ; preds = %check_pe
  %opt_magic_ptr_i8 = getelementptr i8, i8* %pehdr_i8, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_20B = icmp eq i16 %opt_magic, 523
  %ret = zext i1 %is_20B to i32
  ret i32 %ret
}