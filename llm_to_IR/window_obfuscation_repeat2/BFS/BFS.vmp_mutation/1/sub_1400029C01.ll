; ModuleID = 'stack_probe_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

declare i64 @llvm.read_register.i64(metadata)

define void @sub_1400029C0() local_unnamed_addr {
entry:
  %rax.val = call i64 @llvm.read_register.i64(metadata !"rax")
  %is.zero = icmp eq i64 %rax.val, 0
  br i1 %is.zero, label %ret, label %alloc

alloc:
  %arr = alloca i8, i64 %rax.val, align 16
  br label %loop

loop:
  %idx = phi i64 [ 0, %alloc ], [ %next, %loop.cont ]
  %ptr = getelementptr i8, i8* %arr, i64 %idx
  %ld = load volatile i8, i8* %ptr, align 1
  store volatile i8 %ld, i8* %ptr, align 1
  %next = add i64 %idx, 4096
  %cont = icmp ult i64 %next, %rax.val
  br i1 %cont, label %loop.cont, label %ret

loop.cont:
  br label %loop

ret:
  ret void
}