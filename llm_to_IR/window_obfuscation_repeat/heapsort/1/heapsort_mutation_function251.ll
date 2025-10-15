; ModuleID = 'pecheck'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define dso_local i32 @sub_1400024F0(i8* nocapture readonly %ptr) local_unnamed_addr #0 {
entry:
  %p_word = bitcast i8* %ptr to i16*
  %mzw = load i16, i16* %p_word, align 1
  %cmpmz = icmp eq i16 %mzw, 23117
  br i1 %cmpmz, label %check_pe, label %ret0

check_pe:
  %p_3c = getelementptr i8, i8* %ptr, i64 60
  %p_3c_i32 = bitcast i8* %p_3c to i32*
  %e_lfanew = load i32, i32* %p_3c_i32, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr_ptr = getelementptr i8, i8* %ptr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %pehdr_ptr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %pehdr_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  %ret = zext i1 %is_pe32plus to i32
  ret i32 %ret

ret0:
  ret i32 0
}

attributes #0 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "target-cpu"="x86-64" "target-features"="+sse2" }