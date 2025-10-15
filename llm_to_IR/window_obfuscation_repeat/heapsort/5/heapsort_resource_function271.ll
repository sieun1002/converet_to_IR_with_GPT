; ModuleID = 'pecheck.ll'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define dso_local i32 @sub_1400024F0(i8* %p) #0 {
entry:
  %p.cast = bitcast i8* %p to i16*
  %mz = load i16, i16* %p.cast, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %check_pe, label %ret0

check_pe:
  %p.off3c = getelementptr i8, i8* %p, i64 60
  %off3c.ptr = bitcast i8* %p.off3c to i32*
  %off3c.val = load i32, i32* %off3c.ptr, align 1
  %off3c.sext = sext i32 %off3c.val to i64
  %pehdr = getelementptr i8, i8* %p, i64 %off3c.sext
  %sig.ptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %cmp_sig = icmp eq i32 %sig, 17744
  br i1 %cmp_sig, label %check_magic, label %ret0

check_magic:
  %opt.ptr.i8 = getelementptr i8, i8* %pehdr, i64 24
  %opt.ptr = bitcast i8* %opt.ptr.i8 to i16*
  %magic = load i16, i16* %opt.ptr, align 1
  %ok = icmp eq i16 %magic, 523
  %res = zext i1 %ok to i32
  ret i32 %res

ret0:
  ret i32 0
}

attributes #0 = { nounwind }