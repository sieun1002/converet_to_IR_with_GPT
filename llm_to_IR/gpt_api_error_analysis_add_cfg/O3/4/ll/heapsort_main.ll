; ModuleID = 'recovered_main'
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64, align 8

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %saved_canary = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %var_38 = alloca i64, align 8
  %var_48 = alloca i64, align 8
  %var_40 = alloca i64, align 8

  %guard.ld = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.ld, i64* %saved_canary, align 8

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

  store i64 9, i64* %var_38, align 8
  store i64 0, i64* %var_48, align 8

  br label %loc_14DA

loc_14B7:                                             ; preds = %loc_14DA
  %idx.ld.0 = load i64, i64* %var_48, align 8
  %elem.ptr.0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %idx.ld.0
  %elem.ld.0 = load i32, i32* %elem.ptr.0, align 4
  %fmt.ptr.0 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf.0 = call i32 (i8*, ...) @printf(i8* %fmt.ptr.0, i32 %elem.ld.0)
  %idx.ld.1 = load i64, i64* %var_48, align 8
  %idx.inc.0 = add i64 %idx.ld.1, 1
  store i64 %idx.inc.0, i64* %var_48, align 8
  br label %loc_14DA

loc_14DA:                                             ; preds = %loc_14B7, %entry
  %i.ld.0 = load i64, i64* %var_48, align 8
  %n.ld.0 = load i64, i64* %var_38, align 8
  %cmp.ult.0 = icmp ult i64 %i.ld.0, %n.ld.0
  br i1 %cmp.ult.0, label %loc_14B7, label %block_14E4

block_14E4:                                           ; preds = %loc_14DA
  %putchar.nl.0 = call i32 @putchar(i32 10)
  %n.ld.1 = load i64, i64* %var_38, align 8
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.base, i64 %n.ld.1)
  store i64 0, i64* %var_40, align 8
  br label %loc_152E

loc_150B:                                             ; preds = %loc_152E
  %idx2.ld.0 = load i64, i64* %var_40, align 8
  %elem.ptr.1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %idx2.ld.0
  %elem.ld.1 = load i32, i32* %elem.ptr.1, align 4
  %fmt.ptr.1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf.1 = call i32 (i8*, ...) @printf(i8* %fmt.ptr.1, i32 %elem.ld.1)
  %idx2.ld.1 = load i64, i64* %var_40, align 8
  %idx2.inc.0 = add i64 %idx2.ld.1, 1
  store i64 %idx2.inc.0, i64* %var_40, align 8
  br label %loc_152E

loc_152E:                                             ; preds = %loc_150B, %block_14E4
  %i2.ld.0 = load i64, i64* %var_40, align 8
  %n.ld.2 = load i64, i64* %var_38, align 8
  %cmp.ult.1 = icmp ult i64 %i2.ld.0, %n.ld.2
  br i1 %cmp.ult.1, label %loc_150B, label %after_152E

after_152E:                                           ; preds = %loc_152E
  %putchar.nl.1 = call i32 @putchar(i32 10)
  %saved.ld = load i64, i64* %saved_canary, align 8
  %guard.ld.2 = load i64, i64* @__stack_chk_guard, align 8
  %canary.eq = icmp eq i64 %saved.ld, %guard.ld.2
  br i1 %canary.eq, label %locret_155B, label %stack_chk_fail

stack_chk_fail:                                       ; preds = %after_152E
  call void @__stack_chk_fail()
  unreachable

locret_155B:                                          ; preds = %after_152E
  ret i32 0
}