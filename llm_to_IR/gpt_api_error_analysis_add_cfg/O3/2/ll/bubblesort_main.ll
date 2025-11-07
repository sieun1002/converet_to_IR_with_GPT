; ModuleID = 'recovered_main'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = external constant <4 x i32>, align 16
@xmmword_2020 = external constant <4 x i32>, align 16
@unk_2004 = private constant [4 x i8] c"%d \00", align 1
@unk_2008 = private constant [2 x i8] c"\0A\00", align 1
@__stack_chk_guard = external thread_local global i64

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main(i32 %argc, i8** %argv) {
bb_1080:                                            ; 0x1080
  %arr = alloca [10 x i32], align 16
  %canary_slot = alloca i64, align 8
  %rbx_base.i8 = bitcast [10 x i32]* %arr to i8*
  %rbx_base.i32 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %guard.init = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.init, i64* %canary_slot, align 8
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %arr.vec0.ptr = bitcast [10 x i32]* %arr to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %arr.vec0.ptr, align 16
  %arr.vec1.i8 = getelementptr inbounds i8, i8* %rbx_base.i8, i64 16
  %arr.vec1.ptr = bitcast i8* %arr.vec1.i8 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %v1, <4 x i32>* %arr.vec1.ptr, align 16
  %idx8.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %idx8.ptr, align 4
  %rdi.init = zext i32 10 to i64
  br label %bb_10D0

bb_10D0:                                            ; 0x10d0
  %rdi.len = phi i64 [ %rdi.init, %bb_1080 ], [ %r8.to.rdi, %bb_1119 ]
  br label %bb_10E0

bb_10E0:                                            ; 0x10e0
  %rax.i = phi i64 [ 1, %bb_10D0 ], [ %rax.next, %bb_1101 ]
  %rdx.ptr = phi i32* [ %rbx_base.i32, %bb_10D0 ], [ %rdx.next, %bb_1101 ]
  %r8.last = phi i64 [ 0, %bb_10D0 ], [ %r8.in, %bb_1101 ]
  %rdi.cur = phi i64 [ %rdi.len, %bb_10D0 ], [ %rdi.back, %bb_1101 ]
  %a = load i32, i32* %rdx.ptr, align 4
  %rdx.plus1 = getelementptr inbounds i32, i32* %rdx.ptr, i64 1
  %b = load i32, i32* %rdx.plus1, align 4
  %cmp.le = icmp sle i32 %a, %b
  br i1 %cmp.le, label %bb_1101, label %bb_10F5

bb_10F5:                                            ; swap path (unlabeled in input)
  store i32 %b, i32* %rdx.ptr, align 4
  store i32 %a, i32* %rdx.plus1, align 4
  br label %bb_1101

bb_1101:                                            ; 0x1101
  %r8.in = phi i64 [ %r8.last, %bb_10E0 ], [ %rax.i, %bb_10F5 ]
  %rax.next = add i64 %rax.i, 1
  %rdx.next = getelementptr inbounds i32, i32* %rdx.ptr, i64 1
  %rdi.back = add i64 %rdi.cur, 0
  %cmp.ne = icmp ne i64 %rdi.cur, %rax.next
  br i1 %cmp.ne, label %bb_10E0, label %bb_110E

bb_110E:                                            ; fall-through after loop condition (unlabeled)
  %r8.eq0 = icmp eq i64 %r8.in, 0
  br i1 %r8.eq0, label %bb_111E, label %bb_1113

bb_1113:                                            ; 0x1113 fall-through (unlabeled)
  %r8.eq1 = icmp eq i64 %r8.in, 1
  br i1 %r8.eq1, label %bb_111E, label %bb_1119

bb_1119:                                            ; 0x1119 fall-through (unlabeled)
  %r8.to.rdi = add i64 %r8.in, 0
  br label %bb_10D0

bb_111E:                                            ; 0x111e
  %r12.end = getelementptr inbounds i8, i8* %rbx_base.i8, i64 40
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  br label %bb_1130

bb_1130:                                            ; 0x1130
  %rbx.loop = phi i8* [ %rbx_base.i8, %bb_111E ], [ %rbx.next, %bb_1130 ]
  %rbx.i32.cur = bitcast i8* %rbx.loop to i32*
  %val = load i32, i32* %rbx.i32.cur, align 4
  %call.print = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr, i32 %val)
  %rbx.next = getelementptr inbounds i8, i8* %rbx.loop, i64 4
  %cont = icmp ne i8* %rbx.next, %r12.end
  br i1 %cont, label %bb_1130, label %bb_114A

bb_114A:                                            ; 0x114a fall-through (unlabeled)
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %nl.ptr)
  br label %bb_115D

bb_115D:                                            ; 0x115d fall-through (unlabeled)
  %guard.saved = load i64, i64* %canary_slot, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %guard.diff = icmp ne i64 %guard.saved, %guard.now
  br i1 %guard.diff, label %bb_1178, label %bb_116D

bb_116D:                                            ; 0x116d fall-through (unlabeled)
  ret i32 0

bb_1178:                                            ; 0x1178
  call void @___stack_chk_fail()
  unreachable
}