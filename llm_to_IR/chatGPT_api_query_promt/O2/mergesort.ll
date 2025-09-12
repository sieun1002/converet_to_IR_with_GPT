; ModuleID = 'mergesort_from_disasm.ll'
source_filename = "mergesort"
target triple = "x86_64-pc-linux-gnu"

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

@__stack_chk_guard = external global i64

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() noreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  ; stack protector setup
  %canary.global = load i64, i64* @__stack_chk_guard
  %canary.slot = alloca i64, align 8
  store i64 %canary.global, i64* %canary.slot, align 8

  ; local array of 10 ints on stack
  %base = alloca [10 x i32], align 16
  %base.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %base, i64 0, i64 0

  ; initialize array: [9,1,5,3,7,2,8,6,4,0]
  store i32 9, i32* %base.ptr, align 4
  %p1 = getelementptr inbounds i32, i32* %base.ptr, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %base.ptr, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %base.ptr, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %base.ptr, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %base.ptr, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %base.ptr, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %base.ptr, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %base.ptr, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %base.ptr, i64 9
  store i32 0, i32* %p9, align 4

  ; allocate temporary buffer (40 bytes)
  %tmp.raw = call i8* @malloc(i64 40)
  %tmp.isnull = icmp eq i8* %tmp.raw, null
  br i1 %tmp.isnull, label %print_unsorted, label %merge_setup

merge_setup:
  %tmp.i32 = bitcast i8* %tmp.raw to i32*
  br label %outer

outer:
  %run = phi i32 [ 1, %merge_setup ], [ %run.next, %end_pass ]
  %passes = phi i32 [ 4, %merge_setup ], [ %passes.dec, %end_pass ]
  %src = phi i32* [ %base.ptr, %merge_setup ], [ %src.next, %end_pass ]
  %dst = phi i32* [ %tmp.i32, %merge_setup ], [ %dst.next, %end_pass ]
  br label %chunk

chunk:
  %i = phi i32 [ 0, %outer ], [ %i.next, %after_merge ]

  ; compute boundaries
  %end1.tmp = add nsw i32 %i, %run
  %end1.lt10 = icmp slt i32 %end1.tmp, 10
  %end1 = select i1 %end1.lt10, i32 %end1.tmp, i32 10
  %twoRun = shl i32 %run, 1
  %end2.tmp = add nsw i32 %i, %twoRun
  %end2.lt10 = icmp slt i32 %end2.tmp, 10
  %end2 = select i1 %end2.lt10, i32 %end2.tmp, i32 10

  ; if i >= end2, nothing to merge
  %no.merge = icmp uge i32 %i, %end2
  br i1 %no.merge, label %after_merge, label %do_merge_setup

do_merge_setup:
  %i64 = sext i32 %i to i64
  %dst.start = getelementptr inbounds i32, i32* %dst, i64 %i64
  %out.count = sub nsw i32 %end2, %i
  br label %do_merge

do_merge:
  %li = phi i32 [ %i, %do_merge_setup ], [ %li.next, %merge_store ]
  %ri = phi i32 [ %end1, %do_merge_setup ], [ %ri.next, %merge_store ]
  %di = phi i32 [ 0, %do_merge_setup ], [ %di.next, %merge_store ]

  %done = icmp eq i32 %di, %out.count
  br i1 %done, label %after_merge, label %merge_choose

merge_choose:
  %li.lt.end1 = icmp slt i32 %li, %end1
  br i1 %li.lt.end1, label %check_right, label %take_right_only

check_right:
  %ri.lt.end2 = icmp slt i32 %ri, %end2
  br i1 %ri.lt.end2, label %both_avail, label %take_left_only

both_avail:
  %li64 = sext i32 %li to i64
  %ri64 = sext i32 %ri to i64
  %a.ptr = getelementptr inbounds i32, i32* %src, i64 %li64
  %b.ptr = getelementptr inbounds i32, i32* %src, i64 %ri64
  %a = load i32, i32* %a.ptr, align 4
  %b = load i32, i32* %b.ptr, align 4
  %b.lt.a = icmp slt i32 %b, %a
  br i1 %b.lt.a, label %choose_b, label %choose_a

