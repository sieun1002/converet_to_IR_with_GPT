; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

define i32 @linear_search(i32* %arr, i32 %n, i32 %key) {
bb_1180:
  ; endbr64
  %cmp_n_nonpos = icmp sle i32 %n, 0
  %n64 = sext i32 %n to i64
  br i1 %cmp_n_nonpos, label %bb_11a0, label %bb_1199

bb_1190:
  %i.inc = add i64 %i.cur, 1
  %cmp_end = icmp eq i64 %i.inc, %n64
  br i1 %cmp_end, label %bb_11a0, label %bb_1199

bb_1199:
  %i.cur = phi i64 [ 0, %bb_1180 ], [ %i.inc, %bb_1190 ]
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %key
  br i1 %eq, label %bb_119e, label %bb_1190

bb_119e:
  %ret = trunc i64 %i.cur to i32
  ret i32 %ret

bb_11a0:
  ret i32 -1
}