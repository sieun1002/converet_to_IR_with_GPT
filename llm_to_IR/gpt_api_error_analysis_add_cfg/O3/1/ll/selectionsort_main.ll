; ModuleID = 'main_from_asm_0x1080_0x111a'
target triple = "x86_64-pc-linux-gnu"

@.str_d = private constant [4 x i8] c"%d \00", align 1
@.str_sorted = private constant [15 x i8] c"Sorted array: \00", align 1
@xmmword_2020 = external dso_local constant <4 x i32>, align 16
@__stack_chk_guard = external dso_local global i64

declare dso_local void @selection_sort(i32* noundef, i32 noundef)
declare dso_local i32 @___printf_chk(i32, i8*, ...)
declare dso_local void @___stack_chk_fail() noreturn

define dso_local i32 @main() {
loc_1080:
  %arr = alloca [5 x i32], align 16
  %canary.slot = alloca i64, align 8
  %canary.init = load i64, i64* @__stack_chk_guard, align 8
  store i64 %canary.init, i64* %canary.slot, align 8
  %arr.vec.ptr = bitcast [5 x i32]* %arr to <4 x i32>*
  %vec.init = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %vec.init, <4 x i32>* %arr.vec.ptr, align 16
  %elt4ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %elt4ptr, align 4
  %arr.base = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  call void @selection_sort(i32* %arr.base, i32 5)
  %sorted.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_sorted, i64 0, i64 0
  %call.header = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %sorted.ptr)
  br label %loc_10E0

loc_10E0:
  %rbx.cur = phi i32* [ %arr.base, %loc_1080 ], [ %rbx.next, %loc_10E0 ]
  %val = load i32, i32* %rbx.cur, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  %call.elem = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr, i32 %val)
  %rbx.next = getelementptr inbounds i32, i32* %rbx.cur, i64 1
  %r12.end = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 5
  %cmp.ne = icmp ne i32* %rbx.next, %r12.end
  br i1 %cmp.ne, label %loc_10E0, label %after_loop

after_loop:
  %canary.saved = load i64, i64* %canary.slot, align 8
  %canary.now = load i64, i64* @__stack_chk_guard, align 8
  %canary.ok = icmp eq i64 %canary.saved, %canary.now
  br i1 %canary.ok, label %retblock, label %loc_1115

loc_1115:
  call void @___stack_chk_fail()
  unreachable

retblock:
  ret i32 0
}