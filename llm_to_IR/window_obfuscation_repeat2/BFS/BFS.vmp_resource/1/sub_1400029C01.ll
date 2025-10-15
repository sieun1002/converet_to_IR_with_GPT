; ModuleID = 'm'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

define void @sub_1400029C0(i64 %size) {
entry:
  %spbase = alloca i8, align 1
  %cmp0 = icmp ult i64 %size, 4096
  br i1 %cmp0, label %tail, label %preloop

preloop:
  br label %loop

loop:
  %rcx.phi = phi i8* [ %spbase, %preloop ], [ %rcx.next, %loop ]
  %size.phi = phi i64 [ %size, %preloop ], [ %size.sub, %loop ]
  %rcx.next = getelementptr i8, i8* %rcx.phi, i64 -4096
  %ptr64 = bitcast i8* %rcx.next to i64*
  %val = load volatile i64, i64* %ptr64, align 1
  store volatile i64 %val, i64* %ptr64, align 1
  %size.sub = sub i64 %size.phi, 4096
  %cmp1 = icmp ugt i64 %size.sub, 4096
  br i1 %cmp1, label %loop, label %tailprep

tailprep:
  br label %tail

tail:
  %rcx.tail = phi i8* [ %spbase, %entry ], [ %rcx.next, %tailprep ]
  %rem.tail = phi i64 [ %size, %entry ], [ %size.sub, %tailprep ]
  %negrem = sub i64 0, %rem.tail
  %rcx.fin = getelementptr i8, i8* %rcx.tail, i64 %negrem
  %ptr64f = bitcast i8* %rcx.fin to i64*
  %valf = load volatile i64, i64* %ptr64f, align 1
  store volatile i64 %valf, i64* %ptr64f, align 1
  ret void
}