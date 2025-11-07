; ModuleID = 'linear_search'
target triple = "x86_64-pc-linux-gnu"

define i32 @linear_search(i32* %arr, i32 %n, i32 %value) {
bb_1180:                                           ; 0x1180
  %cmp_entry = icmp sle i32 %n, 0
  br i1 %cmp_entry, label %bb_11a0, label %bb_1188

bb_1188:                                           ; 0x1188..0x118d (no label in asm)
  %n64 = sext i32 %n to i64
  br label %bb_1199

bb_1190:                                           ; 0x1190
  %idx.next = add i64 %idx, 1
  %at_end = icmp eq i64 %idx.next, %n64
  br i1 %at_end, label %bb_11a0, label %bb_1199

bb_1199:                                           ; 0x1199
  %idx = phi i64 [ 0, %bb_1188 ], [ %idx.next, %bb_1190 ]
  %elt.ptr = getelementptr i32, i32* %arr, i64 %idx
  %elt = load i32, i32* %elt.ptr, align 4
  %ne = icmp ne i32 %elt, %value
  br i1 %ne, label %bb_1190, label %bb_119e

bb_119e:                                           ; 0x119e
  %retidx = trunc i64 %idx to i32
  ret i32 %retidx

bb_11a0:                                           ; 0x11a0
  ret i32 -1
}