; ModuleID = 'selection_sort'
target triple = "x86_64-pc-linux-gnu"

define void @selection_sort(i32* %a, i32 %n) {
entry:
  ; 0x1210
  %r13d = add i32 %n, -1
  %cmp_1217 = icmp sle i32 %n, 1
  br i1 %cmp_1217, label %locret_12A8, label %loc_1230

loc_1230:                                            ; 0x1230
  %r10d.phi = phi i32 [ 0, %entry ], [ %r10d.inc, %loc_127B ], [ %r10d.inc, %loc_1290 ]
  %rbx.phi = phi i32* [ %a, %entry ], [ %r12.ptr, %loc_127B ], [ %r12.l1290, %loc_1290 ]
  %r10d.inc = add i32 %r10d.phi, 1
  %ebp.val = load i32, i32* %rbx.phi, align 4
  %cmp_1239 = icmp sle i32 %n, %r10d.inc
  br i1 %cmp_1239, label %loc_1290, label %cont_123e

cont_123e:                                           ; 0x123e (fall-through setup)
  %r12.ptr = getelementptr inbounds i32, i32* %rbx.phi, i64 1
  br label %loc_1262

loc_1250:                                            ; 0x1250
  %rcx.ext = sext i32 %r9d.phi to i64
  %edx.next.1250 = add i32 %edx.phi, 1
  %rax.next.1250 = getelementptr inbounds i32, i32* %rax.phi, i64 1
  %r8.fromr9 = getelementptr inbounds i32, i32* %a, i64 %rcx.ext
  %cmp_1260 = icmp eq i32 %n, %edx.next.1250
  br i1 %cmp_1260, label %loc_127B, label %loc_1262

loc_1262:                                            ; 0x1262
  %rax.phi = phi i32* [ %r12.ptr, %cont_123e ], [ %rax.next.1250, %loc_1250 ], [ %rax.next.1262lt, %loc_1262_lt ]
  %edx.phi = phi i32 [ %r10d.inc, %cont_123e ], [ %edx.next.1250, %loc_1250 ], [ %edx.next.1262lt, %loc_1262_lt ]
  %r9d.phi = phi i32 [ %r10d.phi, %cont_123e ], [ %r9d.phi, %loc_1250 ], [ %r9d.new.1262lt, %loc_1262_lt ]
  %edi.phi = phi i32 [ %ebp.val, %cont_123e ], [ %edi.phi, %loc_1250 ], [ %ecx.load, %loc_1262_lt ]
  %ecx.load = load i32, i32* %rax.phi, align 4
  %cmp_1269 = icmp sge i32 %ecx.load, %edi.phi
  br i1 %cmp_1269, label %loc_1250, label %loc_1262_lt

loc_1262_lt:                                         ; 0x126b..0x1279 fall-through
  %r9d.new.1262lt = add i32 %edx.phi, 0
  %edx.next.1262lt = add i32 %edx.phi, 1
  %rax.next.1262lt = getelementptr inbounds i32, i32* %rax.phi, i64 1
  %cmp_1279 = icmp ne i32 %n, %edx.next.1262lt
  br i1 %cmp_1279, label %loc_1262, label %loc_127B

loc_127B:                                            ; 0x127B
  %r8.phi.127B = phi i32* [ %r8.fromr9, %loc_1250 ], [ %rax.phi, %loc_1262_lt ]
  %edi.end.127B = phi i32 [ %edi.phi, %loc_1250 ], [ %ecx.load, %loc_1262_lt ]
  store i32 %edi.end.127B, i32* %rbx.phi, align 4
  store i32 %ebp.val, i32* %r8.phi.127B, align 4
  %cmp_1286 = icmp ne i32 %r10d.inc, %r13d
  br i1 %cmp_1286, label %loc_1230, label %loc_1288

loc_1288:                                            ; 0x1288
  ret void

loc_1290:                                            ; 0x1290
  %r12.l1290 = getelementptr inbounds i32, i32* %rbx.phi, i64 1
  store i32 %ebp.val, i32* %rbx.phi, align 4
  store i32 %ebp.val, i32* %rbx.phi, align 4
  %cmp_12a4 = icmp ne i32 %r10d.inc, %r13d
  br i1 %cmp_12a4, label %loc_1230, label %loc_1288

locret_12A8:                                         ; 0x12A8
  ret void
}