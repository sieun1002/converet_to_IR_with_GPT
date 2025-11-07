; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64, align 8
@xmmword_2020 = external constant <4 x i32>, align 16

@.str_d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str_sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

declare void @selection_sort(i32*, i32)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()

define i32 @main() {
loc_1080:
  %arr = alloca [5 x i32], align 16
  %saved_canary = alloca i64, align 8
  %guard.init = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.init, i64* %saved_canary, align 8
  %vec.src = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %vec.dst = bitcast [5 x i32]* %arr to <4 x i32>*
  store <4 x i32> %vec.src, <4 x i32>* %vec.dst, align 16
  %fifth = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %fifth, align 4
  %arr.begin = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %arr.end = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 5
  call void @selection_sort(i32* %arr.begin, i32 5)
  %hdr.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_sorted, i64 0, i64 0
  %call.hdr = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %hdr.ptr)
  br label %loc_10E0

loc_10E0:
  %cur = phi i32* [ %arr.begin, %loc_1080 ], [ %cur.next, %loc_10E0 ]
  %val = load i32, i32* %cur, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  %call.item = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr, i32 %val)
  %cur.next = getelementptr inbounds i32, i32* %cur, i64 1
  %cmp.loop = icmp ne i32* %cur.next, %arr.end
  br i1 %cmp.loop, label %loc_10E0, label %bb_after_loop

bb_after_loop:
  %saved = load i64, i64* %saved_canary, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %canary.eq = icmp eq i64 %saved, %guard.now
  br i1 %canary.eq, label %bb_ret, label %loc_1115

loc_1115:
  call void @___stack_chk_fail()
  unreachable

bb_ret:
  ret i32 0
}