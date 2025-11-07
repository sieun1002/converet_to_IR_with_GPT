; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = internal constant <4 x i32> <i32 9, i32 1, i32 8, i32 3>, align 16
@xmmword_2020 = internal constant <4 x i32> <i32 5, i32 2, i32 7, i32 0>, align 16
@unk_2004 = internal unnamed_addr constant [4 x i8] c"%d \00", align 1
@unk_2008 = internal unnamed_addr constant [2 x i8] c"\0A\00", align 1
@__stack_chk_guard = external global i64, align 8

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
bb_0x1080:
  %arr = alloca [10 x i32], align 16
  %canary = alloca i64, align 8
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %vecptr0 = bitcast i32* %arr.base to <4 x i32>*
  %c0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  store <4 x i32> %c0, <4 x i32>* %vecptr0, align 16
  %ptr4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  %vecptr1 = bitcast i32* %ptr4 to <4 x i32>*
  %c1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %c1, <4 x i32>* %vecptr1, align 16
  %ptr8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %ptr8, align 4
  %guard.init = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.init, i64* %canary, align 8
  br label %bb_0x10D0

bb_0x10D0:                                        ; preds = %bb_0x1080, %bb_0x1119
  %rdi.ph = phi i64 [ 10, %bb_0x1080 ], [ %rdi.new, %bb_0x1119 ]
  br label %bb_0x10E0

bb_0x10E0:                                        ; preds = %bb_0x10D0, %bb_0x1101
  %rax.ph = phi i64 [ 1, %bb_0x10D0 ], [ %rax.next, %bb_0x1101 ]
  %rdx.ph = phi i32* [ %arr.base, %bb_0x10D0 ], [ %rdx.next, %bb_0x1101 ]
  %r8.ph = phi i64 [ 0, %bb_0x10D0 ], [ %r8.updated, %bb_0x1101 ]
  %v0 = load i32, i32* %rdx.ph, align 4
  %p_next = getelementptr inbounds i32, i32* %rdx.ph, i64 1
  %v1 = load i32, i32* %p_next, align 4
  %cond.le = icmp sle i32 %v0, %v1
  br i1 %cond.le, label %bb_0x1101, label %bb_0x10F5

bb_0x10F5:                                        ; preds = %bb_0x10E0
  store i32 %v1, i32* %rdx.ph, align 4
  store i32 %v0, i32* %p_next, align 4
  %r8.swap = add i64 %rax.ph, 0
  br label %bb_0x1101

bb_0x1101:                                        ; preds = %bb_0x10F5, %bb_0x10E0
  %r8.updated = phi i64 [ %r8.ph, %bb_0x10E0 ], [ %r8.swap, %bb_0x10F5 ]
  %rax.next = add i64 %rax.ph, 1
  %rdx.next = getelementptr inbounds i32, i32* %rdx.ph, i64 1
  %cmp.cont = icmp ne i64 %rdi.ph, %rax.next
  br i1 %cmp.cont, label %bb_0x10E0, label %bb_0x110E

bb_0x110E:                                        ; preds = %bb_0x1101
  %isZero = icmp eq i64 %r8.updated, 0
  br i1 %isZero, label %bb_0x111E, label %bb_0x1113

bb_0x1113:                                        ; preds = %bb_0x110E
  %isOne = icmp eq i64 %r8.updated, 1
  br i1 %isOne, label %bb_0x111E, label %bb_0x1119

bb_0x1119:                                        ; preds = %bb_0x1113
  %rdi.new = add i64 %r8.updated, 0
  br label %bb_0x10D0

bb_0x111E:                                        ; preds = %bb_0x1113, %bb_0x110E
  %r12.end = getelementptr inbounds i32, i32* %arr.base, i64 10
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  br label %bb_0x1130

bb_0x1130:                                        ; preds = %bb_0x1145, %bb_0x111E
  %rbx.iter = phi i32* [ %arr.base, %bb_0x111E ], [ %rbx.next, %bb_0x1145 ]
  %val.print = load i32, i32* %rbx.iter, align 4
  %rbx.next = getelementptr inbounds i32, i32* %rbx.iter, i64 1
  %call.printf.each = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr, i32 %val.print)
  br label %bb_0x1145

bb_0x1145:                                        ; preds = %bb_0x1130
  %cont = icmp ne i32* %r12.end, %rbx.next
  br i1 %cont, label %bb_0x1130, label %bb_0x114A

bb_0x114A:                                        ; preds = %bb_0x1145
  %fmt2.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call.printf.tail = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2.ptr)
  br label %bb_0x115D

bb_0x115D:                                        ; preds = %bb_0x114A
  %can.load = load i64, i64* %canary, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %can.load, %guard.now
  br i1 %ok, label %bb_0x116D, label %bb_0x1178

bb_0x116D:                                        ; preds = %bb_0x115D
  ret i32 0

bb_0x1178:                                        ; preds = %bb_0x115D
  call void @___stack_chk_fail()
  unreachable
}