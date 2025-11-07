; ModuleID = 'translated_from_asm_main'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@xmmword_2010 = external global <16 x i8>, align 16
@xmmword_2020 = external global <16 x i8>, align 16
@unk_2004 = external global i8
@unk_2008 = external global i8
@__stack_chk_guard = external global i64

declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() noreturn

define i32 @main() local_unnamed_addr {
bb_1080:
  %arr = alloca [10 x i32], align 16
  %canary.slot = alloca i64, align 8
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary.slot, align 8
  %arr.i8 = bitcast [10 x i32]* %arr to i8*
  %arr.v0.ptr = bitcast [10 x i32]* %arr to <16 x i8>*
  %v0 = load <16 x i8>, <16 x i8>* @xmmword_2010, align 16
  store <16 x i8> %v0, <16 x i8>* %arr.v0.ptr, align 16
  %off16 = getelementptr i8, i8* %arr.i8, i64 16
  %arr.v1.ptr = bitcast i8* %off16 to <16 x i8>*
  %v1 = load <16 x i8>, <16 x i8>* @xmmword_2020, align 16
  store <16 x i8> %v1, <16 x i8>* %arr.v1.ptr, align 16
  %arr.idx8 = getelementptr [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.idx8, align 4
  %arr.idx9 = getelementptr [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.idx9, align 4
  br label %bb_10d0

bb_10d0:                                             ; loc_10D0
  %len.cur = phi i64 [ 10, %bb_1080 ], [ %rdi.new, %bb_1119 ]
  br label %bb_10e0

bb_10e0:                                             ; loc_10E0
  %rdx.cur = phi i8* [ %arr.i8, %bb_10d0 ], [ %rdx.next, %bb_1101 ]
  %i.cur = phi i64 [ 1, %bb_10d0 ], [ %i.inc, %bb_1101 ]
  %lastSwap.cur = phi i64 [ 0, %bb_10d0 ], [ %lastSwap.new, %bb_1101 ]
  %len.loop = phi i64 [ %len.cur, %bb_10d0 ], [ %len.loop, %bb_1101 ]
  %a.ptr = bitcast i8* %rdx.cur to i32*
  %a = load i32, i32* %a.ptr, align 4
  %b.addr = getelementptr i8, i8* %rdx.cur, i64 4
  %b.ptr = bitcast i8* %b.addr to i32*
  %b = load i32, i32* %b.ptr, align 4
  %cmp.le = icmp sle i32 %a, %b
  br i1 %cmp.le, label %bb_1101, label %bb_10f5

bb_10f5:
  store i32 %b, i32* %a.ptr, align 4
  store i32 %a, i32* %b.ptr, align 4
  br label %bb_1101

bb_1101:                                             ; loc_1101
  %lastSwap.new = phi i64 [ %lastSwap.cur, %bb_10e0 ], [ %i.cur, %bb_10f5 ]
  %i.inc = add i64 %i.cur, 1
  %rdx.next = getelementptr i8, i8* %rdx.cur, i64 4
  %cont = icmp ne i64 %len.loop, %i.inc
  br i1 %cont, label %bb_10e0, label %bb_110e

bb_110e:
  %is.zero = icmp eq i64 %lastSwap.new, 0
  br i1 %is.zero, label %bb_111e, label %bb_1113

bb_1113:
  %is.one = icmp eq i64 %lastSwap.new, 1
  br i1 %is.one, label %bb_111e, label %bb_1119

bb_1119:
  %rdi.new = add i64 %lastSwap.new, 0
  br label %bb_10d0

bb_111e:                                             ; loc_111E
  %endptr = getelementptr i8, i8* %arr.i8, i64 40
  br label %bb_1130

bb_1130:                                             ; loc_1130
  %rbx.cur = phi i8* [ %arr.i8, %bb_111e ], [ %rbx.next, %bb_1145 ]
  %val.ptr = bitcast i8* %rbx.cur to i32*
  %val = load i32, i32* %val.ptr, align 4
  %call.print = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* @unk_2004, i32 %val)
  br label %bb_1145

bb_1145:
  %rbx.next = getelementptr i8, i8* %rbx.cur, i64 4
  %more = icmp ne i8* %rbx.next, %endptr
  br i1 %more, label %bb_1130, label %bb_114a

bb_114a:
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* @unk_2008)
  br label %bb_115d

bb_115d:
  %saved.can = load i64, i64* %canary.slot, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %canary.bad = icmp ne i64 %saved.can, %guard.now
  br i1 %canary.bad, label %bb_1178, label %bb_116d

bb_116d:
  ret i32 0

bb_1178:                                             ; loc_1178
  call void @__stack_chk_fail()
  unreachable
}