; ModuleID = 'min_index'
target triple = "x86_64-pc-linux-gnu"

define i32 @min_index(i32* nocapture readonly %a, i32* nocapture readonly %b, i32 %n) {
entry:
  br label %loop.header

loop.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %minv = phi i32 [ 2147483647, %entry ], [ %minv.next, %cont ]
  %idx = phi i32 [ -1, %entry ], [ %idx.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %b.ptr = getelementptr inbounds i32, i32* %b, i32 %i
  %b.val = load i32, i32* %b.ptr, align 4
  %b.isnz = icmp ne i32 %b.val, 0
  br i1 %b.isnz, label %noUpdate, label %maybe

maybe:
  %a.ptr = getelementptr inbounds i32, i32* %a, i32 %i
  %a.val = load i32, i32* %a.ptr, align 4
  %isless = icmp slt i32 %a.val, %minv
  br i1 %isless, label %doUpdate, label %noUpdate

doUpdate:
  br label %cont

noUpdate:
  br label %cont

cont:
  %minv.next = phi i32 [ %minv, %noUpdate ], [ %a.val, %doUpdate ]
  %idx.next = phi i32 [ %idx, %noUpdate ], [ %i, %doUpdate ]
  %i.next = add nsw i32 %i, 1
  br label %loop.header

exit:
  ret i32 %idx
}