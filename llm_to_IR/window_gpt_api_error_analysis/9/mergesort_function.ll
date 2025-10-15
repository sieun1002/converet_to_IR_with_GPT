; ModuleID = 'merge_sort_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64 noundef)
declare void @free(i8* noundef)
declare i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)

define void @merge_sort(i32* noundef %arr, i64 noundef %n) local_unnamed_addr {
entry:
  %cmp = icmp ule i64 %n, 1
  br i1 %cmp, label %ret, label %alloc

alloc:
  %size = mul i64 %n, 4
  %buf8 = call i8* @malloc(i64 %size)
  %bufnull = icmp eq i8* %buf8, null
  br i1 %bufnull, label %ret, label %init

init:
  %buf = bitcast i8* %buf8 to i32*
  br label %outer

outer:
  %src = phi i32* [ %arr, %init ], [ %dst, %swap ]
  %dst = phi i32* [ %buf, %init ], [ %src, %swap ]
  %width = phi i64 [ 1, %init ], [ %width2, %swap ]
  %cond = icmp ult i64 %width, %n
  br i1 %cond, label %pass, label %after_outer

pass:
  br label %for.loop

for.loop:
  %base = phi i64 [ 0, %pass ], [ %base.next, %for.cont ]
  %base.cmp = icmp ult i64 %base, %n
  br i1 %base.cmp, label %merge.setup, label %after_pass

merge.setup:
  %t1 = add i64 %base, %width
  %mid.more = icmp ult i64 %t1, %n
  %mid = select i1 %mid.more, i64 %t1, i64 %n
  %tw = add i64 %width, %width
  %t2 = add i64 %base, %tw
  %end.more = icmp ult i64 %t2, %n
  %end = select i1 %end.more, i64 %t2, i64 %n
  br label %merge.loop

merge.loop:
  %i = phi i64 [ %base, %merge.setup ], [ %i.next, %take.left ], [ %i.same, %take.right ]
  %j = phi i64 [ %mid, %merge.setup ], [ %j.same, %take.left ], [ %j.next, %take.right ]
  %k = phi i64 [ %base, %merge.setup ], [ %k.next, %take.left ], [ %k.next2, %take.right ]
  %k.cmp = icmp ult i64 %k, %end
  br i1 %k.cmp, label %choose, label %merge.done

choose:
  %i.lt.mid = icmp ult i64 %i, %mid
  br i1 %i.lt.mid, label %check.right.bound, label %take.right

check.right.bound:
  %j.lt.end = icmp ult i64 %j, %end
  br i1 %j.lt.end, label %load.cmp, label %take.left

load.cmp:
  %i.ptr = getelementptr inbounds i32, i32* %src, i64 %i
  %i.val = load i32, i32* %i.ptr, align 4
  %j.ptr = getelementptr inbounds i32, i32* %src, i64 %j
  %j.val = load i32, i32* %j.ptr, align 4
  %gt = icmp sgt i32 %i.val, %j.val
  br i1 %gt, label %take.right, label %take.left

take.left:
  %i.ptr2 = getelementptr inbounds i32, i32* %src, i64 %i
  %valL = load i32, i32* %i.ptr2, align 4
  %dst.ptrL = getelementptr inbounds i32, i32* %dst, i64 %k
  store i32 %valL, i32* %dst.ptrL, align 4
  %i.next = add i64 %i, 1
  %j.same = add i64 %j, 0
  %k.next = add i64 %k, 1
  br label %merge.loop

take.right:
  %j.ptr2 = getelementptr inbounds i32, i32* %src, i64 %j
  %valR = load i32, i32* %j.ptr2, align 4
  %dst.ptrR = getelementptr inbounds i32, i32* %dst, i64 %k
  store i32 %valR, i32* %dst.ptrR, align 4
  %i.same = add i64 %i, 0
  %j.next = add i64 %j, 1
  %k.next2 = add i64 %k, 1
  br label %merge.loop

merge.done:
  %base.next = add i64 %base, %tw
  br label %for.cont

for.cont:
  br label %for.loop

after_pass:
  br label %swap

swap:
  %width2 = shl i64 %width, 1
  br label %outer

after_outer:
  %src.eq.arr = icmp eq i32* %src, %arr
  br i1 %src.eq.arr, label %free, label %do_memcpy

do_memcpy:
  %dst8 = bitcast i32* %arr to i8*
  %src8 = bitcast i32* %src to i8*
  %call.memcpy = call i8* @memcpy(i8* %dst8, i8* %src8, i64 %size)
  br label %free

free:
  call void @free(i8* %buf8)
  br label %ret

ret:
  ret void
}