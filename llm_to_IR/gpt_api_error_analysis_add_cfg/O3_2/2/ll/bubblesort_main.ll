; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = external constant <4 x i32>, align 16
@xmmword_2020 = external constant <4 x i32>, align 16
@unk_2004 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@unk_2008 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@__stack_chk_guard = external thread_local global i64, align 8

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() {
_1080:
  %arr = alloca [10 x i32], align 16
  %saved_canary = alloca i64, align 8
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %saved_canary, align 8
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %arr.base.v = bitcast i32* %arr.base to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %arr.base.v, align 16
  %arr.off4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %arr.off4.v = bitcast i32* %arr.off4 to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %arr.off4.v, align 16
  %arr.idx8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %arr.idx8, align 4
  %arr.idx9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %arr.idx9, align 4
  br label %_10D0

_10D0:
  %rdx.init = phi i32* [ %arr.base, %_1080 ], [ %arr.base, %_back_to_10D0 ]
  %rdi.pass = phi i64 [ 10, %_1080 ], [ %r8.next, %_back_to_10D0 ]
  %r8.lastswap.init = phi i64 [ 0, %_1080 ], [ 0, %_back_to_10D0 ]
  %rax.i.init = phi i64 [ 1, %_1080 ], [ 1, %_back_to_10D0 ]
  br label %_10E0

_10E0:
  %rdx.phi = phi i32* [ %rdx.init, %_10D0 ], [ %rdx.next, %_1101 ]
  %r8.phi = phi i64 [ %r8.lastswap.init, %_10D0 ], [ %r8.next, %_1101 ]
  %rax.phi = phi i64 [ %rax.i.init, %_10D0 ], [ %rax.next, %_1101 ]
  %rdi.phi = phi i64 [ %rdi.pass, %_10D0 ], [ %rdi.phi, %_1101 ]
  %a = load i32, i32* %rdx.phi, align 4
  %rdx.plus4 = getelementptr inbounds i32, i32* %rdx.phi, i64 1
  %b = load i32, i32* %rdx.plus4, align 4
  %cmp.le = icmp sle i32 %a, %b
  br i1 %cmp.le, label %_1101, label %_swap

_swap:
  store i32 %b, i32* %rdx.phi, align 4
  store i32 %a, i32* %rdx.plus4, align 4
  br label %_1101

_1101:
  %r8.next = phi i64 [ %r8.phi, %_10E0 ], [ %rax.phi, %_swap ]
  %rax.next = add i64 %rax.phi, 1
  %rdx.next = getelementptr inbounds i32, i32* %rdx.phi, i64 1
  %cont = icmp ne i64 %rax.next, %rdi.phi
  br i1 %cont, label %_10E0, label %_after_inner

_after_inner:
  %has.swap = icmp ne i64 %r8.next, 0
  br i1 %has.swap, label %_test_one, label %_111E

_test_one:
  %is.one = icmp eq i64 %r8.next, 1
  br i1 %is.one, label %_111E, label %_back_to_10D0

_back_to_10D0:
  br label %_10D0

_111E:
  %arr.end = getelementptr inbounds i32, i32* %arr.base, i64 10
  %rbp.fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  br label %_1130

_1130:
  %rbx.it = phi i32* [ %arr.base, %_111E ], [ %rbx.next, %_1130 ]
  %val = load i32, i32* %rbx.it, align 4
  %rbx.next = getelementptr inbounds i32, i32* %rbx.it, i64 1
  %call.print = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %rbp.fmt1, i32 %val)
  %more = icmp ne i32* %rbx.next, %arr.end
  br i1 %more, label %_1130, label %_after_print

_after_print:
  %fmt.nl = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.nl)
  %saved = load i64, i64* %saved_canary, align 8
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %mismatch = icmp ne i64 %saved, %guard1
  br i1 %mismatch, label %_1178, label %_return

_return:
  ret i32 0

_1178:
  call void @___stack_chk_fail()
  unreachable
}