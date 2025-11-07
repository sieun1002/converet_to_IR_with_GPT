; ModuleID = 'linear_search_recovered'
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @linear_search(i32* %arr, i32 %count, i32 %val) {
loc_1180:
  ; endbr64 (no-op in IR)
  %cmp_le_zero = icmp sle i32 %count, 0
  br i1 %cmp_le_zero, label %loc_11A0, label %loc_1188

loc_1188:
  %len64 = sext i32 %count to i64
  br label %loc_1199

loc_1190:
  %idx_inc = add i64 %idx, 1
  %cmp_eq = icmp eq i64 %idx_inc, %len64
  br i1 %cmp_eq, label %loc_11A0, label %loc_1199

loc_1199:
  %idx = phi i64 [ 0, %loc_1188 ], [ %idx_inc, %loc_1190 ]
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx
  %elem = load i32, i32* %elem.ptr, align 4
  %cmp_ne = icmp ne i32 %elem, %val
  br i1 %cmp_ne, label %loc_1190, label %loc_119E

loc_119E:
  %retidx = trunc i64 %idx to i32
  ret i32 %retidx

loc_11A0:
  ret i32 -1
}