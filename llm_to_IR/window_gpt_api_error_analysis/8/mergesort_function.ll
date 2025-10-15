; ModuleID = 'merge_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %init

init:
  %bytes = shl i64 %n, 2
  %mem = call i8* @malloc(i64 %bytes)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %ret, label %start

start:
  %block = bitcast i8* %mem to i32*
  br label %outer.header

outer.header:
  %width = phi i64 [ 1, %start ], [ %width.next, %outer.swap ]
  %srcCur = phi i32* [ %arr, %start ], [ %src.next, %outer.swap ]
  %bufCur = phi i32* [ %block, %start ], [ %buf.next, %outer.swap ]
  %cond_width = icmp ult i64 %width, %n
  br i1 %cond_width, label %inner.init, label %after.outer

inner.init:
  br label %inner.loop

inner.loop:
  %i = phi i64 [ 0, %inner.init ], [ %i.next, %inner.latch ]
  %cond_i = icmp ult i64 %i, %n
  br i1 %cond_i, label %merge.prepare, label %outer.swap

merge.prepare:
  %left = add i64 %i, 0
  %t_mid = add i64 %i, %width
  %mid.cmp = icmp ult i64 %t_mid, %n
  %mid.sel1 = select i1 %mid.cmp, i64 %t_mid, i64 %n
  %twoWidth = add i64 %width, %width
  %t_right = add i64 %i, %twoWidth
  %right.cmp = icmp ult i64 %t_right, %n
  %right.sel1 = select i1 %right.cmp, i64 %t_right, i64 %n
  br label %merge.loop

merge.loop:
  %iL = phi i64 [ %left, %merge.prepare ], [ %iL.after, %merge.latch ]
  %iR = phi i64 [ %mid.sel1, %merge.prepare ], [ %iR.after, %merge.latch ]
  %k = phi i64 [ %left, %merge.prepare ], [ %k.next, %merge.latch ]
  %kcond = icmp ult i64 %k, %right.sel1
  br i1 %kcond, label %merge.choose, label %inner.latch

merge.choose:
  %leftHas = icmp ult i64 %iL, %mid.sel1
  br i1 %leftHas, label %checkRight, label %chooseRight

checkRight:
  %rightHas = icmp ult i64 %iR, %right.sel1
  br i1 %rightHas, label %compareVals, label %chooseLeft

compareVals:
  %left.ptr = getelementptr inbounds i32, i32* %srcCur, i64 %iL
  %left.val = load i32, i32* %left.ptr, align 4
  %right.ptr = getelementptr inbounds i32, i32* %srcCur, i64 %iR
  %right.val = load i32, i32* %right.ptr, align 4
  %cmpLR = icmp sgt i32 %left.val, %right.val
  br i1 %cmpLR, label %chooseRight, label %chooseLeft

chooseLeft:
  %srcL.ptr = getelementptr inbounds i32, i32* %srcCur, i64 %iL
  %valL = load i32, i32* %srcL.ptr, align 4
  %dstL.ptr = getelementptr inbounds i32, i32* %bufCur, i64 %k
  store i32 %valL, i32* %dstL.ptr, align 4
  %iL.inc = add i64 %iL, 1
  br label %merge.latch

chooseRight:
  %srcR.ptr = getelementptr inbounds i32, i32* %srcCur, i64 %iR
  %valR = load i32, i32* %srcR.ptr, align 4
  %dstR.ptr = getelementptr inbounds i32, i32* %bufCur, i64 %k
  store i32 %valR, i32* %dstR.ptr, align 4
  %iR.inc = add i64 %iR, 1
  br label %merge.latch

merge.latch:
  %iL.after = phi i64 [ %iL.inc, %chooseLeft ], [ %iL, %chooseRight ]
  %iR.after = phi i64 [ %iR, %chooseLeft ], [ %iR.inc, %chooseRight ]
  %k.next = add i64 %k, 1
  br label %merge.loop

inner.latch:
  %twoWidth2 = add i64 %width, %width
  %i.next = add i64 %i, %twoWidth2
  br label %inner.loop

outer.swap:
  %src.next = getelementptr inbounds i32, i32* %bufCur, i64 0
  %buf.next = getelementptr inbounds i32, i32* %srcCur, i64 0
  %width.next = shl i64 %width, 1
  br label %outer.header

after.outer:
  %src.eq.arr = icmp eq i32* %srcCur, %arr
  br i1 %src.eq.arr, label %freeBlock, label %doMemcpy

doMemcpy:
  %dst8 = bitcast i32* %arr to i8*
  %src8 = bitcast i32* %srcCur to i8*
  %bytes2 = shl i64 %n, 2
  %memcpy.ret = call i8* @memcpy(i8* %dst8, i8* %src8, i64 %bytes2)
  br label %freeBlock

freeBlock:
  %block8 = bitcast i32* %block to i8*
  call void @free(i8* %block8)
  br label %ret

ret:
  ret void
}