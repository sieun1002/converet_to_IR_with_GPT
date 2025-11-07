; ModuleID = 'linear_search_module'
target triple = "x86_64-pc-linux-gnu"

define i32 @linear_search(i32* %a, i32 %n, i32 %val) local_unnamed_addr nounwind {
bb_1180:
  %n_le_zero = icmp sle i32 %n, 0
  br i1 %n_le_zero, label %loc_11A0, label %bb_1188

bb_1188:
  %n64 = sext i32 %n to i64
  br label %loc_1199

loc_1199:
  %idx = phi i64 [ 0, %bb_1188 ], [ %idx_inc, %loc_1190 ]
  %elem_ptr = getelementptr inbounds i32, i32* %a, i64 %idx
  %elem = load i32, i32* %elem_ptr, align 4
  %neq = icmp ne i32 %elem, %val
  br i1 %neq, label %loc_1190, label %bb_119e

loc_1190:
  %idx_inc = add i64 %idx, 1
  %reached_end = icmp eq i64 %idx_inc, %n64
  br i1 %reached_end, label %loc_11A0, label %loc_1199

bb_119e:
  %retidx = trunc i64 %idx to i32
  ret i32 %retidx

loc_11A0:
  ret i32 -1
}