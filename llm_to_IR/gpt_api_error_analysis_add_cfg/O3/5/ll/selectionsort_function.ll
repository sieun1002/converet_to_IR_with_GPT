; ModuleID = 'selection_sort_module'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry_1210:
  %cmp.n_le_1 = icmp sle i32 %n, 1
  br i1 %cmp.n_le_1, label %locret_12A8, label %prologue_121d

prologue_121d:
  %r13d = add i32 %n, -1
  br label %loc_1230

loc_1230:
  %rbx.phi = phi i32* [ %arr, %prologue_121d ], [ %r12.cur, %loc_127B ], [ %r12.next.1290, %loc_1290 ]
  %r10d.phi = phi i32 [ 0, %prologue_121d ], [ %r10d.inc, %loc_127B ], [ %r10d.inc, %loc_1290 ]
  %r9d.init = add i32 %r10d.phi, 0
  %r10d.inc = add i32 %r10d.phi, 1
  %ebp.val = load i32, i32* %rbx.phi, align 4
  %cmp.n_le_r10inc = icmp sle i32 %n, %r10d.inc
  br i1 %cmp.n_le_r10inc, label %loc_1290, label %bb_1230_setup

bb_1230_setup:
  %r12.cur = getelementptr inbounds i32, i32* %rbx.phi, i64 1
  %edi.init = add i32 %ebp.val, 0
  %edx.init = add i32 %r10d.inc, 0
  %rax.init = getelementptr inbounds i32, i32* %rbx.phi, i64 1
  br label %loc_1262

loc_1262:
  %edx.phi = phi i32 [ %edx.init, %bb_1230_setup ], [ %edx.add.1250, %loc_1250 ], [ %edx.add.update, %bb_1262_update ]
  %rax.phi = phi i32* [ %rax.init, %bb_1230_setup ], [ %rax.add.1250, %loc_1250 ], [ %rax.add.update, %bb_1262_update ]
  %edi.phi = phi i32 [ %edi.init, %bb_1230_setup ], [ %edi.phi, %loc_1250 ], [ %ecx.load, %bb_1262_update ]
  %r9d.phi = phi i32 [ %r9d.init, %bb_1230_setup ], [ %r9d.phi, %loc_1250 ], [ %edx.phi, %bb_1262_update ]
  %ecx.load = load i32, i32* %rax.phi, align 4
  %cmp.ecx_ge_edi = icmp sge i32 %ecx.load, %edi.phi
  br i1 %cmp.ecx_ge_edi, label %loc_1250, label %bb_1262_update

bb_1262_update:
  %r9.new = add i32 %edx.phi, 0
  %edx.add.update = add i32 %edx.phi, 1
  %edi.new = add i32 %ecx.load, 0
  %rax.add.update = getelementptr inbounds i32, i32* %rax.phi, i64 1
  %cmp.edx_ne_n.update = icmp ne i32 %n, %edx.add.update
  br i1 %cmp.edx_ne_n.update, label %loc_1262, label %loc_127B

loc_1250:
  %rcx.idx.ext = sext i32 %r9d.phi to i64
  %edx.add.1250 = add i32 %edx.phi, 1
  %rax.add.1250 = getelementptr inbounds i32, i32* %rax.phi, i64 1
  %r8.minptr.1250 = getelementptr inbounds i32, i32* %arr, i64 %rcx.idx.ext
  %cmp.n_eq_edx = icmp eq i32 %n, %edx.add.1250
  br i1 %cmp.n_eq_edx, label %loc_127B, label %loc_1262

loc_127B:
  %r8.phi.127B = phi i32* [ %r8.minptr.1250, %loc_1250 ], [ %rax.phi, %bb_1262_update ]
  %edi.phi.127B = phi i32 [ %edi.phi, %loc_1250 ], [ %ecx.load, %bb_1262_update ]
  store i32 %edi.phi.127B, i32* %rbx.phi, align 4
  store i32 %ebp.val, i32* %r8.phi.127B, align 4
  %cmp.r10_ne_r13 = icmp ne i32 %r10d.inc, %r13d
  br i1 %cmp.r10_ne_r13, label %loc_1230, label %loc_1288

loc_1290:
  %r12.next.1290 = getelementptr inbounds i32, i32* %rbx.phi, i64 1
  store i32 %ebp.val, i32* %rbx.phi, align 4
  store i32 %ebp.val, i32* %rbx.phi, align 4
  %cmp.r10_ne_r13.1290 = icmp ne i32 %r10d.inc, %r13d
  br i1 %cmp.r10_ne_r13.1290, label %loc_1230, label %loc_1288

loc_1288:
  ret void

locret_12A8:
  ret void
}