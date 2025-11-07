; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2020 = external constant <4 x i32>, align 16
@__stack_chk_guard = external global i64

@.str.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

declare i32 @___printf_chk(i32, i8*, ...)
declare void @selection_sort(i32*, i32)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
bb1080:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %canary.init = load i64, i64* @__stack_chk_guard, align 8
  store i64 %canary.init, i64* %canary.slot, align 8
  %arr.vec.ptr = bitcast [5 x i32]* %arr to <4 x i32>*
  %vinit = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %vinit, <4 x i32>* %arr.vec.ptr, align 16
  %arr.last = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr.last, align 4
  %arr.start = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  call void @selection_sort(i32* %arr.start, i32 5)
  %hdr.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %call.hdr = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %hdr.ptr)
  br label %bb10e0

bb10e0:
  %p = phi i32* [ %arr.start, %bb1080 ], [ %p.next, %bb10e0 ]
  %val = load i32, i32* %p, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0
  %call.num = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr, i32 %val)
  %p.next = getelementptr inbounds i32, i32* %p, i64 1
  %end.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 5
  %cont = icmp ne i32* %p.next, %end.ptr
  br i1 %cont, label %bb10e0, label %bb.check

bb.check:
  %canary.cur = load i64, i64* %canary.slot, align 8
  %canary.now = load i64, i64* @__stack_chk_guard, align 8
  %canary.bad = icmp ne i64 %canary.cur, %canary.now
  br i1 %canary.bad, label %bb1115, label %bb.ret

bb.ret:
  ret i32 0

bb1115:
  call void @__stack_chk_fail()
  unreachable
}