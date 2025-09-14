; ModuleID = 'min_index'
target triple = "x86_64-pc-linux-gnu"

define i32 @min_index(i32* %a, i32* %b, i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %curMin = phi i32 [ 2147483647, %entry ], [ %min.next, %inc ]
  %curIdx = phi i32 [ -1, %entry ], [ %idx.next, %inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %checkb, label %exit

checkb:
  %i64 = sext i32 %i to i64
  %b.ptr = getelementptr inbounds i32, i32* %b, i64 %i64
  %bval = load i32, i32* %b.ptr, align 4
  %bzero = icmp eq i32 %bval, 0
  br i1 %bzero, label %checka, label %cont

checka:
  %a.ptr = getelementptr inbounds i32, i32* %a, i64 %i64
  %aval = load i32, i32* %a.ptr, align 4
  %lt = icmp slt i32 %aval, %curMin
  br i1 %lt, label %update, label %cont

update:
  br label %inc

cont:
  br label %inc

inc:
  %min.next = phi i32 [ %curMin, %cont ], [ %aval, %update ]
  %idx.next = phi i32 [ %curIdx, %cont ], [ %i, %update ]
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:
  ret i32 %curIdx
}