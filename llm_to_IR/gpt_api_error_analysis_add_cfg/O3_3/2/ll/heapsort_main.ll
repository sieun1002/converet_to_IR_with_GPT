; ModuleID = 'recovered_from_asm_main'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry_144b:
  %canary = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %idx1 = alloca i64, align 8
  %idx2 = alloca i64, align 8
  %retval = alloca i32, align 4
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary, align 8
  %arr.p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr.p0, align 4
  %arr.p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr.p1, align 4
  %arr.p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr.p2, align 4
  %arr.p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr.p3, align 4
  %arr.p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr.p4, align 4
  %arr.p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr.p5, align 4
  %arr.p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr.p6, align 4
  %arr.p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.p7, align 4
  %arr.p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr.p8, align 4
  store i64 9, i64* %len, align 8
  store i64 0, i64* %idx1, align 8
  br label %loc_14DA

loc_14B7:                                           ; preds = %loc_14DA
  %i1.load.a = load i64, i64* %idx1, align 8
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1.load.a
  %elem.val1 = load i32, i32* %elem.ptr1, align 4
  %fmt.ptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %printf.call1 = call i32 (i8*, ...) @printf(i8* %fmt.ptr1, i32 %elem.val1)
  br label %postcall_14B7

postcall_14B7:                                      ; preds = %loc_14B7
  %i1.load.b = load i64, i64* %idx1, align 8
  %i1.inc = add i64 %i1.load.b, 1
  store i64 %i1.inc, i64* %idx1, align 8
  br label %loc_14DA

loc_14DA:                                           ; preds = %postcall_14B7, %entry_144b
  %i1.load = load i64, i64* %idx1, align 8
  %n.load = load i64, i64* %len, align 8
  %cmp.jb = icmp ult i64 %i1.load, %n.load
  br i1 %cmp.jb, label %loc_14B7, label %bb_14e4

bb_14e4:                                            ; preds = %loc_14DA
  %putchar.call1 = call i32 @putchar(i32 10)
  br label %postcall_14e4_putchar

postcall_14e4_putchar:                              ; preds = %bb_14e4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n.load.2 = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arr.base, i64 %n.load.2)
  br label %postcall_14e4_heapsort

postcall_14e4_heapsort:                             ; preds = %postcall_14e4_putchar
  store i64 0, i64* %idx2, align 8
  br label %loc_152E

loc_150B:                                           ; preds = %loc_152E
  %i2.load.a = load i64, i64* %idx2, align 8
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2.load.a
  %elem.val2 = load i32, i32* %elem.ptr2, align 4
  %fmt.ptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %printf.call2 = call i32 (i8*, ...) @printf(i8* %fmt.ptr2, i32 %elem.val2)
  br label %postcall_150B

postcall_150B:                                      ; preds = %loc_150B
  %i2.load.b = load i64, i64* %idx2, align 8
  %i2.inc = add i64 %i2.load.b, 1
  store i64 %i2.inc, i64* %idx2, align 8
  br label %loc_152E

loc_152E:                                           ; preds = %postcall_150B, %postcall_14e4_heapsort
  %i2.load = load i64, i64* %idx2, align 8
  %n.load.3 = load i64, i64* %len, align 8
  %cmp2.jb = icmp ult i64 %i2.load, %n.load.3
  br i1 %cmp2.jb, label %loc_150B, label %bb_1538

bb_1538:                                            ; preds = %loc_152E
  %putchar.call2 = call i32 @putchar(i32 10)
  br label %postcall_1538_putchar

postcall_1538_putchar:                              ; preds = %bb_1538
  store i32 0, i32* %retval, align 4
  %saved.guard = load i64, i64* %canary, align 8
  %cur.guard = load i64, i64* @__stack_chk_guard, align 8
  %guard.ok = icmp eq i64 %saved.guard, %cur.guard
  br i1 %guard.ok, label %locret_155B, label %bb_fail

bb_fail:                                            ; preds = %postcall_1538_putchar
  call void @__stack_chk_fail()
  unreachable

locret_155B:                                        ; preds = %postcall_1538_putchar
  %rv.load = load i32, i32* %retval, align 4
  ret i32 %rv.load
}