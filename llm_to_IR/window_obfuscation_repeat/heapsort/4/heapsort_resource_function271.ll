; ModuleID: 'pe_check'
source_filename = "pe_check.ll"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define dso_local i32 @sub_1400024F0(i8* %p) local_unnamed_addr {
entry:
  %p16 = bitcast i8* %p to i16*
  %w = load i16, i16* %p16, align 1
  %isMZ = icmp eq i16 %w, 23117
  br i1 %isMZ, label %check_pe, label %ret0

check_pe:                                           ; preds = %entry
  %p_plus_3C = getelementptr i8, i8* %p, i64 60
  %dos_new_off_ptr32 = bitcast i8* %p_plus_3C to i32*
  %dos_new_off = load i32, i32* %dos_new_off_ptr32, align 1
  %off64 = sext i32 %dos_new_off to i64
  %pehdr = getelementptr i8, i8* %p, i64 %off64
  %sig_ptr32 = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sig_ptr32, align 1
  %isPE = icmp eq i32 %sig, 17744
  br i1 %isPE, label %check_opt, label %ret0

check_opt:                                          ; preds = %check_pe
  %opt_magic_ptri8 = getelementptr i8, i8* %pehdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptri8 to i16*
  %magic = load i16, i16* %opt_magic_ptr, align 1
  %is64 = icmp eq i16 %magic, 523
  %is64i32 = zext i1 %is64 to i32
  ret i32 %is64i32

ret0:                                               ; preds = %check_pe, %entry
  ret i32 0
}