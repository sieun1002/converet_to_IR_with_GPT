; ModuleID = 'mergesort.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 4
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9, align 4
  store i64 10, i64* %len, align 8
  %len.val = load i64, i64* %len, align 8
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @merge_sort(i32* noundef %arr.base, i64 noundef %len.val)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %len.cur = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef %fmt, i32 noundef %elem)
  %i.next = add nuw nsw i64 %i, 1
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %call.putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %alloc

alloc:                                            ; preds = %entry
  %bytes = shl i64 %n, 2
  %tmp_ptr_i8 = call i8* @malloc(i64 %bytes)
  %isnull = icmp eq i8* %tmp_ptr_i8, null
  br i1 %isnull, label %ret, label %init

init:                                             ; preds = %alloc
  %tmp_ptr = bitcast i8* %tmp_ptr_i8 to i32*
  br label %outer.cond

outer.cond:                                       ; preds = %outer.swap, %init
  %width.phi = phi i64 [ 1, %init ], [ %width.next, %outer.swap ]
  %src.phi = phi i32* [ %dest, %init ], [ %src.next, %outer.swap ]
  %buf.phi = phi i32* [ %tmp_ptr, %init ], [ %buf.next, %outer.swap ]
  %cmp_width = icmp ult i64 %width.phi, %n
  br i1 %cmp_width, label %inner.cond, label %after.loops

inner.cond:                                       ; preds = %merge.done, %outer.cond
  %i.phi = phi i64 [ 0, %outer.cond ], [ %i.next, %merge.done ]
  %tw = shl i64 %width.phi, 1
  %i.cmp = icmp ult i64 %i.phi, %n
  br i1 %i.cmp, label %chunk.setup, label %outer.swap

chunk.setup:                                      ; preds = %inner.cond
  %i_plus_w = add i64 %i.phi, %width.phi
  %mid.le = icmp ule i64 %i_plus_w, %n
  %mid = select i1 %mid.le, i64 %i_plus_w, i64 %n
  %i_plus_2w = add i64 %i.phi, %tw
  %end.le = icmp ule i64 %i_plus_2w, %n
  %end = select i1 %end.le, i64 %i_plus_2w, i64 %n
  br label %merge.header

merge.header:                                     ; preds = %choose.right, %choose.left, %chunk.setup
  %j.phi = phi i64 [ %i.phi, %chunk.setup ], [ %j.next, %choose.left ], [ %j.keep, %choose.right ]
  %k.phi = phi i64 [ %mid, %chunk.setup ], [ %k.keep, %choose.left ], [ %k.next, %choose.right ]
  %d.phi = phi i64 [ %i.phi, %chunk.setup ], [ %d.next.left, %choose.left ], [ %d.next.right, %choose.right ]
  %d.cmp = icmp ult i64 %d.phi, %end
  br i1 %d.cmp, label %choose.pre, label %merge.done

choose.pre:                                       ; preds = %merge.header
  %left.avail = icmp ult i64 %j.phi, %mid
  br i1 %left.avail, label %check.right, label %choose.right

check.right:                                      ; preds = %choose.pre
  %right.avail = icmp ult i64 %k.phi, %end
  br i1 %right.avail, label %cmp.values, label %choose.left

cmp.values:                                       ; preds = %check.right
  %left.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %left.load = load i32, i32* %left.ptr, align 4
  %right.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %k.phi
  %right.load = load i32, i32* %right.ptr, align 4
  %le.cmp = icmp sle i32 %left.load, %right.load
  br i1 %le.cmp, label %choose.left, label %choose.right

choose.left:                                      ; preds = %cmp.values, %check.right
  %dst.ptr.left = getelementptr inbounds i32, i32* %buf.phi, i64 %d.phi
  %src.l.ptr2 = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %lval2 = load i32, i32* %src.l.ptr2, align 4
  store i32 %lval2, i32* %dst.ptr.left, align 4
  %j.next = add i64 %j.phi, 1
  %k.keep = add i64 %k.phi, 0
  %d.next.left = add i64 %d.phi, 1
  br label %merge.header

choose.right:                                     ; preds = %cmp.values, %choose.pre
  %dst.ptr.right = getelementptr inbounds i32, i32* %buf.phi, i64 %d.phi
  %src.r.ptr2 = getelementptr inbounds i32, i32* %src.phi, i64 %k.phi
  %rval2 = load i32, i32* %src.r.ptr2, align 4
  store i32 %rval2, i32* %dst.ptr.right, align 4
  %k.next = add i64 %k.phi, 1
  %j.keep = add i64 %j.phi, 0
  %d.next.right = add i64 %d.phi, 1
  br label %merge.header

merge.done:                                       ; preds = %merge.header
  %i.next = add i64 %i.phi, %tw
  br label %inner.cond

outer.swap:                                       ; preds = %inner.cond
  %src.next = getelementptr inbounds i32, i32* %buf.phi, i64 0
  %buf.next = getelementptr inbounds i32, i32* %src.phi, i64 0
  %width.next = shl i64 %width.phi, 1
  br label %outer.cond

after.loops:                                      ; preds = %outer.cond
  %src.ne.dest = icmp ne i32* %src.phi, %dest
  br i1 %src.ne.dest, label %do.copy, label %skip.copy

do.copy:                                          ; preds = %after.loops
  %bytes.copy = shl i64 %n, 2
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.phi to i8*
  %memcpy.call = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %bytes.copy)
  br label %skip.copy

skip.copy:                                        ; preds = %do.copy, %after.loops
  call void @free(i8* %tmp_ptr_i8)
  br label %ret

ret:                                              ; preds = %skip.copy, %alloc, %entry
  ret void
}

declare i8* @malloc(i64)

declare i8* @memcpy(i8*, i8*, i64)

declare void @free(i8*)
