; ModuleID = 'merge_sort_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %arg_0, i64 %arg_8) {
entry:
  %cmp_n_le1 = icmp ule i64 %arg_8, 1
  br i1 %cmp_n_le1, label %end, label %alloc

alloc:
  %size.bytes = shl i64 %arg_8, 2
  %tmpraw = call i8* @malloc(i64 %size.bytes)
  %isnull = icmp eq i8* %tmpraw, null
  br i1 %isnull, label %end, label %init

init:
  %block = bitcast i8* %tmpraw to i32*
  br label %outer.cond

outer.cond:
  %src = phi i32* [ %arg_0, %init ], [ %src.next, %after.inner ]
  %dest = phi i32* [ %block, %init ], [ %dest.next, %after.inner ]
  %run = phi i64 [ 1, %init ], [ %run.next, %after.inner ]
  %run_lt_n = icmp ult i64 %run, %arg_8
  br i1 %run_lt_n, label %outer.body, label %after.outer

outer.body:
  br label %inner.cond

inner.cond:
  %offset = phi i64 [ 0, %outer.body ], [ %offset.next, %after.merge ]
  %offset_lt_n = icmp ult i64 %offset, %arg_8
  br i1 %offset_lt_n, label %compute.bounds, label %after.inner

compute.bounds:
  %tmp1 = add i64 %offset, %run
  %mid.lt = icmp ult i64 %tmp1, %arg_8
  %mid = select i1 %mid.lt, i64 %tmp1, i64 %arg_8
  %tworun = shl i64 %run, 1
  %tmp2 = add i64 %offset, %tworun
  %end.lt = icmp ult i64 %tmp2, %arg_8
  %endIdx = select i1 %end.lt, i64 %tmp2, i64 %arg_8
  br label %merge.cond

merge.cond:
  %i = phi i64 [ %offset, %compute.bounds ], [ %i.nextL, %merge.iterL ], [ %i.nextR, %merge.iterR ]
  %j = phi i64 [ %mid, %compute.bounds ], [ %j.sameL, %merge.iterL ], [ %j.nextR, %merge.iterR ]
  %k = phi i64 [ %offset, %compute.bounds ], [ %k.nextL, %merge.iterL ], [ %k.nextR, %merge.iterR ]
  %k_lt_end = icmp ult i64 %k, %endIdx
  br i1 %k_lt_end, label %merge.decide, label %after.merge

merge.decide:
  %i_lt_mid = icmp ult i64 %i, %mid
  br i1 %i_lt_mid, label %left.check, label %right.path

left.check:
  %j_lt_end = icmp ult i64 %j, %endIdx
  br i1 %j_lt_end, label %cmp.load, label %left.loadonly

cmp.load:
  %pi = getelementptr inbounds i32, i32* %src, i64 %i
  %ai = load i32, i32* %pi, align 4
  %pj = getelementptr inbounds i32, i32* %src, i64 %j
  %bj = load i32, i32* %pj, align 4
  %ai_le_bj = icmp sle i32 %ai, %bj
  br i1 %ai_le_bj, label %left.take, label %right.path

left.loadonly:
  %pi2 = getelementptr inbounds i32, i32* %src, i64 %i
  %ai2 = load i32, i32* %pi2, align 4
  br label %left.take

left.take:
  %valL = phi i32 [ %ai, %cmp.load ], [ %ai2, %left.loadonly ]
  %pk = getelementptr inbounds i32, i32* %dest, i64 %k
  store i32 %valL, i32* %pk, align 4
  %i.nextL = add i64 %i, 1
  %k.nextL = add i64 %k, 1
  %j.sameL = add i64 %j, 0
  br label %merge.iterL

merge.iterL:
  br label %merge.cond

right.path:
  %pj2 = getelementptr inbounds i32, i32* %src, i64 %j
  %bj2 = load i32, i32* %pj2, align 4
  %pk2 = getelementptr inbounds i32, i32* %dest, i64 %k
  store i32 %bj2, i32* %pk2, align 4
  %j.nextR = add i64 %j, 1
  %k.nextR = add i64 %k, 1
  %i.nextR = add i64 %i, 0
  br label %merge.iterR

merge.iterR:
  br label %merge.cond

after.merge:
  %tworun2 = shl i64 %run, 1
  %offset.next = add i64 %offset, %tworun2
  br label %inner.cond

after.inner:
  %src.next = bitcast i32* %dest to i32*
  %dest.next = bitcast i32* %src to i32*
  %run.next = shl i64 %run, 1
  br label %outer.cond

after.outer:
  %src.ne.arg0 = icmp ne i32* %src, %arg_0
  br i1 %src.ne.arg0, label %do.copy, label %skip.copy

do.copy:
  %dst8 = bitcast i32* %arg_0 to i8*
  %src8 = bitcast i32* %src to i8*
  %callmem = call i8* @memcpy(i8* %dst8, i8* %src8, i64 %size.bytes)
  br label %after.copy

skip.copy:
  br label %after.copy

after.copy:
  call void @free(i8* %tmpraw)
  br label %end

end:
  ret void
}