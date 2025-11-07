; ModuleID = 'linear_search'
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @linear_search(i32* noundef %arr, i32 noundef %n, i32 noundef %target) {
block_1180:
  br label %block_1184

block_1184:
  %cmp.le.zero = icmp sle i32 %n, 0
  br i1 %cmp.le.zero, label %block_11a0, label %block_1188

block_1188:
  %n64 = sext i32 %n to i64
  br label %block_1199

block_1199:
  %idx = phi i64 [ 0, %block_1188 ], [ %idx.next, %block_1190 ]
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx
  %elem = load i32, i32* %elem.ptr
  %cmp.ne = icmp ne i32 %elem, %target
  br i1 %cmp.ne, label %block_1190, label %block_119e

block_1190:
  %idx.next = add i64 %idx, 1
  %at.limit = icmp eq i64 %idx.next, %n64
  br i1 %at.limit, label %block_11a0, label %block_1199

block_119e:
  %ret.idx = trunc i64 %idx to i32
  ret i32 %ret.idx

block_11a0:
  ret i32 -1
}