; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

define i32 @linear_search(i32* %arr, i32 %n, i32 %value) {
entry_1180:
  ; endbr64 (no-op)
  %cmp_le = icmp sle i32 %n, 0
  br i1 %cmp_le, label %bb_11A0, label %bb_1188

bb_1188:
  %n64 = sext i32 %n to i64
  br label %bb_1199

bb_1199:
  %idx = phi i64 [ 0, %bb_1188 ], [ %idx_inc, %bb_1190 ]
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %idx
  %elem = load i32, i32* %ptr, align 4
  %cmp_ne = icmp ne i32 %elem, %value
  br i1 %cmp_ne, label %bb_1190, label %bb_119e

bb_1190:
  %idx_inc = add i64 %idx, 1
  %done = icmp eq i64 %idx_inc, %n64
  br i1 %done, label %bb_11A0, label %bb_1199

bb_119e:
  %ret_trunc = trunc i64 %idx to i32
  ret i32 %ret_trunc

bb_11A0:
  ret i32 -1
}