; ModuleID = 'recovered'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str_d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str_sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

@xmmword_2020 = external constant <4 x i32>, align 16
@__stack_chk_guard = external global i64

declare void @selection_sort(i32*, i32)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
bb_1080:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %base.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %fmt_d = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  %fmt_sorted = getelementptr inbounds [15 x i8], [15 x i8]* @.str_sorted, i64 0, i64 0
  %guard.ld = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.ld, i64* %canary.slot, align 8
  %vec.ld = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %vec.ptr = bitcast i32* %base.ptr to <4 x i32>*
  store <4 x i32> %vec.ld, <4 x i32>* %vec.ptr, align 16
  %fifth.ptr = getelementptr inbounds i32, i32* %base.ptr, i64 4
  store i32 13, i32* %fifth.ptr, align 4
  br label %bb_10C7

bb_10C7:                                            ; 0x10c7: call selection_sort
  call void @selection_sort(i32* nonnull %base.ptr, i32 5)
  br label %bb_10CC

bb_10CC:                                            ; 0x10cc..0x10d8 setup for printf
  br label %bb_10DA

bb_10DA:                                            ; 0x10da: call ___printf_chk
  %call.prhdr = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* nonnull %fmt_sorted)
  br label %bb_10DF

bb_10DF:                                            ; 0x10df: nop
  br label %loc_10E0

loc_10E0:                                           ; 0x10e0 loop body
  %rbx.cur = phi i32* [ %base.ptr, %bb_10DF ], [ %rbx.next.ph, %bb_10F5 ]
  %val.ld = load i32, i32* %rbx.cur, align 4
  %rbx.next = getelementptr inbounds i32, i32* %rbx.cur, i64 1
  br label %bb_10F0

bb_10F0:                                            ; 0x10f0: call ___printf_chk for element
  %call.elem = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* nonnull %fmt_d, i32 %val.ld)
  br label %bb_10F5

bb_10F5:                                            ; 0x10f5 cmp and 0x10f8 jnz loc_10E0
  %rbx.next.ph = phi i32* [ %rbx.next, %bb_10F0 ]
  %end.ptr = getelementptr inbounds i32, i32* %base.ptr, i64 5
  %cmp.ne = icmp ne i32* %rbx.next.ph, %end.ptr
  br i1 %cmp.ne, label %loc_10E0, label %bb_10FA

bb_10FA:                                            ; 0x10fa..0x1108 stack canary check
  %saved.canary = load i64, i64* %canary.slot, align 8
  %cur.canary = load i64, i64* @__stack_chk_guard, align 8
  %canary.mismatch = icmp ne i64 %saved.canary, %cur.canary
  br i1 %canary.mismatch, label %loc_1115, label %bb_110A

bb_110A:                                            ; 0x110a..0x1114 epilogue/ret
  ret i32 0

loc_1115:                                           ; 0x1115: call ___stack_chk_fail
  call void @__stack_chk_fail()
  unreachable
}