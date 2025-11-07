; ModuleID = 'recovered.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = external constant <4 x i32>, align 16
@xmmword_2020 = external constant <4 x i32>, align 16
@unk_2004 = external global i8
@unk_2008 = external global i8
@__stack_chk_guard = external thread_local global i64

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()

define i32 @main() local_unnamed_addr {
x1080:
  %frame = alloca [48 x i8], align 16
  %base = getelementptr inbounds [48 x i8], [48 x i8]* %frame, i64 0, i64 0
  %dest0 = bitcast i8* %base to <4 x i32>*
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  store <4 x i32> %v0, <4 x i32>* %dest0, align 16
  %p16 = getelementptr inbounds i8, i8* %base, i64 16
  %dest1 = bitcast i8* %p16 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %v1, <4 x i32>* %dest1, align 16
  %p32 = getelementptr inbounds i8, i8* %base, i64 32
  %p32i32 = bitcast i8* %p32 to i32*
  store i32 4, i32* %p32i32, align 4
  %p40 = getelementptr inbounds i8, i8* %base, i64 40
  %p40i64 = bitcast i8* %p40 to i64*
  %canload = load i64, i64* @__stack_chk_guard, align 8
  store i64 %canload, i64* %p40i64, align 8
  br label %loc_10D0

loc_10D0:                                          ; preds = %x1119, %x1080
  %rdi.cur = phi i64 [ 10, %x1080 ], [ %r8.final, %x1119 ]
  %rdx.init = bitcast i8* %base to i8*
  br label %loc_10E0

loc_10E0:                                          ; preds = %loc_1101, %loc_10D0
  %rdx.loop = phi i8* [ %rdx.init, %loc_10D0 ], [ %rdx.next, %loc_1101 ]
  %rax.idx = phi i64 [ 1, %loc_10D0 ], [ %rax.next, %loc_1101 ]
  %r8.carry = phi i64 [ 0, %loc_10D0 ], [ %r8.sel, %loc_1101 ]
  %ptrA = bitcast i8* %rdx.loop to i32*
  %a = load i32, i32* %ptrA, align 4
  %ptrB.byte = getelementptr inbounds i8, i8* %rdx.loop, i64 4
  %ptrB = bitcast i8* %ptrB.byte to i32*
  %b = load i32, i32* %ptrB, align 4
  %cmp_ab = icmp sle i32 %a, %b
  br i1 %cmp_ab, label %loc_1101, label %x10F5

x10F5:                                             ; preds = %loc_10E0
  store i32 %a, i32* %ptrB, align 4
  store i32 %b, i32* %ptrA, align 4
  br label %loc_1101

loc_1101:                                          ; preds = %x10F5, %loc_10E0
  %r8.sel = phi i64 [ %r8.carry, %loc_10E0 ], [ %rax.idx, %x10F5 ]
  %rax.next = add i64 %rax.idx, 1
  %rdx.next = getelementptr inbounds i8, i8* %rdx.loop, i64 4
  %cmp_idx = icmp ne i64 %rdi.cur, %rax.next
  br i1 %cmp_idx, label %loc_10E0, label %x110e

x110e:                                             ; preds = %loc_1101
  %isZero = icmp eq i64 %r8.sel, 0
  br i1 %isZero, label %loc_111E, label %x1113

x1113:                                             ; preds = %x110e
  %isOne = icmp eq i64 %r8.sel, 1
  br i1 %isOne, label %loc_111E, label %x1119

x1119:                                             ; preds = %x1113
  %r8.final = phi i64 [ %r8.sel, %x1113 ]
  br label %loc_10D0

loc_111E:                                          ; preds = %x1113, %x110e
  %r12.end = getelementptr inbounds i8, i8* %base, i64 40
  br label %loc_1130

loc_1130:                                          ; preds = %x1145, %loc_111E
  %rbx.print = phi i8* [ %base, %loc_111E ], [ %rbx.next, %x1145 ]
  %val.ptr = bitcast i8* %rbx.print to i32*
  %val = load i32, i32* %val.ptr, align 4
  %rbx.next = getelementptr inbounds i8, i8* %rbx.print, i64 4
  %call_chk1 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* @unk_2004, i32 %val)
  br label %x1145

x1145:                                             ; preds = %loc_1130
  %cmp_cont = icmp ne i8* %r12.end, %rbx.next
  br i1 %cmp_cont, label %loc_1130, label %x114a

x114a:                                             ; preds = %x1145
  %call_chk2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* @unk_2008)
  br label %x115d

x115d:                                             ; preds = %x114a
  %saved_canary = load i64, i64* %p40i64, align 8
  %cur_canary = load i64, i64* @__stack_chk_guard, align 8
  %can_mismatch = icmp ne i64 %saved_canary, %cur_canary
  br i1 %can_mismatch, label %loc_1178, label %x116d

x116d:                                             ; preds = %x115d
  ret i32 0

loc_1178:                                          ; preds = %x115d
  call void @___stack_chk_fail()
  unreachable
}