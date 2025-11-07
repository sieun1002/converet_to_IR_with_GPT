; ModuleID = 'recovered_main'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = constant <4 x i32> <i32 10, i32 3, i32 7, i32 8>, align 16
@xmmword_2020 = constant <4 x i32> <i32 6, i32 1, i32 9, i32 2>, align 16
@unk_2004 = private constant [4 x i8] c"%d \00"
@unk_2008 = private constant [2 x i8] c"\0A\00"

declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define i32 @main() {
L1080:
  %arr = alloca [10 x i32], align 16
  %base.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %canary_start = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  %p0.vecptr = bitcast i32* %base.ptr to <4 x i32>*
  store <4 x i32> <i32 10, i32 3, i32 7, i32 8>, <4 x i32>* %p0.vecptr, align 16
  %p4 = getelementptr inbounds i32, i32* %base.ptr, i64 4
  %p4.vecptr = bitcast i32* %p4 to <4 x i32>*
  store <4 x i32> <i32 6, i32 1, i32 9, i32 2>, <4 x i32>* %p4.vecptr, align 16
  %p8 = getelementptr inbounds i32, i32* %base.ptr, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %base.ptr, i64 9
  store i32 0, i32* %p9, align 4
  br label %loc_10D0

loc_10D0:
  %rdi.cur = phi i64 [ 10, %L1080 ], [ %rdi.new, %b110E_setrdi ]
  %rax.init = add i64 0, 1
  %rdx.init = getelementptr inbounds i32, i32* %base.ptr, i64 0
  %r8.init = add i64 0, 0
  br label %loc_10E0

loc_10E0:
  %rax.cur = phi i64 [ %rax.init, %loc_10D0 ], [ %rax.next, %loc_1101 ]
  %rdx.cur = phi i32* [ %rdx.init, %loc_10D0 ], [ %rdx.next, %loc_1101 ]
  %r8.cur = phi i64 [ %r8.init, %loc_10D0 ], [ %r8.carry, %loc_1101 ]
  %a.ptr = getelementptr inbounds i32, i32* %rdx.cur, i64 0
  %b.ptr = getelementptr inbounds i32, i32* %rdx.cur, i64 1
  %a.val = load i32, i32* %a.ptr, align 4
  %b.val = load i32, i32* %b.ptr, align 4
  %cmp.le = icmp sle i32 %a.val, %b.val
  br i1 %cmp.le, label %loc_1101, label %b10E0_swap

b10E0_swap:
  store i32 %b.val, i32* %a.ptr, align 4
  store i32 %a.val, i32* %b.ptr, align 4
  %r8.new = add i64 %rax.cur, 0
  br label %loc_1101

loc_1101:
  %rax.in = phi i64 [ %rax.cur, %loc_10E0 ], [ %rax.cur, %b10E0_swap ]
  %rdx.in = phi i32* [ %rdx.cur, %loc_10E0 ], [ %rdx.cur, %b10E0_swap ]
  %r8.carry = phi i64 [ %r8.cur, %loc_10E0 ], [ %r8.new, %b10E0_swap ]
  %rax.next = add i64 %rax.in, 1
  %rdx.next = getelementptr inbounds i32, i32* %rdx.in, i64 1
  %cmp.jnz = icmp ne i64 %rdi.cur, %rax.next
  br i1 %cmp.jnz, label %loc_10E0, label %loc_110E

loc_110E:
  %r8.final = add i64 %r8.carry, 0
  %test.zero = icmp eq i64 %r8.final, 0
  br i1 %test.zero, label %loc_111E, label %b110E_cmp1

b110E_cmp1:
  %cmp.eq1 = icmp eq i64 %r8.final, 1
  br i1 %cmp.eq1, label %loc_111E, label %b110E_setrdi

b110E_setrdi:
  %rdi.new = add i64 %r8.final, 0
  br label %loc_10D0

loc_111E:
  %end.ptr = getelementptr inbounds i32, i32* %base.ptr, i64 10
  br label %loc_1130

loc_1130:
  %rbx.cur = phi i32* [ %base.ptr, %loc_111E ], [ %rbx.next, %loc_1130 ]
  %val = load i32, i32* %rbx.cur, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  %call.print = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i32 %val)
  %rbx.next = getelementptr inbounds i32, i32* %rbx.cur, i64 1
  %cmp.loop = icmp ne i32* %end.ptr, %rbx.next
  br i1 %cmp.loop, label %loc_1130, label %loc_114A

loc_114A:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  %canary_end = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  %canary.ok = icmp eq i64 %canary_start, %canary_end
  br i1 %canary.ok, label %epilogue_ok, label %loc_1178

epilogue_ok:
  ret i32 0

loc_1178:
  call void @__stack_chk_fail()
  unreachable
}