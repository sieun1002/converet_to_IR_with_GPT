; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

define dso_local i32 @linear_search(i32* %arr, i32 %len, i32 %val) {
bb1180:                                              ; 0x1180
  br label %bb1184

bb1184:                                              ; 0x1184
  %cmp_le = icmp sle i32 %len, 0
  br label %bb1186

bb1186:                                              ; 0x1186
  br i1 %cmp_le, label %bb11a0, label %bb1188

bb1188:                                              ; 0x1188
  %len64 = sext i32 %len to i64
  br label %bb118b

bb118b:                                              ; 0x118b
  br label %bb118d

bb118d:                                              ; 0x118d
  br label %bb1199

bb118f:                                              ; 0x118f (alignment)
  unreachable

bb1190:                                              ; 0x1190
  %idx_next = add i64 %idx_cur, 1
  br label %bb1194

bb1194:                                              ; 0x1194
  %end_reached = icmp eq i64 %idx_next, %len64
  br label %bb1197

bb1197:                                              ; 0x1197
  br i1 %end_reached, label %bb11a0, label %bb1199

bb1199:                                              ; 0x1199
  %idx_cur = phi i64 [ 0, %bb118d ], [ %idx_next, %bb1197 ]
  %eltptr = getelementptr inbounds i32, i32* %arr, i64 %idx_cur
  %elt = load i32, i32* %eltptr, align 4
  %eq = icmp eq i32 %elt, %val
  br label %bb119c

bb119c:                                              ; 0x119c
  br i1 %eq, label %bb119e, label %bb1190

bb119e:                                              ; 0x119e
  %ret_trunc = trunc i64 %idx_cur to i32
  ret i32 %ret_trunc

bb119f:                                              ; 0x119f (alignment)
  unreachable

bb11a0:                                              ; 0x11a0
  ret i32 -1
}