; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

define dso_local void @sub_1400028E0(i64 %size) nounwind {
entry:
  %sp = call i8* asm sideeffect inteldialect "lea $0, [rsp]", "=r"()
  %rcx0 = getelementptr i8, i8* %sp, i64 16
  br label %loop.check

loop.check:
  %rem = phi i64 [ %size, %entry ], [ %rem2, %loop.body ]
  %rcx.cur = phi i8* [ %rcx0, %entry ], [ %rcx.step, %loop.body ]
  %cmp = icmp ugt i64 %rem, 4096
  br i1 %cmp, label %loop.body, label %tail

loop.body:
  %rcx.step = getelementptr i8, i8* %rcx.cur, i64 -4096
  store volatile i8 0, i8* %rcx.step, align 1
  %rem2 = sub i64 %rem, 4096
  br label %loop.check

tail:
  %negrem = sub i64 0, %rem
  %pfinal = getelementptr i8, i8* %rcx.cur, i64 %negrem
  store volatile i8 0, i8* %pfinal, align 1
  ret void
}