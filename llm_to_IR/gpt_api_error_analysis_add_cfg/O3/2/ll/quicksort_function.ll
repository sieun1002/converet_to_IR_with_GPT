; ModuleID = 'qs_module'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @quick_sort(i32* %arr, i64 %lo, i64 %hi) {
loc_1220:
  %cmp_entry = icmp sge i64 %lo, %hi
  br i1 %cmp_entry, label %locret_1312, label %loc_123A

loc_123A:                                              ; preds = %loc_1220, %loc_12B2
  %lo.123A = phi i64 [ %lo, %loc_1220 ], [ %lo.B2, %loc_12B2 ]
  %hi.123A = phi i64 [ %hi, %loc_1220 ], [ %hi.B2, %loc_12B2 ]
  %i.init = add i64 %lo.123A, 0
  %j.init = add i64 %hi.123A, 0
  %iNext.init = add i64 %lo.123A, 1
  %range0 = sub i64 %hi.123A, %lo.123A
  %half0 = ashr i64 %range0, 1
  %mid0 = add i64 %lo.123A, %half0
  %pivot.ptr0 = getelementptr inbounds i32, i32* %arr, i64 %mid0
  %pivot0 = load i32, i32* %pivot.ptr0, align 4
  br label %loc_1260

loc_1260:                                              ; preds = %loc_123A, %loc_12DB
  %lo.l1260 = phi i64 [ %lo.123A, %loc_123A ], [ %lo.l12DB, %loc_12DB ]
  %hi.l1260 = phi i64 [ %hi.123A, %loc_123A ], [ %hi.l12DB, %loc_12DB ]
  %i.l1260 = phi i64 [ %i.init, %loc_123A ], [ %i.next.l12DB, %loc_12DB ]
  %iNext.l1260 = phi i64 [ %iNext.init, %loc_123A ], [ %iNext.next.l12DB, %loc_12DB ]
  %j.l1260 = phi i64 [ %j.init, %loc_123A ], [ %j.l12DB, %loc_12DB ]
  %pivot.l1260 = phi i32 [ %pivot0, %loc_123A ], [ %pivot.l12DB, %loc_12DB ]
  %ptr.i.l1260 = getelementptr inbounds i32, i32* %arr, i64 %i.l1260
  %val.i.l1260 = load i32, i32* %ptr.i.l1260, align 4
  %ptr.j.l1260 = getelementptr inbounds i32, i32* %arr, i64 %j.l1260
  %val.j.l1260 = load i32, i32* %ptr.j.l1260, align 4
  %cmp_126f = icmp slt i32 %val.i.l1260, %pivot.l1260
  br i1 %cmp_126f, label %loc_12DB, label %bb_1271

bb_1271:                                               ; preds = %loc_1260
  %cmp_1273 = icmp sge i32 %pivot.l1260, %val.j.l1260
  br i1 %cmp_1273, label %loc_1291, label %loc_1280.pre

loc_1280.pre:                                          ; preds = %bb_1271
  %j.pre.dec = add i64 %j.l1260, -1
  br label %loc_1280

loc_1280:                                              ; preds = %loc_1280, %loc_1280.pre
  %lo.l1280 = phi i64 [ %lo.l1260, %loc_1280.pre ], [ %lo.l1280, %loc_1280 ]
  %hi.l1280 = phi i64 [ %hi.l1260, %loc_1280.pre ], [ %hi.l1280, %loc_1280 ]
  %i.l1280 = phi i64 [ %i.l1260, %loc_1280.pre ], [ %i.l1280, %loc_1280 ]
  %iNext.l1280 = phi i64 [ %iNext.l1260, %loc_1280.pre ], [ %iNext.l1280, %loc_1280 ]
  %pivot.l1280 = phi i32 [ %pivot.l1260, %loc_1280.pre ], [ %pivot.l1280, %loc_1280 ]
  %j.curr = phi i64 [ %j.pre.dec, %loc_1280.pre ], [ %j.next, %loc_1280 ]
  %ptr.j.l1280 = getelementptr inbounds i32, i32* %arr, i64 %j.curr
  %val.j.l1280 = load i32, i32* %ptr.j.l1280, align 4
  %cmp_128f = icmp sgt i32 %val.j.l1280, %pivot.l1280
  %j.next = add i64 %j.curr, -1
  br i1 %cmp_128f, label %loc_1280, label %loc_1291

loc_1291:                                              ; preds = %bb_1271, %loc_1280
  %lo.l1291 = phi i64 [ %lo.l1260, %bb_1271 ], [ %lo.l1280, %loc_1280 ]
  %hi.l1291 = phi i64 [ %hi.l1260, %bb_1271 ], [ %hi.l1280, %loc_1280 ]
  %i.l1291 = phi i64 [ %i.l1260, %bb_1271 ], [ %i.l1280, %loc_1280 ]
  %iNext.l1291 = phi i64 [ %iNext.l1260, %bb_1271 ], [ %iNext.l1280, %loc_1280 ]
  %j.l1291 = phi i64 [ %j.l1260, %bb_1271 ], [ %j.curr, %loc_1280 ]
  %pivot.l1291 = phi i32 [ %pivot.l1260, %bb_1271 ], [ %pivot.l1280, %loc_1280 ]
  %ptr.i.l1291 = getelementptr inbounds i32, i32* %arr, i64 %i.l1291
  %val.i.l1291 = load i32, i32* %ptr.i.l1291, align 4
  %ptr.j.l1291 = getelementptr inbounds i32, i32* %arr, i64 %j.l1291
  %val.j.l1291 = load i32, i32* %ptr.j.l1291, align 4
  %cmp_1297 = icmp sle i64 %i.l1291, %j.l1291
  br i1 %cmp_1297, label %loc_12C0, label %loc_1299

loc_12C0:                                              ; preds = %loc_1291
  %lo.l12C0 = add i64 %lo.l1291, 0
  %hi.l12C0 = add i64 %hi.l1291, 0
  %i.l12C0 = add i64 %i.l1291, 0
  %iNext.l12C0 = add i64 %iNext.l1291, 0
  %j.dec.l12C0 = add i64 %j.l1291, -1
  store i32 %val.j.l1291, i32* %ptr.i.l1291, align 4
  store i32 %val.i.l1291, i32* %ptr.j.l1291, align 4
  %cmp_12d1 = icmp sgt i64 %iNext.l12C0, %j.dec.l12C0
  br i1 %cmp_12d1, label %loc_1299, label %loc_12DB

loc_12DB:                                              ; preds = %loc_1260, %loc_12C0
  %lo.l12DB = phi i64 [ %lo.l1260, %loc_1260 ], [ %lo.l12C0, %loc_12C0 ]
  %hi.l12DB = phi i64 [ %hi.l1260, %loc_1260 ], [ %hi.l12C0, %loc_12C0 ]
  %i.in.l12DB = phi i64 [ %i.l1260, %loc_1260 ], [ %i.l12C0, %loc_12C0 ]
  %iNext.in.l12DB = phi i64 [ %iNext.l1260, %loc_1260 ], [ %iNext.l12C0, %loc_12C0 ]
  %j.l12DB = phi i64 [ %j.l1260, %loc_1260 ], [ %j.dec.l12C0, %loc_12C0 ]
  %pivot.l12DB = phi i32 [ %pivot.l1260, %loc_1260 ], [ %pivot.l1291, %loc_12C0 ]
  %i.next.l12DB = add i64 %i.in.l12DB, 1
  %iNext.next.l12DB = add i64 %iNext.in.l12DB, 1
  br label %loc_1260

loc_1299:                                              ; preds = %loc_1291, %loc_12C0
  %lo.l1299 = phi i64 [ %lo.l1291, %loc_1291 ], [ %lo.l12C0, %loc_12C0 ]
  %hi.l1299 = phi i64 [ %hi.l1291, %loc_1291 ], [ %hi.l12C0, %loc_12C0 ]
  %j.end.l1299 = phi i64 [ %j.l1291, %loc_1291 ], [ %j.dec.l12C0, %loc_12C0 ]
  %splitStart.l1299 = phi i64 [ %i.l1291, %loc_1291 ], [ %iNext.l12C0, %loc_12C0 ]
  %left.len = sub i64 %j.end.l1299, %lo.l1299
  %right.len = sub i64 %hi.l1299, %splitStart.l1299
  %cmp_12a8 = icmp sge i64 %left.len, %right.len
  br i1 %cmp_12a8, label %loc_12E8, label %loc_12AA

loc_12AA:                                              ; preds = %loc_1299
  %cmp_12ad = icmp sgt i64 %j.end.l1299, %lo.l1299
  br i1 %cmp_12ad, label %loc_12F2, label %loc_12AF

loc_12E8:                                              ; preds = %loc_1299
  %cmp_12eb = icmp slt i64 %splitStart.l1299, %hi.l1299
  br i1 %cmp_12eb, label %loc_1302, label %loc_12ED

loc_12F2:                                              ; preds = %loc_12AA
  call void @quick_sort(i32* %arr, i64 %lo.l1299, i64 %j.end.l1299)
  br label %loc_12AF

loc_12AF:                                              ; preds = %loc_12F2, %loc_12AA
  %lo.to.12B2 = add i64 %splitStart.l1299, 0
  %hi.to.12B2 = add i64 %hi.l1299, 0
  br label %loc_12B2

loc_1302:                                              ; preds = %loc_12E8
  call void @quick_sort(i32* %arr, i64 %splitStart.l1299, i64 %hi.l1299)
  br label %loc_12ED

loc_12ED:                                              ; preds = %loc_1302, %loc_12E8
  %lo.to.12B2.ed = add i64 %lo.l1299, 0
  %hi.new.l12ED = add i64 %j.end.l1299, 0
  br label %loc_12B2

loc_12B2:                                              ; preds = %loc_12AF, %loc_12ED
  %lo.B2 = phi i64 [ %lo.to.12B2, %loc_12AF ], [ %lo.to.12B2.ed, %loc_12ED ]
  %hi.B2 = phi i64 [ %hi.to.12B2, %loc_12AF ], [ %hi.new.l12ED, %loc_12ED ]
  %cmp_12b5 = icmp sgt i64 %hi.B2, %lo.B2
  br i1 %cmp_12b5, label %loc_123A, label %loc_12B7.ret

loc_12B7.ret:                                          ; preds = %loc_12B2
  ret void

locret_1312:                                           ; preds = %loc_1220
  ret void
}