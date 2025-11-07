; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

define void @quick_sort(i32* %arr, i64 %left, i64 %right) {
bb_1220:
  %cmp.entry = icmp sge i64 %left, %right
  br i1 %cmp.entry, label %bb_1312, label %bb_123A

bb_123A:                                                ; preds = %bb_1220, %bb_12B2, %bb_12AF
  %L.ph = phi i64 [ %left, %bb_1220 ], [ %L.pass, %bb_12B2 ], [ %newL, %bb_12AF ]
  %R.ph = phi i64 [ %right, %bb_1220 ], [ %newR, %bb_12B2 ], [ %R.cur.at12AF, %bb_12AF ]
  %Lplus1 = add i64 %L.ph, 1
  %diff.LR = sub i64 %R.ph, %L.ph
  %half = ashr i64 %diff.LR, 1
  %mid = add i64 %L.ph, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot.init = load i32, i32* %pivot.ptr, align 4
  br label %bb_1260

bb_1260:                                                ; preds = %bb_123A, %bb_12DB
  %i.cur = phi i64 [ %L.ph, %bb_123A ], [ %i.next, %bb_12DB ]
  %r9.cur = phi i64 [ %Lplus1, %bb_123A ], [ %r9.next, %bb_12DB ]
  %rbx.cur = phi i64 [ %R.ph, %bb_123A ], [ %rbx.12DB.in, %bb_12DB ]
  %idxRCX.cur = phi i64 [ %R.ph, %bb_123A ], [ %idxRCX.12DB.in, %bb_12DB ]
  %L.cur = phi i64 [ %L.ph, %bb_123A ], [ %L.cur, %bb_12DB ]
  %R.cur = phi i64 [ %R.ph, %bb_123A ], [ %R.cur, %bb_12DB ]
  %pivot.cur = phi i32 [ %pivot.init, %bb_123A ], [ %pivot.cur, %bb_12DB ]
  %ai.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %ai = load i32, i32* %ai.ptr, align 4
  %rcx.ptr.cur = getelementptr inbounds i32, i32* %arr, i64 %idxRCX.cur
  %edx.cur = load i32, i32* %rcx.ptr.cur, align 4
  %cmp.ai.pivot = icmp slt i32 %ai, %pivot.cur
  br i1 %cmp.ai.pivot, label %bb_12DB, label %bb_1260.c2

bb_1260.c2:
  %cmp.pivot.edx = icmp sge i32 %pivot.cur, %edx.cur
  %k.init = add i64 %idxRCX.cur, -1
  %rbx.init.dec = add i64 %rbx.cur, -1
  br i1 %cmp.pivot.edx, label %bb_1291, label %bb_1280

bb_1280:                                                ; preds = %bb_1260.c2, %bb_1280
  %k = phi i64 [ %k.init, %bb_1260.c2 ], [ %k.dec, %bb_1280 ]
  %rbx.scan = phi i64 [ %rbx.init.dec, %bb_1260.c2 ], [ %rbx.scan.dec, %bb_1280 ]
  %ptr.k = getelementptr inbounds i32, i32* %arr, i64 %k
  %val.k = load i32, i32* %ptr.k, align 4
  %cmp.valk.pivot = icmp sgt i32 %val.k, %pivot.cur
  %k.dec = add i64 %k, -1
  %rbx.scan.dec = add i64 %rbx.scan, -1
  br i1 %cmp.valk.pivot, label %bb_1280, label %bb_1291

bb_1291:                                                ; preds = %bb_1260.c2, %bb_1280
  %rbx.for1291 = phi i64 [ %rbx.cur, %bb_1260.c2 ], [ %rbx.scan, %bb_1280 ]
  %rcx.idx.for1291 = phi i64 [ %idxRCX.cur, %bb_1260.c2 ], [ %k, %bb_1280 ]
  %i.for1291 = phi i64 [ %i.cur, %bb_1260.c2 ], [ %i.cur, %bb_1280 ]
  %cmp.i.le.rbx = icmp sle i64 %i.for1291, %rbx.for1291
  br i1 %cmp.i.le.rbx, label %bb_12C0, label %bb_1299

bb_12C0:                                                ; preds = %bb_1291
  %rbx.dec = add i64 %rbx.for1291, -1
  %ptr.i.swap = getelementptr inbounds i32, i32* %arr, i64 %i.for1291
  %ptr.rcx.swap = getelementptr inbounds i32, i32* %arr, i64 %rcx.idx.for1291
  %val.rcx = load i32, i32* %ptr.rcx.swap, align 4
  store i32 %val.rcx, i32* %ptr.i.swap, align 4
  %r14.set = add i64 %r9.cur, 0
  store i32 %ai, i32* %ptr.rcx.swap, align 4
  %cmp.r9.gt.rbxdec = icmp sgt i64 %r9.cur, %rbx.dec
  br i1 %cmp.r9.gt.rbxdec, label %bb_1299, label %bb_12D3

bb_12D3:                                                ; preds = %bb_12C0
  %idxRCX.new = add i64 %rbx.dec, 0
  br label %bb_12DB

bb_12DB:                                                ; preds = %bb_1260, %bb_12D3
  %idxRCX.12DB.in = phi i64 [ %idxRCX.cur, %bb_1260 ], [ %idxRCX.new, %bb_12D3 ]
  %rbx.12DB.in = phi i64 [ %rbx.cur, %bb_1260 ], [ %rbx.dec, %bb_12D3 ]
  %i.12DB.in = phi i64 [ %i.cur, %bb_1260 ], [ %i.for1291, %bb_12D3 ]
  %r9.12DB.in = phi i64 [ %r9.cur, %bb_1260 ], [ %r9.cur, %bb_12D3 ]
  %i.next = add i64 %i.12DB.in, 1
  %r9.next = add i64 %r9.12DB.in, 1
  br label %bb_1260

bb_1299:                                                ; preds = %bb_1291, %bb_12C0
  %rbx.part = phi i64 [ %rbx.for1291, %bb_1291 ], [ %rbx.dec, %bb_12C0 ]
  %r14.part = phi i64 [ %i.for1291, %bb_1291 ], [ %r14.set, %bb_12C0 ]
  %left.sz = sub i64 %rbx.part, %L.cur
  %right.sz = sub i64 %R.cur, %r14.part
  %cmp.left.ge.right = icmp sge i64 %left.sz, %right.sz
  br i1 %cmp.left.ge.right, label %bb_12E8, label %bb_1299_else

bb_1299_else:
  %cmp.left.exists = icmp sgt i64 %rbx.part, %L.cur
  br i1 %cmp.left.exists, label %bb_12F2, label %bb_12AF

bb_12F2:                                                ; preds = %bb_1299_else
  call void @quick_sort(i32* %arr, i64 %L.cur, i64 %rbx.part)
  br label %bb_12AF

bb_12AF:                                                ; preds = %bb_12F2, %bb_1299_else
  %newL = add i64 %r14.part, 0
  %R.cur.at12AF = add i64 %R.cur, 0
  %cmp.more.afterL = icmp sgt i64 %R.cur.at12AF, %newL
  br i1 %cmp.more.afterL, label %bb_123A, label %bb_epilogue

bb_12E8:                                                ; preds = %bb_1299
  %cmp.right.exists = icmp slt i64 %r14.part, %R.cur
  br i1 %cmp.right.exists, label %bb_1302, label %bb_12ED

bb_1302:                                                ; preds = %bb_12E8
  call void @quick_sort(i32* %arr, i64 %r14.part, i64 %R.cur)
  br label %bb_12ED

bb_12ED:                                                ; preds = %bb_1302, %bb_12E8
  %newR = add i64 %rbx.part, 0
  %L.through.12ED = add i64 %L.cur, 0
  br label %bb_12B2

bb_12B2:                                                ; preds = %bb_12ED
  %L.pass = add i64 %L.through.12ED, 0
  %cmp.more.afterR = icmp sgt i64 %newR, %L.pass
  br i1 %cmp.more.afterR, label %bb_123A, label %bb_epilogue

bb_epilogue:
  ret void

bb_1312:                                                ; preds = %bb_1220
  ret void
}