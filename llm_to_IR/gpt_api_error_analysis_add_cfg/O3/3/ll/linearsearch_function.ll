; ModuleID = 'linear_search.ll'
target triple = "x86_64-pc-linux-gnu"

define i32 @linear_search(i32* %arr, i32 %len, i32 %val) {
loc_1180:
  %cmp_le0 = icmp sle i32 %len, 0
  br i1 %cmp_le0, label %loc_11A0, label %loc_1188

loc_1188:
  %len64 = sext i32 %len to i64
  br label %loc_1199

loc_1199:
  %idx = phi i64 [ 0, %loc_1188 ], [ %idx.inc, %loc_1190 ]
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx
  %elem = load i32, i32* %elem.ptr, align 4
  %cmp_ne1 = icmp ne i32 %elem, %val
  br i1 %cmp_ne1, label %loc_1190, label %ret_119e

loc_1190:
  %idx.inc = add i64 %idx, 1
  %cmp_eq2 = icmp eq i64 %idx.inc, %len64
  br i1 %cmp_eq2, label %loc_11A0, label %loc_1199

ret_119e:
  %ret.trunc = trunc i64 %idx to i32
  ret i32 %ret.trunc

loc_11A0:
  ret i32 -1
}