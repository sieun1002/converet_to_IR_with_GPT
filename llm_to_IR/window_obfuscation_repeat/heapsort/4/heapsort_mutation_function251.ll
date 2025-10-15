; ModuleID = 'pecheck.ll'
source_filename = "pecheck.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define i32 @sub_1400024F0(i8* %base) local_unnamed_addr {
entry:
  %p16 = bitcast i8* %base to i16*
  %w = load i16, i16* %p16, align 1
  %cmpMZ = icmp eq i16 %w, 23117
  br i1 %cmpMZ, label %check_pe, label %ret0

ret0:
  ret i32 0

check_pe:
  %p32o = getelementptr i8, i8* %base, i64 60
  %p32 = bitcast i8* %p32o to i32*
  %off = load i32, i32* %p32, align 1
  %off64 = sext i32 %off to i64
  %ntptr = getelementptr i8, i8* %base, i64 %off64
  %nt32p = bitcast i8* %ntptr to i32*
  %sig = load i32, i32* %nt32p, align 1
  %cmpPE = icmp eq i32 %sig, 17744
  br i1 %cmpPE, label %check_opt, label %ret0

check_opt:
  %off18 = getelementptr i8, i8* %ntptr, i64 24
  %p16b = bitcast i8* %off18 to i16*
  %w2 = load i16, i16* %p16b, align 1
  %is20B = icmp eq i16 %w2, 523
  %zext = zext i1 %is20B to i32
  ret i32 %zext
}