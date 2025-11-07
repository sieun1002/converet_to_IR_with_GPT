; ModuleID = 'main_from_asm'
target triple = "x86_64-pc-linux-gnu"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.d      = private unnamed_addr constant [4 x i8]  c"%d \00", align 1

@xmmword_2020 = external dso_local constant <4 x i32>, align 16
@__stack_chk_guard = external thread_local global i64

declare dso_local void @selection_sort(i32*, i32)
declare dso_local i32 @___printf_chk(i32, i8*, ...)
declare dso_local void @___stack_chk_fail() noreturn

define dso_local i32 @main() {
b1080:
  %arr = alloca [5 x i32], align 16
  %canary.slot = alloca i64, align 8
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary.slot, align 8

  %vec = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %arr.vecptr = bitcast [5 x i32]* %arr to <4 x i32>*
  store <4 x i32> %vec, <4 x i32>* %arr.vecptr, align 16
  %fifth = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %fifth, align 4

  %base = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  call void @selection_sort(i32* %base, i32 5)

  %sorted.msg = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %hdr = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %sorted.msg)
  br label %b10E0

b10E0:
  %p = phi i32* [ %base, %b1080 ], [ %p.next, %b10E0 ]
  %val = load i32, i32* %p, align 4
  %p.next = getelementptr inbounds i32, i32* %p, i64 1
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt, i32 %val)
  %end = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 5
  %cont = icmp ne i32* %p.next, %end
  br i1 %cont, label %b10E0, label %b10FA

b10FA:
  %saved = load i64, i64* %canary.slot, align 8
  %cur = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %saved, %cur
  br i1 %ok, label %b1110, label %b1115

b1110:
  ret i32 0

b1115:
  call void @___stack_chk_fail()
  unreachable
}