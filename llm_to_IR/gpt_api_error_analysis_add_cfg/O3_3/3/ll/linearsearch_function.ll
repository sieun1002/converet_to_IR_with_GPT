; ModuleID = 'linear_search'
target triple = "x86_64-unknown-linux-gnu"

define i32 @linear_search(i32* %arr, i32 %n, i32 %val) {
loc_1180:
  %cmp0 = icmp sle i32 %n, 0
  br i1 %cmp0, label %loc_11A0, label %loc_1188

loc_1188:                                           ; 0x1188..0x118d fall-through
  %len = sext i32 %n to i64
  br label %loc_1199

loc_1190:                                           ; 0x1190
  %idx.next = add i64 %idx, 1
  %cmp1 = icmp eq i64 %idx.next, %len
  br i1 %cmp1, label %loc_11A0, label %loc_1199

loc_1199:                                           ; 0x1199
  %idx = phi i64 [ 0, %loc_1188 ], [ %idx.next, %loc_1190 ]
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx
  %elem = load i32, i32* %elem.ptr, align 4
  %cmp2 = icmp ne i32 %elem, %val
  br i1 %cmp2, label %loc_1190, label %loc_119E

loc_119E:                                           ; 0x119e
  %ret.trunc = trunc i64 %idx to i32
  ret i32 %ret.trunc

loc_11A0:                                           ; 0x11a0
  ret i32 -1
}