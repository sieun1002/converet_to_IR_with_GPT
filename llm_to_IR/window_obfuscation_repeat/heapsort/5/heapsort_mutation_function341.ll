; ModuleID = 'fixed_module'
source_filename = "fixed_module.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define void @sub_1400028E0(i64 %size, i8* %base) {
entry:
  %cmp_init = icmp ult i64 %size, 4096
  br i1 %cmp_init, label %small, label %loop.header

loop.header:
  %base.phi = phi i8* [ %base, %entry ], [ %base.dec, %loop.header ]
  %size.phi = phi i64 [ %size, %entry ], [ %size.dec, %loop.header ]
  %base.dec = getelementptr i8, i8* %base.phi, i64 -4096
  %p.loop = bitcast i8* %base.dec to i64*
  %val.loop = load volatile i64, i64* %p.loop, align 1
  store volatile i64 %val.loop, i64* %p.loop, align 1
  %size.dec = sub i64 %size.phi, 4096
  %cond = icmp ugt i64 %size.dec, 4096
  br i1 %cond, label %loop.header, label %afterloop

afterloop:
  %neg.rem = sub i64 0, %size.dec
  %base.final = getelementptr i8, i8* %base.dec, i64 %neg.rem
  %p.final = bitcast i8* %base.final to i64*
  %val.final = load volatile i64, i64* %p.final, align 1
  store volatile i64 %val.final, i64* %p.final, align 1
  br label %ret

small:
  %neg.small = sub i64 0, %size
  %base.small = getelementptr i8, i8* %base, i64 %neg.small
  %p.small = bitcast i8* %base.small to i64*
  %val.small = load volatile i64, i64* %p.small, align 1
  store volatile i64 %val.small, i64* %p.small, align 1
  br label %ret

ret:
  ret void
}