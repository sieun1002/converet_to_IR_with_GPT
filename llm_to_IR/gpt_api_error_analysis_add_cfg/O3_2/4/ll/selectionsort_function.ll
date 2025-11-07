; ModuleID = 'selection_sort'
target triple = "x86_64-pc-linux-gnu"

define void @selection_sort(i32* nocapture %a, i32 %n) {
bb_1210:                                           ; 0x1210
  %cmp_n_le_1 = icmp sle i32 %n, 1
  br i1 %cmp_n_le_1, label %bb_12a8, label %bb_121d

bb_121d:                                           ; 0x121d (unlabeled in asm, setup)
  %r13d = add i32 %n, -1
  br label %bb_1230

bb_1230:                                           ; 0x1230
  %rbx.phi = phi i32* [ %a, %bb_121d ], [ %r12.ptr, %bb_127b ], [ %r12.ptr.1290, %bb_1290 ]
  %r10d.phi = phi i32 [ 0, %bb_121d ], [ %r10d.next, %bb_127b ], [ %r10d.next, %bb_1290 ]
  %r9d.init = add i32 %r10d.phi, 0
  %r10d.next = add i32 %r10d.phi, 1
  %ebp.val = load i32, i32* %rbx.phi, align 4
  %cmp_n_le_r10next = icmp sle i32 %n, %r10d.next
  br i1 %cmp_n_le_r10next, label %bb_1290, label %bb_123e

bb_123e:                                           ; 0x123e (unlabeled in asm)
  %r12.ptr = getelementptr inbounds i32, i32* %rbx.phi, i64 1
  %edi.init = add i32 %ebp.val, 0
  %edx.init = add i32 %r10d.next, 0
  br label %bb_1262

bb_1262:                                           ; 0x1262
  %r9d.loop = phi i32 [ %r9d.init, %bb_123e ], [ %r9d.loop, %bb_1250 ], [ %r9d.new, %bb_126b ]
  %edx.loop = phi i32 [ %edx.init, %bb_123e ], [ %edx.plus, %bb_1250 ], [ %edx.inc, %bb_126b ]
  %rax.ptr.loop = phi i32* [ %r12.ptr, %bb_123e ], [ %rax.plus, %bb_1250 ], [ %rax.inc, %bb_126b ]
  %edi.loop = phi i32 [ %edi.init, %bb_123e ], [ %edi.loop, %bb_1250 ], [ %edi.new, %bb_126b ]
  %ecx.val = load i32, i32* %rax.ptr.loop, align 4
  %cmp_ecx_ge_edi = icmp sge i32 %ecx.val, %edi.loop
  br i1 %cmp_ecx_ge_edi, label %bb_1250, label %bb_126b

bb_126b:                                           ; 0x126b (unlabeled in asm)
  %r9d.new = add i32 %edx.loop, 0
  %edx.inc = add i32 %edx.loop, 1
  %edi.new = add i32 %ecx.val, 0
  %rax.inc = getelementptr inbounds i32, i32* %rax.ptr.loop, i64 1
  %cmp_edx_ne_n = icmp ne i32 %edx.inc, %n
  br i1 %cmp_edx_ne_n, label %bb_1262, label %bb_127b

bb_1250:                                           ; 0x1250
  %r9.sext = sext i32 %r9d.loop to i64
  %r8.from1250 = getelementptr inbounds i32, i32* %a, i64 %r9.sext
  %edx.plus = add i32 %edx.loop, 1
  %rax.plus = getelementptr inbounds i32, i32* %rax.ptr.loop, i64 1
  %cmp_edx_eq_n = icmp eq i32 %edx.plus, %n
  br i1 %cmp_edx_eq_n, label %bb_127b, label %bb_1262

bb_127b:                                           ; 0x127B
  %r8.end = phi i32* [ %r8.from1250, %bb_1250 ], [ %rax.ptr.loop, %bb_126b ]
  %edi.end = phi i32 [ %edi.loop, %bb_1250 ], [ %edi.new, %bb_126b ]
  store i32 %edi.end, i32* %rbx.phi, align 4
  store i32 %ebp.val, i32* %r8.end, align 4
  %cmp_i_next_ne_last = icmp ne i32 %r10d.next, %r13d
  br i1 %cmp_i_next_ne_last, label %bb_1230, label %bb_1288

bb_1290:                                           ; 0x1290
  %r12.ptr.1290 = getelementptr inbounds i32, i32* %rbx.phi, i64 1
  store i32 %ebp.val, i32* %rbx.phi, align 4
  store i32 %ebp.val, i32* %rbx.phi, align 4
  %cmp_i_next_ne_last.1290 = icmp ne i32 %r10d.next, %r13d
  br i1 %cmp_i_next_ne_last.1290, label %bb_1230, label %bb_1288

bb_1288:                                           ; 0x1288
  ret void

bb_12a8:                                           ; 0x12A8
  ret void
}