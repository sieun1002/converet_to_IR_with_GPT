; ModuleID = 'mergesort_from_ida'
source_filename = "mergesort_from_ida.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.fmt_int = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.fmt_nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() {
entry:
  ; int a[10] = {9,1,5,3,7,2,8,6,4,0};
  %a = alloca [10 x i32], align 16
  %a0 = getelementptr inbounds [10 x i32], [10 x i32]* %a, i64 0, i64 0
  store i32 9,  i32* %a0, align 4
  %a1 = getelementptr inbounds i32, i32* %a0, i64 1
  store i32 1,  i32* %a1, align 4
  %a2 = getelementptr inbounds i32, i32* %a0, i64 2
  store i32 5,  i32* %a2, align 4
  %a3 = getelementptr inbounds i32, i32* %a0, i64 3
  store i32 3,  i32* %a3, align 4
  %a4 = getelementptr inbounds i32, i32* %a0, i64 4
  store i32 7,  i32* %a4, align 4
  %a5 = getelementptr inbounds i32, i32* %a0, i64 5
  store i32 2,  i32* %a5, align 4
  %a6 = getelementptr inbounds i32, i32* %a0, i64 6
  store i32 8,  i32* %a6, align 4
  %a7 = getelementptr inbounds i32, i32* %a0, i64 7
  store i32 6,  i32* %a7, align 4
  %a8 = getelementptr inbounds i32, i32* %a0, i64 8
  store i32 4,  i32* %a8, align 4
  %a9 = getelementptr inbounds i32, i32* %a0, i64 9
  store i32 0,  i32* %a9, align 4

  ; tmp = malloc(40)
  %tmp.raw = call i8* @malloc(i64 40)
  %isnull = icmp eq i8* %tmp.raw, null
  br i1 %isnull, label %print, label %sort

; Bottom-up mergesort into 10-element array using an auxiliary buffer.
sort:
  %tmp = bitcast i8* %tmp.raw to i32*
  %src.init = bitcast [10 x i32]* %a to i32*
  %dst.init = %tmp
  br label %outer

outer:
  ; PHIs for passes (r14d=4) and run length (r13=1) and src/dst pointers
  %passes = phi i32 [ 4, %sort ],        [ %passes.next, %after_chunks ]
  %run    = phi i32 [ 1, %sort ],        [ %run.next,    %after_chunks ]
  %src    = phi i32* [ %src.init, %sort ], [ %src.next,    %after_chunks ]
  %dst    = phi i32* [ %dst.init, %sort ], [ %dst.next,    %after_chunks ]

  ; i = 0
  br label %chunks

chunks:
  %i = phi i32 [ 0, %outer ], [ %i.next, %chunk_done ]
  %cmp.more = icmp slt i32 %i, 10
  br i1 %cmp.more, label %do_chunk, label %after_chunks

do_chunk:
  ; mid = min(i+run, 10), end = min(i+2*run, 10)
  %i_plus_run = add nsw i32 %i, %run
  %mid.cmp = icmp slt i32 %i_plus_run, 10
  %mid = select i1 %mid.cmp, i32 %i_plus_run, i32 10
  %run2 = shl i32 %run, 1
  %i_plus_2run = add nsw i32 %i, %run2
  %end.cmp = icmp slt i32 %i_plus_2run, 10
  %end = select i1 %end.cmp, i32 %i_plus_2run, i32 10

  ; l = i, r = mid, d = i
  br label %merge

merge:
  %l = phi i32 [ %i, %do_chunk ], [ %l.next, %merge_cont ]
  %r = phi i32 [ %mid, %do_chunk ], [ %r.next, %merge_cont ]
  %d = phi i32 [ %i, %do_chunk ], [ %d.next, %merge_cont ]

  %d.lt.end = icmp slt i32 %d, %end
  br i1 %d.lt.end, label %merge_body, label %chunk_done

merge_body:
  ; conditions whether we have elements on left/right
  %l.lt.mid = icmp slt i32 %l, %mid
  %r.lt.end = icmp slt i32 %r, %end

  ; load candidates (safe even if not used since bounds checked)
  %l.ptr = getelementptr inbounds i32, i32* %src, i32 %l
  %l.val = load i32, i32* %l.ptr, align 4
  %r.ptr = getelementptr inbounds i32, i32* %src, i32 %r
  %r.val = load i32, i32* %r.ptr, align 4

  ; choose left if (l < mid) and (r >= end or l.val <= r.val)
  %not_r_lt_end = xor i1 %r.lt.end, true
  %l_le_r = icmp sle i32 %l.val, %r.val
  %right_exhausted_or_le = or i1 %not_r_lt_end, %l_le_r
  %take_left = and i1 %l.lt.mid, %right_exhausted_or_le

  ; store selected to dst[d]
  %dst.ptr = getelementptr inbounds i32, i32* %dst, i32 %d
  %sel = select i1 %take_left, i32 %l.val, i32 %r.val
  store i32 %sel, i32* %dst.ptr, align 4

  ; advance indices
  %l.next = select i1 %take_left, i32 (add i32 %l, 1), i32 %l
  %r.next = select i1 %take_left, i32 %r,                   i32 (add i32 %r, 1)
  %d.next = add nsw i32 %d, 1
  br label %merge

chunk_done:
  ; i = end
  %i.next = %end
  br label %chunks

after_chunks:
  ; run <<= 1; passes -= 1; swap src/dst if more passes
  %run.next = shl i32 %run, 1
  %passes.next = add nsw i32 %passes, -1
  %more = icmp ne i32 %passes.next, 0
  ; swap for next pass
  %src.next = select i1 %more, i32* %dst, i32* %src
  %dst.next = select i1 %more, i32* %src, i32* %dst
  br i1 %more, label %outer, label %sorted_done

sorted_done:
  ; free(tmp)
  call void @free(i8* %tmp.raw)
  br label %print

; print the array (either sorted or original if malloc failed)
print:
  %p.base = bitcast [10 x i32]* %a to i32*
  br label %print_loop

print_loop:
  %pi = phi i32 [ 0, %print ], [ %pi.next, %print_loop ]
  %pi.lt = icmp slt i32 %pi, 10
  br i1 %pi.lt, label %print_body, label %print_done

print_body:
  %p.elem = getelementptr inbounds i32, i32* %p.base, i32 %pi
  %val = load i32, i32* %p.elem, align 4
  ; __printf_chk(1, "%d ", val)
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt_int, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %val)
  %pi.next = add nsw i32 %pi, 1
  br label %print_loop

print_done:
  ; __printf_chk(1, "\n")
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.fmt_nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}