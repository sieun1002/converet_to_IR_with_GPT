; ModuleID = 'min_index'
target triple = "x86_64-pc-linux-gnu"

define i32 @min_index(i32* noundef %a, i32* noundef %b, i32 noundef %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %minIdx = phi i32 [ -1, %entry ], [ %minIdx.next, %inc ]
  %minVal = phi i32 [ 2147483647, %entry ], [ %minVal.next, %inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:
  %i64 = sext i32 %i to i64
  %b.ptr = getelementptr inbounds i32, i32* %b, i64 %i64
  %b.val = load i32, i32* %b.ptr, align 4
  %bzero = icmp eq i32 %b.val, 0
  br i1 %bzero, label %checkA, label %inc

checkA:
  %a.ptr = getelementptr inbounds i32, i32* %a, i64 %i64
  %a.val = load i32, i32* %a.ptr, align 4
  %less = icmp slt i32 %a.val, %minVal
  br i1 %less, label %update, label %inc

update:
  br label %inc

inc:
  %minVal.next = phi i32 [ %minVal, %body ], [ %minVal, %checkA ], [ %a.val, %update ]
  %minIdx.next = phi i32 [ %minIdx, %body ], [ %minIdx, %checkA ], [ %i, %update ]
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:
  ret i32 %minIdx
}