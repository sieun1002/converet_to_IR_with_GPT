; ModuleID = 'quick_sort_module'
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @quick_sort(i32* nocapture %base, i64 %lo, i64 %hi) local_unnamed_addr nounwind {
entry_1220:
  %cmp_entry = icmp sge i64 %lo, %hi
  br i1 %cmp_entry, label %locret_1312, label %loc_123A

loc_123A: ; 0x123A
  %lo_cur = phi i64 [ %lo, %entry_1220 ], [ %lo_next, %loc_12B2 ]
  %hi_cur = phi i64 [ %hi, %entry_1220 ], [ %hi_next, %loc_12B2 ]
  %range = sub i64 %hi_cur, %lo_cur
  %half = ashr i64 %range, 1
  %mid = add i64 %lo_cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  %i0 = add i64 %lo_cur, 0
  %j0 = add i64 %hi_cur, 0
  %nexti0 = add i64 %lo_cur, 1
  %j4_0 = shl i64 %j0, 2
  br label %loc_1260

loc_1260: ; 0x1260
  %i = phi i64 [ %i0, %loc_123A ], [ %i_next, %loc_12DB ]
  %j = phi i64 [ %j0, %loc_123A ], [ %j_db, %loc_12DB ]
  %nexti = phi i64 [ %nexti0, %loc_123A ], [ %nexti_db, %loc_12DB ]
  %j4 = phi i64 [ %j4_0, %loc_123A ], [ %j4_db, %loc_12DB ]
  %i.ptr = getelementptr inbounds i32, i32* %base, i64 %i
  %i.val = load i32, i32* %i.ptr, align 4
  %base.i8 = bitcast i32* %base to i8*
  %jptr.i8 = getelementptr inbounds i8, i8* %base.i8, i64 %j4
  %j.ptr0 = bitcast i8* %jptr.i8 to i32*
  %j.val0 = load i32, i32* %j.ptr0, align 4
  %cmp_i_pivot = icmp slt i32 %i.val, %pivot
  br i1 %cmp_i_pivot, label %loc_12DB, label %after_i_cmp_1271

after_i_cmp_1271: ; 0x1271 compare pivot vs j.val0
  %cmp_pivot_j = icmp sge i32 %pivot, %j.val0
  br i1 %cmp_pivot_j, label %loc_1291, label %prep_1275

prep_1275: ; 0x1275 preheader for 0x1280
  %j.minus1 = add i64 %j, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %base, i64 %j.minus1
  br label %loc_1280

loc_1280: ; 0x1280
  %cur.ptr = phi i32* [ %ptr.jm1, %prep_1275 ], [ %next.ptr, %loc_1280 ]
  %j.loop = phi i64 [ %j, %prep_1275 ], [ %j.dec, %loc_1280 ]
  %j.val.loop = load i32, i32* %cur.ptr, align 4
  %next.ptr = getelementptr inbounds i32, i32* %cur.ptr, i64 -1
  %j.dec = add i64 %j.loop, -1
  %cmp_j_pivot = icmp sgt i32 %j.val.loop, %pivot
  br i1 %cmp_j_pivot, label %loc_1280, label %loc_1291

loc_1291: ; 0x1291
  %rcx.ptr = phi i32* [ %j.ptr0, %after_i_cmp_1271 ], [ %cur.ptr, %loc_1280 ]
  %j.val = phi i32 [ %j.val0, %after_i_cmp_1271 ], [ %j.val.loop, %loc_1280 ]
  %j.at.1291 = phi i64 [ %j, %after_i_cmp_1271 ], [ %j.dec, %loc_1280 ]
  %r14.from.1291 = add i64 %i, 0
  %cmp_i_le_j = icmp sle i64 %i, %j.at.1291
  br i1 %cmp_i_le_j, label %loc_12C0, label %loc_1299

loc_12C0: ; 0x12C0
  %j.after.swap.dec = add i64 %j.at.1291, -1
  store i32 %j.val, i32* %i.ptr, align 4
  %r14.after.swap = add i64 %nexti, 0
  store i32 %i.val, i32* %rcx.ptr, align 4
  %cmp_nexti_gt_j = icmp sgt i64 %nexti, %j.after.swap.dec
  br i1 %cmp_nexti_gt_j, label %loc_1299, label %loc_12D3

loc_12D3: ; 0x12D3
  %j4.new = shl i64 %j.after.swap.dec, 2
  br label %loc_12DB

loc_12DB: ; 0x12DB
  %j_db = phi i64 [ %j, %loc_1260 ], [ %j.after.swap.dec, %loc_12D3 ]
  %j4_db = phi i64 [ %j4, %loc_1260 ], [ %j4.new, %loc_12D3 ]
  %nexti_db = add i64 %nexti, 1
  %i_next = add i64 %i, 1
  br label %loc_1260

loc_1299: ; 0x1299
  %r14.part = phi i64 [ %r14.from.1291, %loc_1291 ], [ %r14.after.swap, %loc_12C0 ]
  %j.curr = phi i64 [ %j.at.1291, %loc_1291 ], [ %j.after.swap.dec, %loc_12C0 ]
  %left.len = sub i64 %j.curr, %lo_cur
  %right.len = sub i64 %hi_cur, %r14.part
  %cmp_left_ge_right = icmp sge i64 %left.len, %right.len
  br i1 %cmp_left_ge_right, label %loc_12E8, label %loc_12AA

loc_12AA: ; 0x12AA
  %cmp_j_gt_lo = icmp sgt i64 %j.curr, %lo_cur
  br i1 %cmp_j_gt_lo, label %loc_12F2, label %loc_12AF

loc_12F2: ; 0x12F2
  call void @quick_sort(i32* %base, i64 %lo_cur, i64 %j.curr)
  br label %loc_12AF

loc_12AF: ; 0x12AF
  %lo_next_from_12AF = add i64 %r14.part, 0
  %hi_next_from_12AF = add i64 %hi_cur, 0
  br label %loc_12B2

loc_12E8: ; 0x12E8
  %cmp_r14_lt_hi = icmp slt i64 %r14.part, %hi_cur
  br i1 %cmp_r14_lt_hi, label %loc_1302, label %loc_12ED

loc_1302: ; 0x1302
  call void @quick_sort(i32* %base, i64 %r14.part, i64 %hi_cur)
  br label %loc_12ED

loc_12ED: ; 0x12ED
  %lo_next_from_12ED = add i64 %lo_cur, 0
  %hi_next_from_12ED = add i64 %j.curr, 0
  br label %loc_12B2

loc_12B2: ; 0x12B2
  %lo_next = phi i64 [ %lo_next_from_12AF, %loc_12AF ], [ %lo_next_from_12ED, %loc_12ED ]
  %hi_next = phi i64 [ %hi_next_from_12AF, %loc_12AF ], [ %hi_next_from_12ED, %loc_12ED ]
  %cmp_continue = icmp sgt i64 %hi_next, %lo_next
  br i1 %cmp_continue, label %loc_123A, label %ret_epilogue

ret_epilogue:
  ret void

locret_1312: ; 0x1312
  ret void
}