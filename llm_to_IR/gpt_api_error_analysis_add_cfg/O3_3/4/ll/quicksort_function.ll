; ModuleID = 'quick_sort_recovered'
target triple = "x86_64-pc-linux-gnu"

define void @quick_sort(i32* %base, i64 %low, i64 %high) {
loc_1220:
  %cmp_entry = icmp sge i64 %low, %high
  br i1 %cmp_entry, label %locret_1312, label %loc_123A

loc_123A:
  %low.cur = phi i64 [ %low, %loc_1220 ], [ %low.tail, %loc_12B2 ]
  %high.cur = phi i64 [ %high, %loc_1220 ], [ %high.tail, %loc_12B2 ]
  %i.init = add i64 %low.cur, 0
  %j.init = add i64 %high.cur, 0
  %ip1.init = add i64 %low.cur, 1
  %diff = sub i64 %high.cur, %low.cur
  %half = ashr i64 %diff, 1
  %mid = add i64 %low.cur, %half
  %mid.ptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %pivot = load i32, i32* %mid.ptr, align 4
  br label %loc_1260

loc_1260:
  %i.phi = phi i64 [ %i.init, %loc_123A ], [ %i.next, %loc_12DB ]
  %j.phi = phi i64 [ %j.init, %loc_123A ], [ %j.same2, %loc_12DB ]
  %ip1.phi = phi i64 [ %ip1.init, %loc_123A ], [ %ip1.next, %loc_12DB ]
  %L.ptr = getelementptr inbounds i32, i32* %base, i64 %i.phi
  %L = load i32, i32* %L.ptr, align 4
  %R.ptr0 = getelementptr inbounds i32, i32* %base, i64 %j.phi
  %R0 = load i32, i32* %R.ptr0, align 4
  %condLltP = icmp slt i32 %L, %pivot
  br i1 %condLltP, label %loc_12DB, label %loc_1271

loc_1271:
  %condPgeR = icmp sge i32 %pivot, %R0
  %j.init.for.1280 = add i64 %j.phi, -1
  br i1 %condPgeR, label %loc_1291, label %loc_1280

loc_1280:
  %j.loop = phi i64 [ %j.dec2, %loc_1280 ], [ %j.init.for.1280, %loc_1271 ]
  %pivot.loop = phi i32 [ %pivot.loop, %loc_1280 ], [ %pivot, %loc_1271 ]
  %i.static = phi i64 [ %i.static, %loc_1280 ], [ %i.phi, %loc_1271 ]
  %ip1.static = phi i64 [ %ip1.static, %loc_1280 ], [ %ip1.phi, %loc_1271 ]
  %L.static = phi i32 [ %L.static, %loc_1280 ], [ %L, %loc_1271 ]
  %R.ptr.loop = getelementptr inbounds i32, i32* %base, i64 %j.loop
  %R.loop = load i32, i32* %R.ptr.loop, align 4
  %condRgtP = icmp sgt i32 %R.loop, %pivot.loop
  %j.dec2 = add i64 %j.loop, -1
  br i1 %condRgtP, label %loc_1280, label %loc_1291

loc_1291:
  %i.in = phi i64 [ %i.phi, %loc_1271 ], [ %i.static, %loc_1280 ]
  %ip1.in = phi i64 [ %ip1.phi, %loc_1271 ], [ %ip1.static, %loc_1280 ]
  %j.in = phi i64 [ %j.phi, %loc_1271 ], [ %j.loop, %loc_1280 ]
  %R.in = phi i32 [ %R0, %loc_1271 ], [ %R.loop, %loc_1280 ]
  %R.ptr.in = phi i32* [ %R.ptr0, %loc_1271 ], [ %R.ptr.loop, %loc_1280 ]
  %L.in = phi i32 [ %L, %loc_1271 ], [ %L.static, %loc_1280 ]
  %pivot.in = phi i32 [ %pivot, %loc_1271 ], [ %pivot.loop, %loc_1280 ]
  %r14.from.1291 = add i64 %i.in, 0
  %condIleJ = icmp sle i64 %i.in, %j.in
  br i1 %condIleJ, label %loc_12C0, label %loc_1299

loc_1299:
  %j.at.1299 = phi i64 [ %j.in, %loc_1291 ], [ %j.dec.after.swap, %loc_12C0 ]
  %r14.at.1299 = phi i64 [ %r14.from.1291, %loc_1291 ], [ %r14.from.12C0, %loc_12C0 ]
  %lenL = sub i64 %j.at.1299, %low.cur
  %lenR = sub i64 %high.cur, %r14.at.1299
  %condLenGe = icmp sge i64 %lenL, %lenR
  br i1 %condLenGe, label %loc_12E8, label %loc_12AA

loc_12AA:
  %condJgtLow = icmp sgt i64 %j.at.1299, %low.cur
  br i1 %condJgtLow, label %loc_12F2, label %loc_12AF

loc_12AF:
  %low.after.12AF = add i64 %r14.at.1299, 0
  br label %loc_12B2

loc_12B2:
  %low.tail = phi i64 [ %low.after.12AF, %loc_12AF ], [ %low.cur, %loc_12ED ]
  %high.tail = phi i64 [ %high.cur, %loc_12AF ], [ %high.after.12ED, %loc_12ED ]
  %condHighGtLow = icmp sgt i64 %high.tail, %low.tail
  br i1 %condHighGtLow, label %loc_123A, label %loc_12B7

loc_12B7:
  ret void

loc_12C0:
  %j.dec.after.swap = add i64 %j.in, -1
  %i.ptr.c0 = getelementptr inbounds i32, i32* %base, i64 %i.in
  store i32 %R.in, i32* %i.ptr.c0, align 4
  %r14.from.12C0 = add i64 %ip1.in, 0
  store i32 %L.in, i32* %R.ptr.in, align 4
  %condIp1GtJdec = icmp sgt i64 %ip1.in, %j.dec.after.swap
  br i1 %condIp1GtJdec, label %loc_1299, label %loc_12D3

loc_12D3:
  br label %loc_12DB

loc_12DB:
  %i.prev.for.inc = phi i64 [ %i.phi, %loc_1260 ], [ %i.in, %loc_12D3 ]
  %ip1.prev.for.inc = phi i64 [ %ip1.phi, %loc_1260 ], [ %ip1.in, %loc_12D3 ]
  %j.prev.for.keep = phi i64 [ %j.phi, %loc_1260 ], [ %j.dec.after.swap, %loc_12D3 ]
  %i.next = add i64 %i.prev.for.inc, 1
  %ip1.next = add i64 %ip1.prev.for.inc, 1
  %j.same2 = add i64 %j.prev.for.keep, 0
  br label %loc_1260

loc_12E8:
  %condR14ltHigh = icmp slt i64 %r14.at.1299, %high.cur
  br i1 %condR14ltHigh, label %loc_1302, label %loc_12ED

loc_12ED:
  %high.after.12ED = add i64 %j.at.1299, 0
  br label %loc_12B2

loc_12F2:
  call void @quick_sort(i32* %base, i64 %low.cur, i64 %j.at.1299)
  br label %loc_12AF

loc_1302:
  call void @quick_sort(i32* %base, i64 %r14.at.1299, i64 %high.cur)
  br label %loc_12ED

locret_1312:
  ret void
}