; ModuleID = 'heapsort_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

define dso_local void @sub_140001450(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp = icmp ule i64 %n, 1
  br i1 %cmp, label %ret, label %build.init

build.init:
  %half = lshr i64 %n, 1
  br label %build.loop.check

build.loop.check:
  %i = phi i64 [ %half, %build.init ], [ %i.next0, %build.loop.end ], [ %i.next1, %build.parent.break ]
  %iszero = icmp eq i64 %i, 0
  br i1 %iszero, label %extract.init, label %build.sift.entry

build.sift.entry:
  %j.init = add i64 %i, -1
  br label %build.sift.loop

build.sift.loop:
  %j = phi i64 [ %j.init, %build.sift.entry ], [ %m.idx, %build.swap.done ]
  %j2 = shl i64 %j, 1
  %l = or i64 %j2, 1
  %l_lt_n = icmp ult i64 %l, %n
  br i1 %l_lt_n, label %build.have.left, label %build.loop.end

build.have.left:
  %r = add i64 %l, 1
  %lptr = getelementptr inbounds i32, i32* %arr, i64 %l
  %lval = load i32, i32* %lptr, align 4
  %r_lt_n = icmp ult i64 %r, %n
  br i1 %r_lt_n, label %build.compare.children, label %build.select.left

build.compare.children:
  %rptr = getelementptr inbounds i32, i32* %arr, i64 %r
  %rval = load i32, i32* %rptr, align 4
  %r_gt_l = icmp sgt i32 %rval, %lval
  br i1 %r_gt_l, label %build.select.right, label %build.select.left

build.select.right:
  br label %build.compare.parent

build.select.left:
  br label %build.compare.parent

build.compare.parent:
  %m.idx = phi i64 [ %r, %build.select.right ], [ %l, %build.select.left ]
  %m.val = phi i32 [ %rval, %build.select.right ], [ %lval, %build.select.left ]
  %jptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %jval = load i32, i32* %jptr, align 4
  %lt = icmp slt i32 %jval, %m.val
  br i1 %lt, label %build.swap, label %build.parent.break

build.swap:
  store i32 %m.val, i32* %jptr, align 4
  %mptr = getelementptr inbounds i32, i32* %arr, i64 %m.idx
  store i32 %jval, i32* %mptr, align 4
  br label %build.swap.done

build.swap.done:
  br label %build.sift.loop

build.loop.end:
  %i.next0 = add i64 %i, -1
  br label %build.loop.check

build.parent.break:
  %i.next1 = add i64 %i, -1
  br label %build.loop.check

extract.init:
  %end0 = add i64 %n, -1
  br label %extract.check

extract.check:
  %end = phi i64 [ %end0, %extract.init ], [ %end.next, %post.sift ]
  %cond = icmp ne i64 %end, 0
  br i1 %cond, label %extract.swap, label %ret

extract.swap:
  %base.ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %end.ptr = getelementptr inbounds i32, i32* %arr, i64 %end
  %base.val = load i32, i32* %base.ptr, align 4
  %end.val = load i32, i32* %end.ptr, align 4
  store i32 %end.val, i32* %base.ptr, align 4
  store i32 %base.val, i32* %end.ptr, align 4
  br label %extract.sift.entry

extract.sift.entry:
  br label %extract.sift.loop

extract.sift.loop:
  %ej = phi i64 [ 0, %extract.sift.entry ], [ %m2.idx, %extract.swap2.done ]
  %ej2 = shl i64 %ej, 1
  %el = or i64 %ej2, 1
  %el_lt_end = icmp ult i64 %el, %end
  br i1 %el_lt_end, label %extract.have.left, label %post.sift

extract.have.left:
  %er = add i64 %el, 1
  %elptr = getelementptr inbounds i32, i32* %arr, i64 %el
  %elval = load i32, i32* %elptr, align 4
  %er_lt_end = icmp ult i64 %er, %end
  br i1 %er_lt_end, label %extract.compare.children, label %extract.select.left

extract.compare.children:
  %erptr = getelementptr inbounds i32, i32* %arr, i64 %er
  %erval = load i32, i32* %erptr, align 4
  %er_gt_el = icmp sgt i32 %erval, %elval
  br i1 %er_gt_el, label %extract.select.right, label %extract.select.left

extract.select.right:
  br label %extract.compare.parent

extract.select.left:
  br label %extract.compare.parent

extract.compare.parent:
  %m2.idx = phi i64 [ %er, %extract.select.right ], [ %el, %extract.select.left ]
  %m2.val = phi i32 [ %erval, %extract.select.right ], [ %elval, %extract.select.left ]
  %ejptr = getelementptr inbounds i32, i32* %arr, i64 %ej
  %ejval = load i32, i32* %ejptr, align 4
  %lt2 = icmp slt i32 %ejval, %m2.val
  br i1 %lt2, label %extract.swap2, label %post.sift2

extract.swap2:
  store i32 %m2.val, i32* %ejptr, align 4
  %m2ptr = getelementptr inbounds i32, i32* %arr, i64 %m2.idx
  store i32 %ejval, i32* %m2ptr, align 4
  br label %extract.swap2.done

extract.swap2.done:
  br label %extract.sift.loop

post.sift2:
  br label %post.sift

post.sift:
  %end.next = add i64 %end, -1
  br label %extract.check

ret:
  ret void
}