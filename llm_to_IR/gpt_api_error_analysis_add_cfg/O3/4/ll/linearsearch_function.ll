; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

define i32 @linear_search(i32* %arr, i32 %n, i32 %value) {
bb.0x1180:
  call void asm sideeffect "endbr64", ""()
  %cmp_n_le_zero = icmp sle i32 %n, 0
  br i1 %cmp_n_le_zero, label %bb.0x11a0, label %bb.0x1188

bb.0x1188:
  %n64 = sext i32 %n to i64
  br label %bb.0x1199

bb.0x118f:
  unreachable

bb.0x1190:
  %inc = add i64 %idx, 1
  %cmp_eq_len = icmp eq i64 %inc, %n64
  br i1 %cmp_eq_len, label %bb.0x11a0, label %bb.0x1199

bb.0x1199:
  %idx = phi i64 [ 0, %bb.0x1188 ], [ %inc, %bb.0x1190 ]
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx
  %elem = load i32, i32* %elem.ptr, align 4
  %cmp_ne = icmp ne i32 %elem, %value
  br i1 %cmp_ne, label %bb.0x1190, label %bb.0x119e

bb.0x119e:
  %ret.trunc = trunc i64 %idx to i32
  ret i32 %ret.trunc

bb.0x119f:
  unreachable

bb.0x11a0:
  ret i32 -1
}