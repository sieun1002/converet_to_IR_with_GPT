; ModuleID = 'quicksort.ll'
source_filename = "quicksort"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)

define dso_local void @quick_sort(i32* nocapture noundef %a, i64 noundef %lo, i64 noundef %hi) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                      ; preds = %outer.cont, %entry
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.next, %outer.cont ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.next, %outer.cont ]
  %cmp0 = icmp slt i64 %lo.cur, %hi.cur
  br i1 %cmp0, label %outer.body, label %ret

outer.body:                                      ; preds = %outer.cond
  ; i = lo.cur, j = hi.cur, pivot = a[lo + (hi-lo)/2]
  %diff = sub i64 %hi.cur, %lo.cur
  %half = udiv i64 %diff, 2
  %mid = add i64 %lo.cur, %half
  %mid.ptr = getelementptr inbounds i32, i32* %a, i64 %mid
  %pivot = load i32, i32* %mid.ptr, align 4
  %i0 = add i64 %lo.cur, 0
  %j0 = add i64 %hi.cur, 0
  br label %loop.header

loop.header:                                     ; preds = %swap, %decJ, %incI, %outer.body
  %i.cur = phi i64 [ %i0, %outer.body ], [ %i.next, %incI ], [ %i.inc, %swap ], [ %i.cur, %decJ ]
  %j.cur = phi i64 [ %j0, %outer.body ], [ %j.cur, %incI ], [ %j.dec, %swap ], [ %j.next, %decJ ]
  %i.ptr = getelementptr inbounds i32, i32* %a, i64 %i.cur
  %iv = load i32, i32* %i.ptr, align 4
  %cmpI = icmp slt i32 %iv, %pivot
  br i1 %cmpI, label %incI, label %checkJ

incI:                                             ; preds = %loop.header
  %i.next = add i64 %i.cur, 1
  br label %loop.header

checkJ:                                          ; preds = %loop.header
  %j.ptr = getelementptr inbounds i32, i32* %a, i64 %j.cur
  %jv = load i32, i32* %j.ptr, align 4
  %cmpJ = icmp slt i32 %pivot, %jv
  br i1 %cmpJ, label %decJ, label %checkIJ

decJ:                                             ; preds = %checkJ
  %j.next = add i64 %j.cur, -1
  br label %loop.header

checkIJ:                                         ; preds = %checkJ
  %ijcmp = icmp sle i64 %i.cur, %j.cur
  br i1 %ijcmp, label %swap, label %partition.done

swap:                                            ; preds = %checkIJ
  store i32 %jv, i32* %i.ptr, align 4
  store i32 %iv, i32* %j.ptr, align 4
  %i.inc = add i64 %i.cur, 1
  %j.dec = add i64 %j.cur, -1
  br label %loop.header

partition.done:                                  ; preds = %checkIJ
  ; choose smaller side for recursion, then update lo/hi and tail-loop
  %leftSize = sub i64 %j.cur, %lo.cur
  %rightSize = sub i64 %hi.cur, %i.cur
  %leftSmaller = icmp slt i64 %leftSize, %rightSize
  br i1 %leftSmaller, label %leftFirst, label %rightFirst

leftFirst:                                       ; preds = %partition.done
  %doLeft = icmp slt i64 %lo.cur, %j.cur
  br i1 %doLeft, label %callLeft, label %skipLeft

callLeft:                                        ; preds = %leftFirst
  call void @quick_sort(i32* noundef %a, i64 noundef %lo.cur, i64 noundef %j.cur)
  br label %skipLeft

skipLeft:                                        ; preds = %callLeft, %leftFirst
  %lo.next.l = add i64 %i.cur, 0
  %hi.next.l = add i64 %hi.cur, 0
  br label %outer.cont

rightFirst:                                      ; preds = %partition.done
  %doRight = icmp slt i64 %i.cur, %hi.cur
  br i1 %doRight, label %callRight, label %skipRight

callRight:                                       ; preds = %rightFirst
  call void @quick_sort(i32* noundef %a, i64 noundef %i.cur, i64 noundef %hi.cur)
  br label %skipRight

skipRight:                                       ; preds = %callRight, %rightFirst
  %lo.next.r = add i64 %lo.cur, 0
  %hi.next.r = add i64 %j.cur, 0
  br label %outer.cont

outer.cont:                                      ; preds = %skipRight, %skipLeft
  %lo.next = phi i64 [ %lo.next.l, %skipLeft ], [ %lo.next.r, %skipRight ]
  %hi.next = phi i64 [ %hi.next.l, %skipLeft ], [ %hi.next.r, %skipRight ]
  br label %outer.cond

ret:                                             ; preds = %outer.cond
  ret void
}

define dso_local i32 @main(i32 noundef %argc, i8** noundef %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  ; initialize: 9,1,5,3,7,2,8,6,4,0
  %p0 = getelementptr inbounds i32, i32* %0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %0, i64 9
  store i32 0, i32* %p9, align 4

  call void @quick_sort(i32* noundef %0, i64 noundef 0, i64 noundef 9)

  br label %print.loop

print.loop:                                      ; preds = %print.loop, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %print.loop ]
  %elem.ptr = getelementptr inbounds i32, i32* %0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt, i32 %elem)
  %i.next = add i64 %i, 1
  %cont = icmp ult i64 %i.next, 10
  br i1 %cont, label %print.loop, label %after.print

after.print:                                     ; preds = %print.loop
  %fmt1 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt1)
  ret i32 0
}