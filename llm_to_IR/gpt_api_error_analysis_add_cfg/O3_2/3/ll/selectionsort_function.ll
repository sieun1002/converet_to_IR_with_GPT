; ModuleID = 'selection_sort'
target triple = "x86_64-pc-linux-gnu"

define void @selection_sort(i32* nocapture %arr, i32 %n) local_unnamed_addr {
b1210:
  ; endbr64
  %n_le_1 = icmp sle i32 %n, 1
  %n_minus1 = add i32 %n, -1
  br i1 %n_le_1, label %b12A8, label %b1230

b1230:
  %rbx.phi = phi i32* [ %arr, %b1210 ], [ %r12.next, %b127B ], [ %r12.next, %b1290 ]
  %r10.phi = phi i32 [ 0, %b1210 ], [ %r10.next, %b127B ], [ %r10.next, %b1290 ]
  %r10.next = add i32 %r10.phi, 1
  %ebp.old = load i32, i32* %rbx.phi, align 4
  %r12.next = getelementptr inbounds i32, i32* %rbx.phi, i64 1
  %cmp_jle_1239 = icmp sle i32 %n, %r10.next
  br i1 %cmp_jle_1239, label %b1290, label %b1262

b1262:
  %minVal = phi i32 [ %ebp.old, %b1230 ], [ %minVal, %b1250 ], [ %cur, %b126b ]
  %minIdx = phi i32 [ %r10.phi, %b1230 ], [ %minIdx, %b1250 ], [ %j, %b126b ]
  %j = phi i32 [ %r10.next, %b1230 ], [ %j.next1250, %b1250 ], [ %j.next126b, %b126b ]
  %rax.ptr = phi i32* [ %r12.next, %b1230 ], [ %rax.next1250, %b1250 ], [ %rax.next126b, %b126b ]
  %cur = load i32, i32* %rax.ptr, align 4
  %cmp_jge_1269 = icmp sge i32 %cur, %minVal
  br i1 %cmp_jge_1269, label %b1250, label %b126b

b1250:
  %j.next1250 = add i32 %j, 1
  %rax.next1250 = getelementptr inbounds i32, i32* %rax.ptr, i64 1
  %cmp_jz_1260 = icmp eq i32 %n, %j.next1250
  br i1 %cmp_jz_1260, label %b127B, label %b1262

b126b:
  %j.next126b = add i32 %j, 1
  %rax.next126b = getelementptr inbounds i32, i32* %rax.ptr, i64 1
  %cmp_jnz_1279 = icmp ne i32 %n, %j.next126b
  br i1 %cmp_jnz_1279, label %b1262, label %b127B

b127B:
  %minVal.exit = phi i32 [ %minVal, %b1250 ], [ %cur, %b126b ]
  %minIdx.exit = phi i32 [ %minIdx, %b1250 ], [ %j, %b126b ]
  %minIdx.exit.sext = sext i32 %minIdx.exit to i64
  %minPtr.exit = getelementptr inbounds i32, i32* %arr, i64 %minIdx.exit.sext
  store i32 %minVal.exit, i32* %rbx.phi, align 4
  store i32 %ebp.old, i32* %minPtr.exit, align 4
  %cmp_jnz_1286 = icmp ne i32 %r10.next, %n_minus1
  br i1 %cmp_jnz_1286, label %b1230, label %b1288

b1290:
  ; r8 = rbx; edi = ebp; r12 = rbx+4; redundant stores preserved
  store i32 %ebp.old, i32* %rbx.phi, align 4
  store i32 %ebp.old, i32* %rbx.phi, align 4
  %cmp_jnz_12A4 = icmp ne i32 %r10.next, %n_minus1
  br i1 %cmp_jnz_12A4, label %b1230, label %b1288

b1288:
  ret void

b12A8:
  ret void
}