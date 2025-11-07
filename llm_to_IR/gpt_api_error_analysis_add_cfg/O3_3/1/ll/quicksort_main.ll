; ModuleID = 'recovered'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@unk_2004 = private constant [4 x i8] c"%d \00", align 1
@unk_2008 = private constant [2 x i8] c"\0A\00", align 1
@__stack_chk_guard = external global i64

declare void @quick_sort(i8*, i64, i64)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define i32 @main() local_unnamed_addr {
block_1080:
  %arr = alloca [8 x i32], align 16
  %canary_slot = alloca i64, align 8
  %rbx_ptr = alloca i32*, align 8
  %end_ptr = alloca i32*, align 8
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary_slot, align 8
  %gep0 = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 0
  store i32 8, i32* %gep0, align 16
  %gep1 = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 1
  store i32 7, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 2
  store i32 6, i32* %gep2, align 8
  %gep3 = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 3
  store i32 5, i32* %gep3, align 4
  %gep4 = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %gep4, align 16
  %gep5 = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %gep5, align 4
  %gep6 = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %gep6, align 8
  %gep7 = getelementptr inbounds [8 x i32], [8 x i32]* %arr, i64 0, i64 7
  store i32 1, i32* %gep7, align 4
  %base.i32 = bitcast [8 x i32]* %arr to i32*
  %base.i8 = bitcast [8 x i32]* %arr to i8*
  store i32* %base.i32, i32** %rbx_ptr, align 8
  %endcalc = getelementptr inbounds i32, i32* %base.i32, i64 8
  store i32* %endcalc, i32** %end_ptr, align 8
  call void @quick_sort(i8* %base.i8, i64 0, i64 9)
  br label %block_10E0

block_10E0:                                          ; preds = %block_1080, %block_10E0
  %curptr = load i32*, i32** %rbx_ptr, align 8
  %val = load i32, i32* %curptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  %call.printf1 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr, i32 %val)
  %nextptr = getelementptr inbounds i32, i32* %curptr, i64 1
  store i32* %nextptr, i32** %rbx_ptr, align 8
  %end.load = load i32*, i32** %end_ptr, align 8
  %cmp.neq = icmp ne i32* %end.load, %nextptr
  br i1 %cmp.neq, label %block_10E0, label %block_10FA

block_10FA:                                          ; preds = %block_10E0
  %fmt2.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call.printf2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2.ptr)
  %saved = load i64, i64* %canary_slot, align 8
  %curr = load i64, i64* @__stack_chk_guard, align 8
  %neq = icmp ne i64 %saved, %curr
  br i1 %neq, label %block_1128, label %block_111D

block_111D:                                          ; preds = %block_10FA
  ret i32 0

block_1128:                                          ; preds = %block_10FA
  call void @__stack_chk_fail()
  unreachable
}