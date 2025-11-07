; ModuleID = 'selection_sort_main'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

@xmmword_2020 = external global <4 x i32>, align 16
@__stack_chk_guard = external thread_local global i64, align 8

declare void @selection_sort(i32* noundef, i32 noundef)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
entry_1080:
  ; stack objects
  %arr = alloca [5 x i32], align 16
  %canary.slot = alloca i64, align 8

  ; load stack canary and save it
  %guard.init = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.init, i64* %canary.slot, align 8

  ; initialize first 4 ints from global 16-byte constant
  %vec = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %vecptr = bitcast [5 x i32]* %arr to <4 x i32>*
  store <4 x i32> %vec, <4 x i32>* %vecptr, align 16

  ; arr[4] = 13
  %elt4.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %elt4.ptr, align 4

  ; call selection_sort(arr, 5)
  %arr.i32 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  call void @selection_sort(i32* noundef %arr.i32, i32 noundef 5)

  ; print "Sorted array: "
  %sorted.msg = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %call.sorted = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %sorted.msg)

  br label %loc_10E0

loc_10E0:                                            ; preds = %entry_1080, %loc_10E0
  ; loop state: rbx-like current element pointer
  %cur.ptr = phi i32* [ %arr.i32, %entry_1080 ], [ %next.ptr, %loc_10E0 ]
  ; r12-like end pointer = arr + 5 (constant within function)
  %end.ptr = getelementptr inbounds i32, i32* %arr.i32, i64 5

  ; load current value (edx = [rbx])
  %val = load i32, i32* %cur.ptr, align 4
  ; increment pointer before call (rbx += 4)
  %next.ptr = getelementptr inbounds i32, i32* %cur.ptr, i64 1
  ; prepare "%d "
  %fmt.int = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  ; call ___printf_chk(2, "%d ", value)
  %call.print = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.int, i32 %val)
  ; cmp rbx, r12
  %cmp.cont = icmp ne i32* %next.ptr, %end.ptr
  br i1 %cmp.cont, label %loc_10E0, label %bb_10FA

bb_10FA:                                             ; preds = %loc_10E0
  ; stack canary check
  %guard.cur = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %canary.slot, align 8
  %canary.ok = icmp eq i64 %guard.saved, %guard.cur
  br i1 %canary.ok, label %ret.ok, label %loc_1115

ret.ok:                                              ; preds = %bb_10FA
  ret i32 0

loc_1115:                                            ; preds = %bb_10FA
  call void @___stack_chk_fail()
  unreachable
}