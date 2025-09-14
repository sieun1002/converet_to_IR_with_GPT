; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort ; Address: 0x11E9
; Intent: iterative stable merge sort for i32 array (confidence=0.95). Evidence: malloc n*4 buffer, pairwise merge with signed compare, final memcpy back if needed
; Preconditions: dest points to at least n 32-bit integers
; Postconditions: dest sorted ascending if n > 1 and allocation succeeds

; Only the necessary external declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr
declare i8* @memcpy(i8*, i8*, i64) local_unnamed_addr

define dso_local void @merge_sort(i32* noundef %dest, i64 noundef %n) local_unnamed_addr {
entry:
  %n_le1 = icmp ule i64 %n, 1
  br i1 %n_le1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %raw = call noalias i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %raw, null
  br i1 %isnull, label %ret, label %init

init:
  %tmpbuf = bitcast i8* %raw to i32*
  br label %outer

outer:
  %width = phi i64 [ 1, %init ], [ %width.next, %after_forI ]
  %src = phi i32* [ %dest, %init ], [ %src.next, %after_forI ]
  %tmp = phi i32* [ %tmpbuf, %init ], [ %tmp.next, %after_forI ]
  %cmpw = icmp ult i64 %width, %n
  br i1 %cmpw, label %forI, label %final

forI:
  %i = phi i64 [ 0, %outer ], [ %i.next, %merge_done ]
  %twoW = add i64 %width, %width
  %icond = icmp ult i64 %i, %n
  br i1 %icond, label %merge_prep, label %after_forI

merge_prep:
  %left = add i64 %i, 0
  %mid_pre = add i64 %i, %width
  %mid_pre_lt_n = icmp ult i64 %mid_pre, %n
  %mid = select i1 %mid_pre_lt_n, i64 %mid_pre, i64 %n
  %right_pre = add i64 %i, %twoW
  %right_pre_lt_n = icmp ult i64 %right_pre, %n
  %right = select i1 %right_pre_lt_n, i64 %right_pre, i64 %n
  br label %merge_loop

merge_loop:
  %k = phi i64 [ %left, %merge_prep ], [ %k.next, %after_write ]
  %l = phi i64 [ %left, %merge_prep ], [ %l.next, %after_write ]
  %r = phi i64 [ %mid,  %merge_prep ], [ %r.next, %after_write ]
  %k_lt_right = icmp ult i64 %k, %right
  br i1 %k_lt_right, label %choose, label %merge_done

choose:
  %l_lt_mid = icmp ult i64 %l, %mid
  br i1 %l_lt_mid, label %check_right, label %take_right

check_right:
  %r_lt_right = icmp ult i64 %r, %right
  br i1 %r_lt_right, label %cmp_vals, label %take_left

cmp_vals:
  %lptr = getelementptr inbounds i32, i32* %src, i64 %l
  %lval = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %src, i64 %r
  %rval = load i32, i32* %rptr, align 4
  %left_le_right = icmp sle i32 %lval, %rval
  br i1 %left_le_right, label %take_left, label %take_right

take_left:
  %lptr2 = getelementptr inbounds i32, i32* %src, i64 %l
  %lval2 = load i32, i32* %lptr2, align 4
  %tmpk = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %lval2, i32* %tmpk, align 4
  %k1 = add i64 %k, 1
  %l1 = add i64 %l, 1
  br label %after_write

take_right:
  %rptr2 = getelementptr inbounds i32, i32* %src, i64 %r
  %rval2 = load i32, i32* %rptr2, align 4
  %tmpk2 = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %rval2, i32* %tmpk2, align 4
  %k2 = add i64 %k, 1
  %r1 = add i64 %r, 1
  br label %after_write

after_write:
  %k.next = phi i64 [ %k1, %take_left ], [ %k2, %take_right ]
  %l.next = phi i64 [ %l1, %take_left ], [ %l,  %take_right ]
  %r.next = phi i64 [ %r,  %take_left ], [ %r1, %take_right ]
  br label %merge_loop

merge_done:
  %i.next = add i64 %i, %twoW
  br label %forI

after_forI:
  %src.next = phi i32* [ %tmp, %forI ]
  %tmp.next = phi i32* [ %src, %forI ]
  %width.next = shl i64 %width, 1
  br label %outer

final:
  %src.final = phi i32* [ %src, %outer ]
  %need_copy = icmp ne i32* %src.final, %dest
  br i1 %need_copy, label %do_copy, label %skip_copy

do_copy:
  %dst8 = bitcast i32* %dest to i8*
  %src8 = bitcast i32* %src.final to i8*
  %size2 = shl i64 %n, 2
  %_mc = call i8* @memcpy(i8* %dst8, i8* %src8, i64 %size2)
  br label %free_and_ret

skip_copy:
  br label %free_and_ret

free_and_ret:
  call void @free(i8* %raw)
  br label %ret

ret:
  ret void
}