; ModuleID = 'sub_1400028E0_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_1400028E0(i64 %size) {
entry:
  %iszero = icmp eq i64 %size, 0
  br i1 %iszero, label %ret, label %alloc

alloc:
  %base = alloca i8, i64 %size, align 16
  %n = udiv i64 %size, 4096
  %nzero = icmp eq i64 %n, 0
  br i1 %nzero, label %afterloop, label %loop

loop:
  %j = phi i64 [ 0, %alloc ], [ %j.next, %loop ]
  %offset = mul i64 %j, 4096
  %addr = getelementptr inbounds i8, i8* %base, i64 %offset
  %val = load volatile i8, i8* %addr, align 1
  store volatile i8 %val, i8* %addr, align 1
  %j.next = add i64 %j, 1
  %done = icmp eq i64 %j.next, %n
  br i1 %done, label %afterloop, label %loop

afterloop:
  %lastidx = add i64 %size, -1
  %addr2 = getelementptr inbounds i8, i8* %base, i64 %lastidx
  %val2 = load volatile i8, i8* %addr2, align 1
  store volatile i8 %val2, i8* %addr2, align 1
  br label %ret

ret:
  ret void
}