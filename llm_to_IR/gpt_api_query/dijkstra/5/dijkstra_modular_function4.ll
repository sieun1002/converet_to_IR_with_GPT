; ModuleID = 'min_index.ll'
source_filename = "min_index"

define i32 @min_index(i32* nocapture readonly %values, i32* nocapture readonly %flags, i32 %n) local_unnamed_addr nounwind readonly {
entry:
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %bestVal = phi i32 [ 2147483647, %entry ], [ %bestVal.next, %inc ]
  %bestIdx = phi i32 [ -1, %entry ], [ %bestIdx.next, %inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %end

body:                                             ; preds = %loop
  %idx64 = sext i32 %i to i64
  %flagp = getelementptr inbounds i32, i32* %flags, i64 %idx64
  %flag = load i32, i32* %flagp, align 4
  %iszero = icmp eq i32 %flag, 0
  br i1 %iszero, label %check, label %inc

check:                                            ; preds = %body
  %valp = getelementptr inbounds i32, i32* %values, i64 %idx64
  %val = load i32, i32* %valp, align 4
  %lt = icmp slt i32 %val, %bestVal
  %bestVal.sel = select i1 %lt, i32 %val, i32 %bestVal
  %bestIdx.sel = select i1 %lt, i32 %i, i32 %bestIdx
  br label %inc

inc:                                              ; preds = %check, %body
  %bestVal.next = phi i32 [ %bestVal, %body ], [ %bestVal.sel, %check ]
  %bestIdx.next = phi i32 [ %bestIdx, %body ], [ %bestIdx.sel, %check ]
  %i.next = add nsw i32 %i, 1
  br label %loop

end:                                              ; preds = %loop
  ret i32 %bestIdx
}