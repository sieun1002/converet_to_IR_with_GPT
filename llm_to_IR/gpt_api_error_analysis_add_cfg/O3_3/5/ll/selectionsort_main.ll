; ModuleID = 'selection_sort_main'
target triple = "x86_64-pc-linux-gnu"

@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

@xmmword_2020 = external constant [4 x i32], align 16
@__stack_chk_guard = external thread_local global i64

declare void @selection_sort(i32* nocapture, i32)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
x1080:
  %arr = alloca [5 x i32], align 16
  %canary.slot = alloca i64, align 8

  ; load stack guard and save to slot
  %guard.init = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.init, i64* %canary.slot, align 8

  ; base pointer to array
  %base.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0

  ; initialize first 4 ints from external constant xmmword_2020
  %g0 = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_2020, i64 0, i64 0
  %v0 = load i32, i32* %g0, align 4
  store i32 %v0, i32* %base.ptr, align 4

  %g1 = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_2020, i64 0, i64 1
  %v1 = load i32, i32* %g1, align 4
  %p1 = getelementptr inbounds i32, i32* %base.ptr, i64 1
  store i32 %v1, i32* %p1, align 4

  %g2 = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_2020, i64 0, i64 2
  %v2 = load i32, i32* %g2, align 4
  %p2 = getelementptr inbounds i32, i32* %base.ptr, i64 2
  store i32 %v2, i32* %p2, align 4

  %g3 = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_2020, i64 0, i64 3
  %v3 = load i32, i32* %g3, align 4
  %p3 = getelementptr inbounds i32, i32* %base.ptr, i64 3
  store i32 %v3, i32* %p3, align 4

  ; arr[4] = 13
  %p4 = getelementptr inbounds i32, i32* %base.ptr, i64 4
  store i32 13, i32* %p4, align 4

  ; call selection_sort(arr, 5)
  call void @selection_sort(i32* %base.ptr, i32 5)

  ; print "Sorted array: "
  %sorted.str = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %call.sorted = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %sorted.str)

  ; setup loop pointers
  %end.ptr = getelementptr inbounds i32, i32* %base.ptr, i64 5
  br label %loc_10E0

loc_10E0:                                           ; 0x10E0
  %cur.ptr = phi i32* [ %base.ptr, %x1080 ], [ %next.ptr, %loc_10E0 ]
  %val = load i32, i32* %cur.ptr, align 4
  %next.ptr = getelementptr inbounds i32, i32* %cur.ptr, i64 1
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call.elem = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i32 %val)
  %cmp.cont = icmp ne i32* %next.ptr, %end.ptr
  br i1 %cmp.cont, label %loc_10E0, label %x10FA

x10FA:
  ; stack canary check
  %guard.saved = load i64, i64* %canary.slot, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %guard.diff = icmp ne i64 %guard.saved, %guard.now
  br i1 %guard.diff, label %loc_1115, label %ret.ok

ret.ok:
  ret i32 0

loc_1115:                                           ; 0x1115
  call void @__stack_chk_fail()
  unreachable
}