choose_b:
  %val.b = phi i32 [ %b, %both_avail ]
  %ri.next = add i32 %ri, 1
  %li.next.b = %li
  br label %merge_store

choose_a:
  %val.a = phi i32 [ %a, %both_avail ]
  %li.next = add i32 %li, 1
  %ri.next.a = %ri
  br label %merge_store

take_left_only:
  %li64.only = sext i32 %li to i64
  %a.ptr.only = getelementptr inbounds i32, i32* %src, i64 %li64.only
  %a.only = load i32, i32* %a.ptr.only, align 4
  %li.next.only = add i32 %li, 1
  %ri.next.only = %ri
  br label %merge_store

take_right_only:
  %ri64.only = sext i32 %ri to i64
  %b.ptr.only = getelementptr inbounds i32, i32* %src, i64 %ri64.only
  %b.only = load i32, i32* %b.ptr.only, align 4
  %ri.next.only2 = add i32 %ri, 1
  %li.next.only2 = %li
  br label %merge_store

merge_store:
  %val = phi i32 [ %val.b, %choose_b ],
                 [ %val.a, %choose_a ],
                 [ %a.only, %take_left_only ],
                 [ %b.only, %take_right_only ]
  %li.next = phi i32 [ %li.next.b, %choose_b ],
                     [ %li.next,   %choose_a ],
                     [ %li.next.only, %take_left_only ],
                     [ %li.next.only2, %take_right_only ]
  %ri.next = phi i32 [ %ri.next,      %choose_b ],
                     [ %ri.next.a,    %choose_a ],
                     [ %ri.next.only, %take_left_only ],
                     [ %ri.next.only2,%take_right_only ]

  %di64 = sext i32 %di to i64
  %out.ptr = getelementptr inbounds i32, i32* %dst.start, i64 %di64
  store i32 %val, i32* %out.ptr, align 4
  %di.next = add i32 %di, 1
  br label %do_merge

after_merge:
  %i.next = add i32 %i, %twoRun
  %more.chunks = icmp ule i32 %i.next, 9
  br i1 %more.chunks, label %chunk, label %end_pass

end_pass:
  %run.next = shl i32 %run, 1
  %passes.dec = add i32 %passes, -1
  %more.passes = icmp ne i32 %passes.dec, 0
  ; swap src/dst for next pass
  %src.next = %dst
  %dst.next = %src
  br i1 %more.passes, label %outer, label %finalize

finalize:
  ; if last destination buffer is not the original base, copy back
  %need.copy = icmp ne i32* %dst, %base.ptr
  br i1 %need.copy, label %do_copy, label %free_then_print

do_copy:
  %base.i8 = bitcast i32* %base.ptr to i8*
  %dst.i8  = bitcast i32* %dst to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %base.i8, i8* %dst.i8, i64 40, i1 false)
  br label %free_then_print

free_then_print:
  call void @free(i8* %tmp.raw)
  br label %print_entry

print_unsorted:
  br label %print_entry

print_entry:
  ; print values from base.ptr
  br label %print_loop

print_loop:
  %j = phi i32 [ 0, %print_entry ], [ %j.next, %print_one ]
  %done.print = icmp eq i32 %j, 10
  br i1 %done.print, label %print_nl, label %print_one

print_one:
  %j64 = sext i32 %j to i64
  %elt.ptr = getelementptr inbounds i32, i32* %base.ptr, i64 %j64
  %elt = load i32, i32* %elt.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %elt)
  %j.next = add i32 %j, 1
  br label %print_loop

print_nl:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ; stack protector check
  %canary.end = load i64, i64* %canary.slot, align 8
  %canary.global2 = load i64, i64* @__stack_chk_guard
  %canary.bad = icmp ne i64 %canary.end, %canary.global2
  br i1 %canary.bad, label %ssp_fail, label %ret

ssp_fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}