; ModuleID = 'merge_sort_module'
target triple = "x86_64-pc-windows-msvc"

declare dllimport i8* @malloc(i64 noundef)
declare dllimport void @free(i8* noundef)
declare dllimport i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)

define dso_local void @merge_sort(i32* noundef %arr, i64 noundef %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %alloc

alloc:
  %bytes = shl i64 %n, 2
  %blk_i8 = call i8* @malloc(i64 %bytes)
  %blk_isnull = icmp eq i8* %blk_i8, null
  br i1 %blk_isnull, label %ret, label %after_alloc

after_alloc:
  %blk_i32 = bitcast i8* %blk_i8 to i32*
  br label %outer.header

outer.header:
  %src.phi = phi i32* [ %arr, %after_alloc ], [ %tmp.next, %outer.latch ]
  %tmp.phi = phi i32* [ %blk_i32, %after_alloc ], [ %src.next, %outer.latch ]
  %run.phi = phi i64 [ 1, %after_alloc ], [ %run.next, %outer.latch ]
  %run_lt_n = icmp ult i64 %run.phi, %n
  br i1 %run_lt_n, label %for.header, label %after_outer

for.header:
  %i.phi = phi i64 [ 0, %outer.header ], [ %i.next, %merge.end ]
  %i_lt_n = icmp ult i64 %i.phi, %n
  br i1 %i_lt_n, label %for.body, label %outer.latch

for.body:
  %left = add i64 %i.phi, 0
  %add_mid = add i64 %left, %run.phi
  %mid_over = icmp ule i64 %n, %add_mid
  %mid.sel = select i1 %mid_over, i64 %n, i64 %add_mid
  %run2 = shl i64 %run.phi, 1
  %add_right = add i64 %left, %run2
  %right_over = icmp ule i64 %n, %add_right
  %right.sel = select i1 %right_over, i64 %n, i64 %add_right
  br label %merge.header

merge.header:
  %k.phi = phi i64 [ %left, %for.body ], [ %k.next, %write.join ]
  %l.phi = phi i64 [ %left, %for.body ], [ %l.next, %write.join ]
  %r.phi = phi i64 [ %mid.sel, %for.body ], [ %r.next, %write.join ]
  %k_lt_right = icmp ult i64 %k.phi, %right.sel
  br i1 %k_lt_right, label %decide.leftavail, label %merge.end

decide.leftavail:
  %l_lt_mid = icmp ult i64 %l.phi, %mid.sel
  br i1 %l_lt_mid, label %decide.rightavail, label %pick.right.only

decide.rightavail:
  %r_lt_right = icmp ult i64 %r.phi, %right.sel
  br i1 %r_lt_right, label %cmp.values, label %pick.left.only

cmp.values:
  %l.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %l.phi
  %l.val = load i32, i32* %l.ptr, align 4
  %r.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %r.phi
  %r.val = load i32, i32* %r.ptr, align 4
  %le = icmp sle i32 %l.val, %r.val
  br i1 %le, label %pick.left.both, label %pick.right.both

pick.left.only:
  %l.ptr.lo = getelementptr inbounds i32, i32* %src.phi, i64 %l.phi
  %l.val.lo = load i32, i32* %l.ptr.lo, align 4
  br label %write.left

pick.right.only:
  %r.ptr.ro = getelementptr inbounds i32, i32* %src.phi, i64 %r.phi
  %r.val.ro = load i32, i32* %r.ptr.ro, align 4
  br label %write.right

pick.left.both:
  %l.ptr.lb = getelementptr inbounds i32, i32* %src.phi, i64 %l.phi
  %l.val.lb = load i32, i32* %l.ptr.lb, align 4
  br label %write.left

pick.right.both:
  %r.ptr.rb = getelementptr inbounds i32, i32* %src.phi, i64 %r.phi
  %r.val.rb = load i32, i32* %r.ptr.rb, align 4
  br label %write.right

write.left:
  %val.left = phi i32 [ %l.val.lo, %pick.left.only ], [ %l.val.lb, %pick.left.both ]
  %dst.ptr.l = getelementptr inbounds i32, i32* %tmp.phi, i64 %k.phi
  store i32 %val.left, i32* %dst.ptr.l, align 4
  %k.next.l = add i64 %k.phi, 1
  %l.next.l = add i64 %l.phi, 1
  br label %write.join

write.right:
  %val.right = phi i32 [ %r.val.ro, %pick.right.only ], [ %r.val.rb, %pick.right.both ]
  %dst.ptr.r = getelementptr inbounds i32, i32* %tmp.phi, i64 %k.phi
  store i32 %val.right, i32* %dst.ptr.r, align 4
  %k.next.r = add i64 %k.phi, 1
  %r.next.r = add i64 %r.phi, 1
  br label %write.join

write.join:
  %k.next = phi i64 [ %k.next.l, %write.left ], [ %k.next.r, %write.right ]
  %l.next = phi i64 [ %l.next.l, %write.left ], [ %l.phi, %write.right ]
  %r.next = phi i64 [ %r.phi, %write.left ], [ %r.next.r, %write.right ]
  br label %merge.header

merge.end:
  %i.incr = shl i64 %run.phi, 1
  %i.next = add i64 %i.phi, %i.incr
  br label %for.header

outer.latch:
  %src.next = phi i32* [ %src.phi, %for.header ]
  %tmp.next = phi i32* [ %tmp.phi, %for.header ]
  %run.next = shl i64 %run.phi, 1
  br label %outer.header

after_outer:
  %src.final = phi i32* [ %src.phi, %outer.header ]
  %src.ne.arr = icmp ne i32* %src.final, %arr
  br i1 %src.ne.arr, label %do.copy, label %do.free

do.copy:
  %dst.i8 = bitcast i32* %arr to i8*
  %src.i8 = bitcast i32* %src.final to i8*
  %memcpy.ret = call i8* @memcpy(i8* %dst.i8, i8* %src.i8, i64 %bytes)
  br label %do.free

do.free:
  call void @free(i8* %blk_i8)
  br label %ret

ret:
  ret void
}