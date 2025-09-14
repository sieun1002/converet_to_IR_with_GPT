; ModuleID = 'min_index'
source_filename = "min_index"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @min_index(i32* nocapture readonly %arr, i32* nocapture readonly %mask, i32 %len) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %min = phi i32 [ 2147483647, %entry ], [ %min.next, %inc ]
  %best = phi i32 [ -1, %entry ], [ %best.next, %inc ]
  %exit = icmp sge i32 %i, %len
  br i1 %exit, label %done, label %cont

cont:
  %idx64 = sext i32 %i to i64
  %maskptr = getelementptr inbounds i32, i32* %mask, i64 %idx64
  %maskval = load i32, i32* %maskptr, align 4
  %iszero = icmp eq i32 %maskval, 0
  br i1 %iszero, label %check_min, label %inc

check_min:
  %arrptr = getelementptr inbounds i32, i32* %arr, i64 %idx64
  %arrval = load i32, i32* %arrptr, align 4
  %lt = icmp slt i32 %arrval, %min
  br i1 %lt, label %update, label %inc

update:
  br label %inc

inc:
  %min.next = phi i32 [ %min, %cont ], [ %min, %check_min ], [ %arrval, %update ]
  %best.next = phi i32 [ %best, %cont ], [ %best, %check_min ], [ %i, %update ]
  %i.next = add nsw i32 %i, 1
  br label %loop

done:
  ret i32 %best
}