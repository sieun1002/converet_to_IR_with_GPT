; ModuleID = 'main_module'
source_filename = "main_module"
target triple = "x86_64-pc-linux-gnu"
; NOTE: Adjust the target triple to match your toolchain if needed.

@.str.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() local_unnamed_addr {
entry:
  ; local array of 10 i32, initialized
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9,  i32* %arr0, align 16
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1,  i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 8,  i32* %arr2, align 8
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3,  i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7,  i32* %arr4, align 16
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 4,  i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 6,  i32* %arr6, align 8
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 5,  i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 2,  i32* %arr8, align 16
  %arr9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0,  i32* %arr9, align 4

  %malloc.ptr = call i8* @malloc(i64 40)
  %malloc.null = icmp eq i8* %malloc.ptr, null
  br i1 %malloc.null, label %print, label %have_buf

have_buf:
  %src.init = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %dst.init.raw = bitcast i8* %malloc.ptr to i32*
  br label %outer

outer:
  %src.phi = phi i32* [ %src.init, %have_buf ], [ %src.next, %end_pass ]
  %dst.phi = phi i32* [ %dst.init.raw, %have_buf ], [ %dst.next, %end_pass ]
  %run.phi = phi i32 [ 1, %have_buf ], [ %run.next, %end_pass ]
  %passes.phi = phi i32 [ 4, %have_buf ], [ %passes.next, %end_pass ]
  %passes.done = icmp eq i32 %passes.phi, 0
  br i1 %passes.done, label %after_passes, label %pass_body

pass_body:
  br label %base_loop

base_loop:
  %base.phi = phi i32 [ 0, %pass_body ], [ %base.next, %merge_done ]
  %base.ge.n = icmp sge i32 %base.phi, 10
  br i1 %base.ge.n, label %end_pass, label %do_merge

do_merge:
  %t1.add = add nsw i32 %base.phi, %run.phi
  %t1.lt.n = icmp slt i32 %t1.add, 10
  %mid.sel = select i1 %t1.lt.n, i32 %t1.add, i32 10
  %t2.add = add nsw i32 %mid.sel, %run.phi
  %t2.lt.n = icmp slt i32 %t2.add, 10
  %right.sel = select i1 %t2.lt.n, i32 %t2.add, i32 10
  %base.next = add nsw i32 %base.phi, %run.phi
  %base.next2 = add nsw i32 %base.next, %run.phi

  br label %merge_loop

merge_loop:
  %i.phi = phi i32 [ %base.phi, %do_merge ], [ %i.nextL, %choose_left ], [ %i.phi, %choose_right ]
  %j.phi = phi i32 [ %mid.sel, %do_merge ], [ %j.phi, %choose_left ], [ %j.nextR, %choose_right ]
  %k.phi = phi i32 [ %base.phi, %do_merge ], [ %k.nextL, %choose_left ], [ %k.nextR, %choose_right ]
  %i.lt.mid = icmp slt i32 %i.phi, %mid.sel
  %j.lt.right = icmp slt i32 %j.phi, %right.sel
  %both.have = and i1 %i.lt.mid, %j.lt.right
  br i1 %both.have, label %compare, label %remain

compare:
  %i.idx64 = sext i32 %i.phi to i64
  %j.idx64 = sext i32 %j.phi to i64
  %k.idx64 = sext i32 %k.phi to i64
  %iptr = getelementptr inbounds i32, i32* %src.phi, i64 %i.idx64
  %jptr = getelementptr inbounds i32, i32* %src.phi, i64 %j.idx64
  %ival = load i32, i32* %iptr, align 4
  %jval = load i32, i32* %jptr, align 4
  %cmp.rltl = icmp slt i32 %jval, %ival
  br i1 %cmp.rltl, label %choose_right, label %choose_left

choose_left:
  %kL.idx64 = sext i32 %k.phi to i64
  %dst.kL = getelementptr inbounds i32, i32* %dst.phi, i64 %kL.idx64
  store i32 %ival, i32* %dst.kL, align 4
  %i.nextL = add nsw i32 %i.phi, 1
  %k.nextL = add nsw i32 %k.phi, 1
  br label %merge_loop

choose_right:
  %kR.idx64 = sext i32 %k.phi to i64
  %dst.kR = getelementptr inbounds i32, i32* %dst.phi, i64 %kR.idx64
  store i32 %jval, i32* %dst.kR, align 4
  %j.nextR = add nsw i32 %j.phi, 1
  %k.nextR = add nsw i32 %k.phi, 1
  br label %merge_loop

remain:
  %i.lt.mid.rem = icmp slt i32 %i.phi, %mid.sel
  br i1 %i.lt.mid.rem, label %left_tail.loop, label %right_tail.loop

left_tail.loop:
  %i.lt.phi = phi i32 [ %i.phi, %remain ], [ %i.lt.next, %left_tail.iter ]
  %k.lt.phi = phi i32 [ %k.phi, %remain ], [ %k.lt.next, %left_tail.iter ]
  %i.lt.cond = icmp slt i32 %i.lt.phi, %mid.sel
  br i1 %i.lt.cond, label %left_tail.iter, label %merge_done

left_tail.iter:
  %i.lt.idx64 = sext i32 %i.lt.phi to i64
  %k.lt.idx64 = sext i32 %k.lt.phi to i64
  %src.i.lt = getelementptr inbounds i32, i32* %src.phi, i64 %i.lt.idx64
  %dst.k.lt = getelementptr inbounds i32, i32* %dst.phi, i64 %k.lt.idx64
  %ival.lt = load i32, i32* %src.i.lt, align 4
  store i32 %ival.lt, i32* %dst.k.lt, align 4
  %i.lt.next = add nsw i32 %i.lt.phi, 1
  %k.lt.next = add nsw i32 %k.lt.phi, 1
  br label %left_tail.loop

right_tail.loop:
  %j.rt.phi = phi i32 [ %j.phi, %remain ], [ %j.rt.next, %right_tail.iter ]
  %k.rt.phi = phi i32 [ %k.phi, %remain ], [ %k.rt.next, %right_tail.iter ]
  %j.rt.cond = icmp slt i32 %j.rt.phi, %right.sel
  br i1 %j.rt.cond, label %right_tail.iter, label %merge_done

right_tail.iter:
  %j.rt.idx64 = sext i32 %j.rt.phi to i64
  %k.rt.idx64 = sext i32 %k.rt.phi to i64
  %src.j.rt = getelementptr inbounds i32, i32* %src.phi, i64 %j.rt.idx64
  %dst.k.rt = getelementptr inbounds i32, i32* %dst.phi, i64 %k.rt.idx64
  %jval.rt = load i32, i32* %src.j.rt, align 4
  store i32 %jval.rt, i32* %dst.k.rt, align 4
  %j.rt.next = add nsw i32 %j.rt.phi, 1
  %k.rt.next = add nsw i32 %k.rt.phi, 1
  br label %right_tail.loop

merge_done:
  br label %base_loop

end_pass:
  %run.next = shl i32 %run.phi, 1
  %src.next = bitcast i32* %dst.phi to i32*
  %dst.next = bitcast i32* %src.phi to i32*
  %passes.next = add nsw i32 %passes.phi, -1
  br label %outer

after_passes:
  %src.final = phi i32* [ %src.phi, %outer ]
  %arr.as.i32 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %need.copyback = icmp ne i32* %src.final, %arr.as.i32
  br i1 %need.copyback, label %copyback.loop, label %print

copyback.loop:
  br label %copyback.iter

copyback.iter:
  %cb.i.phi = phi i32 [ 0, %copyback.loop ], [ %cb.i.next, %copyback.iter.store ]
  %cb.end = icmp eq i32 %cb.i.phi, 10
  br i1 %cb.end, label %print, label %copyback.iter.store

copyback.iter.store:
  %cb.i.idx64 = sext i32 %cb.i.phi to i64
  %src.cb.ptr = getelementptr inbounds i32, i32* %src.final, i64 %cb.i.idx64
  %dst.cb.ptr = getelementptr inbounds i32, i32* %arr.as.i32, i64 %cb.i.idx64
  %cb.val = load i32, i32* %src.cb.ptr, align 4
  store i32 %cb.val, i32* %dst.cb.ptr, align 4
  %cb.i.next = add nsw i32 %cb.i.phi, 1
  br label %copyback.iter

print:
  %need.free = icmp ne i8* %malloc.ptr, null
  br i1 %need.free, label %do.free, label %after.free

do.free:
  call void @free(i8* %malloc.ptr)
  br label %after.free

after.free:
  br label %print.loop

print.loop:
  %p.i.phi = phi i32 [ 0, %after.free ], [ %p.i.next, %print.iter ]
  %p.end = icmp eq i32 %p.i.phi, 10
  br i1 %p.end, label %print.nl, label %print.iter

print.iter:
  %p.idx64 = sext i32 %p.i.phi to i64
  %p.ptr = getelementptr inbounds i32, i32* %arr0, i64 %p.idx64
  %p.val = load i32, i32* %p.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0
  %call.printf = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i32 %p.val)
  %p.i.next = add nsw i32 %p.i.phi, 1
  br label %print.loop

print.nl:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0
  %call.printf.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  ret i32 0
}