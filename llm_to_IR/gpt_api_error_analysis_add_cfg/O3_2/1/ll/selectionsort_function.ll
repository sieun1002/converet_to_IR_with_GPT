; ModuleID = 'selection_sort'
target triple = "x86_64-pc-linux-gnu"

define void @selection_sort(i32* nocapture %arr, i32 %n) {
bb_1210:
  %cmp_n_le_1 = icmp sle i32 %n, 1
  br i1 %cmp_n_le_1, label %bb_12a8, label %bb_121d

bb_121d:
  %base = getelementptr inbounds i32, i32* %arr, i64 0
  %n_minus_1 = add i32 %n, -1
  %r10.init = add i32 0, 0
  %rbx.init = getelementptr inbounds i32, i32* %arr, i64 0
  br label %bb_1230

bb_1230:
  %rbx.cur = phi i32* [ %rbx.init, %bb_121d ], [ %rbx.next, %bb_127b ], [ %rbx.next.1290, %bb_1290 ]
  %r10.in = phi i32 [ %r10.init, %bb_121d ], [ %r10.back, %bb_127b ], [ %r10.next, %bb_1290 ]
  %r9.cur = add i32 %r10.in, 0
  %r10.next = add i32 %r10.in, 1
  %ebp.cur = load i32, i32* %rbx.cur, align 4
  %cmp_n_le_r10 = icmp sle i32 %n, %r10.next
  br i1 %cmp_n_le_r10, label %bb_1290, label %bb_123e

bb_123e:
  %r12.cur = getelementptr inbounds i32, i32* %rbx.cur, i64 1
  %edi.cur = add i32 %ebp.cur, 0
  %edx.cur = add i32 %r10.next, 0
  %rax.cur = getelementptr inbounds i32, i32* %r12.cur, i64 0
  br label %bb_1262

bb_1262:
  %edi.phi = phi i32  [ %edi.cur, %bb_123e ], [ %edi.phi, %bb_1250 ], [ %edi.upd, %bb_126b ]
  %edx.phi = phi i32 [ %edx.cur, %bb_123e ], [ %edx.inc.1250, %bb_1250 ], [ %edx.inc.126b, %bb_126b ]
  %rax.phi = phi i32* [ %rax.cur, %bb_123e ], [ %rax.inc.1250, %bb_1250 ], [ %rax.inc.126b, %bb_126b ]
  %r9.phi  = phi i32  [ %r9.cur, %bb_123e ],  [ %r9.phi, %bb_1250 ],    [ %r9.upd, %bb_126b ]
  %r12.phi = phi i32* [ %r12.cur, %bb_123e ], [ %r12.phi, %bb_1250 ],   [ %r12.phi, %bb_126b ]
  %ebp.phi = phi i32  [ %ebp.cur, %bb_123e ], [ %ebp.phi, %bb_1250 ],   [ %ebp.phi, %bb_126b ]
  %r10.loop = phi i32 [ %r10.next, %bb_123e ], [ %r10.loop, %bb_1250 ], [ %r10.loop, %bb_126b ]
  %rbx.phi2 = phi i32* [ %rbx.cur, %bb_123e ], [ %rbx.phi2, %bb_1250 ], [ %rbx.phi2, %bb_126b ]
  %ecx.cur = load i32, i32* %rax.phi, align 4
  %r8.tent = getelementptr inbounds i32, i32* %rax.phi, i64 0
  %cmp_ecx_ge_edi = icmp sge i32 %ecx.cur, %edi.phi
  br i1 %cmp_ecx_ge_edi, label %bb_1250, label %bb_126b

bb_1250:
  %idx64 = sext i32 %r9.phi to i64
  %r8.from_r9 = getelementptr inbounds i32, i32* %base, i64 %idx64
  %edx.inc.1250 = add i32 %edx.phi, 1
  %rax.inc.1250 = getelementptr inbounds i32, i32* %rax.phi, i64 1
  %cmp_n_eq_edx = icmp eq i32 %n, %edx.inc.1250
  br i1 %cmp_n_eq_edx, label %bb_127b, label %bb_1262

bb_126b:
  %r9.upd = add i32 %edx.phi, 0
  %edx.inc.126b = add i32 %edx.phi, 1
  %edi.upd = add i32 %ecx.cur, 0
  %rax.inc.126b = getelementptr inbounds i32, i32* %rax.phi, i64 1
  %cmp_n_ne_edx = icmp ne i32 %n, %edx.inc.126b
  br i1 %cmp_n_ne_edx, label %bb_1262, label %bb_127b

bb_127b:
  %r8.exit = phi i32* [ %r8.from_r9, %bb_1250 ], [ %r8.tent, %bb_126b ]
  %edi.exit = phi i32  [ %edi.phi,     %bb_1250 ], [ %edi.upd, %bb_126b ]
  store i32 %edi.exit, i32* %rbx.phi2, align 4
  %rbx.next = getelementptr inbounds i32, i32* %r12.phi, i64 0
  store i32 %ebp.phi, i32* %r8.exit, align 4
  %cmp_r10_ne_r13 = icmp ne i32 %r10.loop, %n_minus_1
  %r10.back = add i32 %r10.loop, 0
  br i1 %cmp_r10_ne_r13, label %bb_1230, label %bb_1288

bb_1290:
  %r8.1290 = getelementptr inbounds i32, i32* %rbx.cur, i64 0
  %edi.1290 = add i32 %ebp.cur, 0
  %r12.1290 = getelementptr inbounds i32, i32* %rbx.cur, i64 1
  store i32 %edi.1290, i32* %rbx.cur, align 4
  %rbx.next.1290 = getelementptr inbounds i32, i32* %r12.1290, i64 0
  store i32 %ebp.cur, i32* %r8.1290, align 4
  %cmp_r10_ne_r13_1290 = icmp ne i32 %r10.next, %n_minus_1
  br i1 %cmp_r10_ne_r13_1290, label %bb_1230, label %bb_1288

bb_1288:
  ret void

bb_12a8:
  ret void
}