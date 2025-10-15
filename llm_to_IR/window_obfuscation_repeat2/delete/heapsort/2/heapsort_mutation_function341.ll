; ModuleID = 'stack_probe_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_1400028E0(i64 %size) {
entry:
  %base = alloca i8, align 1
  %rcx0 = getelementptr i8, i8* %base, i64 16
  %isSmall = icmp ult i64 %size, 4096
  br i1 %isSmall, label %small, label %loop.body

loop.body:
  %rcx.phi = phi i8* [ %rcx0, %entry ], [ %rcx.next, %loop.body ]
  %size.phi = phi i64 [ %size, %entry ], [ %size.dec, %loop.body ]
  %rcx.next = getelementptr i8, i8* %rcx.phi, i64 -4096
  %val = load volatile i8, i8* %rcx.next, align 1
  %size.dec = sub i64 %size.phi, 4096
  %cmp2 = icmp ugt i64 %size.dec, 4096
  br i1 %cmp2, label %loop.body, label %afterLoop

afterLoop:
  br label %small

small:
  %rcx.in = phi i8* [ %rcx0, %entry ], [ %rcx.next, %afterLoop ]
  %size.in = phi i64 [ %size, %entry ], [ %size.dec, %afterLoop ]
  %negsize = sub i64 0, %size.in
  %addr = getelementptr i8, i8* %rcx.in, i64 %negsize
  %v2 = load volatile i8, i8* %addr, align 1
  ret void
}