; ModuleID = 'main_module'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"
; datalayout chosen for typical x86_64 Linux with LLVM 14
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@xmmword_2020 = private unnamed_addr constant <4 x i32> <i32 23, i32 -5, i32 42, i32 7>, align 16
@__stack_chk_guard = external global i64

declare void @selection_sort(i32* noundef, i32 noundef)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define i32 @main() local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary.slot, align 8
  %arr.vec.ptr = bitcast [5 x i32]* %arr to <4 x i32>*
  %vec.init = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %vec.init, <4 x i32>* %arr.vec.ptr, align 16
  %last.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %last.ptr, align 4
  %base.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  call void @selection_sort(i32* noundef nonnull %base.ptr, i32 noundef 5)
  %sorted.msg.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %call.print.header = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %sorted.msg.ptr)
  %end.ptr = getelementptr inbounds i32, i32* %base.ptr, i64 5
  br label %loop

loop:
  %cur.ptr = phi i32* [ %base.ptr, %entry ], [ %next.ptr, %loop.body ]
  %cmp.end = icmp eq i32* %cur.ptr, %end.ptr
  br i1 %cmp.end, label %epilogue, label %loop.body

loop.body:
  %val = load i32, i32* %cur.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0
  %call.print.elem = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i32 %val)
  %next.ptr = getelementptr inbounds i32, i32* %cur.ptr, i64 1
  br label %loop

epilogue:
  %guard.curr = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %canary.slot, align 8
  %canary.ok = icmp eq i64 %guard.saved, %guard.curr
  br i1 %canary.ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}