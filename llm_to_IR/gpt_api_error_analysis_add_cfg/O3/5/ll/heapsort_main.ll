; ModuleID = 'translated_from_asm_main'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
bb_144b:
  %canary.addr = alloca i64, align 8
  %i0.addr = alloca i64, align 8
  %i1.addr = alloca i64, align 8
  %len.addr = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary.addr, align 8
  %arr.gep0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr.gep0, align 4
  %arr.gep1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr.gep1, align 4
  %arr.gep2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr.gep2, align 4
  %arr.gep3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr.gep3, align 4
  %arr.gep4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr.gep4, align 4
  %arr.gep5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr.gep5, align 4
  %arr.gep6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr.gep6, align 4
  %arr.gep7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.gep7, align 4
  %arr.gep8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr.gep8, align 4
  store i64 9, i64* %len.addr, align 8
  store i64 0, i64* %i0.addr, align 8
  br label %loc_14DA

loc_14B7:                                            ; preds = %loc_14DA
  %i0.cur = load i64, i64* %i0.addr, align 8
  %elt.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i0.cur
  %elt.val = load i32, i32* %elt.ptr, align 4
  %fmt.gep = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %printf.call = call i32 (i8*, ...) @printf(i8* %fmt.gep, i32 %elt.val)
  %i0.next = add i64 %i0.cur, 1
  store i64 %i0.next, i64* %i0.addr, align 8
  br label %loc_14DA

loc_14DA:                                            ; preds = %bb_144b, %loc_14B7
  %i0.chk = load i64, i64* %i0.addr, align 8
  %len0 = load i64, i64* %len.addr, align 8
  %cmp.jb = icmp ult i64 %i0.chk, %len0
  br i1 %cmp.jb, label %loc_14B7, label %bb_14E4

bb_14E4:                                             ; fall-through from %loc_14DA
  %nl1 = call i32 @putchar(i32 10)
  %len1 = load i64, i64* %len.addr, align 8
  %arr.decay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.decay, i64 %len1)
  store i64 0, i64* %i1.addr, align 8
  br label %loc_152E

loc_150B:                                            ; preds = %loc_152E
  %i1.cur = load i64, i64* %i1.addr, align 8
  %elt2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1.cur
  %elt2.val = load i32, i32* %elt2.ptr, align 4
  %fmt2.gep = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %printf.call2 = call i32 (i8*, ...) @printf(i8* %fmt2.gep, i32 %elt2.val)
  %i1.next = add i64 %i1.cur, 1
  store i64 %i1.next, i64* %i1.addr, align 8
  br label %loc_152E

loc_152E:                                            ; preds = %bb_14E4, %loc_150B
  %i1.chk = load i64, i64* %i1.addr, align 8
  %len2 = load i64, i64* %len.addr, align 8
  %cmp2.jb = icmp ult i64 %i1.chk, %len2
  br i1 %cmp2.jb, label %loc_150B, label %bb_1538

bb_1538:                                             ; fall-through after second loop
  %nl2 = call i32 @putchar(i32 10)
  br label %bb_1542

bb_1542:
  %retv = add i32 0, 0
  %canary.saved = load i64, i64* %canary.addr, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %canary.diff = sub i64 %canary.saved, %guard.now
  %canary.ok = icmp eq i64 %canary.diff, 0
  br i1 %canary.ok, label %locret_155B, label %bb_1556

bb_1556:
  call void @__stack_chk_fail()
  unreachable

locret_155B:                                         ; preds = %bb_1542
  ret i32 %retv
}