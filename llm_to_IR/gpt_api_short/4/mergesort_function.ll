; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort ; Address: 0x11E9
; Intent: Bottom-up stable merge sort of int32 array (confidence=0.90). Evidence: iterative run doubling and two-buffer merge with final memcpy; malloc/free temp buffer
; Preconditions: dest non-null unless n <= 1; n is number of 32-bit elements
; Postconditions: dest contains the array sorted in nondecreasing (signed) order

; Only the necessary external declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr
declare i8* @memcpy(i8*, i8*, i64) local_unnamed_addr

define dso_local void @merge_sort(i32* noundef %dest, i64 noundef %n) local_unnamed_addr {
entry:
  %n_le_1 = icmp ule i64 %n, 1
  br i1 %n_le_1, label %ret, label %alloc

alloc:
  %size_bytes = shl i64 %n, 2
  %rawtmp = call i8* @malloc(i64 %size_bytes)
  %tmpbuf = bitcast i8* %rawtmp to i32*
  %isnull = icmp eq i8* %rawtmp, null
  br i1 %isnull, label %ret, label %init

init:
  br label %outer

outer:
  %run = phi i64 [ 1, %init ], [ %run.next, %swap ]
  %src = phi i32* [ %dest, %init ], [ %outbuf, %swap ]
  %outbuf = phi i32* [ %tmpbuf, %init ], [ %src, %swap ]
  %more = icmp ult i64 %run, %n
  br i1 %more, label %pass.begin, label %done

pass.begin:
  %i = phi i64 [ 0, %outer ], [ %i.next, %after.pair ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %pair.init, label %swap

pair.init:
  %lo = add i64 %i, 0
  %t1 = add i64 %i, %run
  %mid = select i1 (icmp ult i64 %t1, %n), i64 %t1, i64 %n
  %t2 = add i64 %i, %run
  %t3 = add i64 %t2, %run
  %hi.pre = select i1 (icmp ult i64 %t3, %n), i64 %t3, i64 %n
  %li0 = add i64 %lo, 0
  %ri0 = add i64 %mid, 0
  %oi0 = add i64 %lo, 0
  br label %merge.loop

merge.loop:
  %li = phi i64 [ %li0, %pair.init ], [ %li.next, %after.choose ]
  %ri = phi i64 [ %ri0, %pair.init ], [ %ri.next, %after.choose ]
  %oi = phi i64 [ %oi0, %pair.init ], [ %oi.next, %after.choose ]
  %hi = phi i64 [ %hi.pre, %pair.init ], [ %hi.pre, %after.choose ]
  %mid.phi = phi i64 [ %mid, %pair.init ], [ %mid, %after.choose ]
  %cont = icmp ult i64 %oi, %hi
  br i1 %cont, label %in.merge, label %after.pair

in.merge:
  %li_lt_mid = icmp ult i64 %li, %mid.phi
  br i1 %li_lt_mid, label %check.right, label %choose.right

check.right:
  %ri_lt_hi = icmp ult i64 %ri, %hi
  br i1 %ri_lt_hi, label %compare.lr, label %choose.left

compare.lr:
  %lptr = getelementptr inbounds i32, i32* %src, i64 %li
  %lval = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %src, i64 %ri
  %rval = load i32, i32* %rptr, align 4
  %l_gt_r = icmp sgt i32 %lval, %rval
  br i1 %l_gt_r, label %choose.right, label %choose.left

choose.left:
  %lptr2 = getelementptr inbounds i32, i32* %src, i64 %li
  %lval2 = load i32, i32* %lptr2, align 4
  %optrL = getelementptr inbounds i32, i32* %outbuf, i64 %oi
  store i32 %lval2, i32* %optrL, align 4
  %li.next.l = add i64 %li, 1
  %ri.next.l = add i64 %ri, 0
  %oi.next.l = add i64 %oi, 1
  br label %after.choose

choose.right:
  %rptr2 = getelementptr inbounds i32, i32* %src, i64 %ri
  %rval2 = load i32, i32* %rptr2, align 4
  %optrR = getelementptr inbounds i32, i32* %outbuf, i64 %oi
  store i32 %rval2, i32* %optrR, align 4
  %li.next.r = add i64 %li, 0
  %ri.next.r = add i64 %ri, 1
  %oi.next.r = add i64 %oi, 1
  br label %after.choose

after.choose:
  %li.next = phi i64 [ %li.next.l, %choose.left ], [ %li.next.r, %choose.right ]
  %ri.next = phi i64 [ %ri.next.l, %choose.left ], [ %ri.next.r, %choose.right ]
  %oi.next = phi i64 [ %oi.next.l, %choose.left ], [ %oi.next.r, %choose.right ]
  br label %merge.loop

after.pair:
  %two.run = shl i64 %run, 1
  %i.next = add i64 %i, %two.run
  br label %pass.begin

swap:
  %run.next = shl i64 %run, 1
  br label %outer

done:
  %src.final = phi i32* [ %src, %outer ]
  %need_copy = icmp ne i32* %src.final, %dest
  br i1 %need_copy, label %do.copy, label %do.free

do.copy:
  %dst8 = bitcast i32* %dest to i8*
  %src8 = bitcast i32* %src.final to i8*
  %_ = call i8* @memcpy(i8* %dst8, i8* %src8, i64 %size_bytes)
  br label %do.free

do.free:
  call void @free(i8* %rawtmp)
  br label %ret

ret:
  ret void
}