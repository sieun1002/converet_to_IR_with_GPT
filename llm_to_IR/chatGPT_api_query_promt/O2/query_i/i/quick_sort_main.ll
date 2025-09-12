; ModuleID = 'quicksort.ll'
source_filename = "quicksort"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)

define dso_local void @quick_sort(i32* nocapture %base, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  ; if (lo >= hi) return;
  %cmp0 = icmp sge i64 %lo, %hi
  br i1 %cmp0, label %ret, label %loop.head

loop.head:                                           ; preds = %entry, %after.recurse
  ; mid, pivot, i, j for this iteration
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.next, %after.recurse ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.next, %after.recurse ]

  ; if (lo.cur >= hi.cur) break
  %cmp1 = icmp sge i64 %lo.cur, %hi.cur
  br i1 %cmp1, label %ret, label %partition.init

partition.init:                                      ; preds = %loop.head
  ; mid = (lo + hi) >> 1
  %sub = sub nsw i64 %hi.cur, %lo.cur
  %shr = ashr i64 %sub, 1
  %mid = add nsw i64 %lo.cur, %shr
  ; pivot = base[mid]
  %mid.ptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %pivot = load i32, i32* %mid.ptr, align 4
  ; i = lo, j = hi
  %i.init = %lo.cur
  %j.init = %hi.cur
  br label %part.loop

; Partition loop:
; while (true) {
;   while (base[i] < pivot) i++;
;   while (pivot < base[j]) j--;
;   if (i > j) break;
;   swap(base[i], base[j]);
;   i++; j--;
; }
part.loop:                                           ; preds = %j.dec, %partition.init
  %i.val = phi i64 [ %i.init, %partition.init ], [ %i.next2, %j.dec ]
  %j.val = phi i64 [ %j.init, %partition.init ], [ %j.next2, %j.dec ]
  ; while_i:
  br label %i.inc

i.inc:                                               ; preds = %i.inc, %part.loop
  %i.cur = phi i64 [ %i.val, %part.loop ], [ %i.next, %i.inc ]
  %i.ptr = getelementptr inbounds i32, i32* %base, i64 %i.cur
  %i.val.load = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp slt i32 %i.val.load, %pivot
  %i.next = add nsw i64 %i.cur, 1
  br i1 %cmp.i, label %i.inc, label %j.inc

j.inc:                                               ; preds = %i.inc, %j.inc
  %j.cur = phi i64 [ %j.val, %i.inc ], [ %j.next, %j.inc ]
  %j.ptr = getelementptr inbounds i32, i32* %base, i64 %j.cur
  %j.val.load = load i32, i32* %j.ptr, align 4
  ; pivot < base[j]  <=>  base[j] > pivot
  %cmp.j = icmp sgt i32 %j.val.load, %pivot
  %j.next = add nsw i64 %j.cur, -1
  br i1 %cmp.j, label %j.inc, label %check.swap

check.swap:                                          ; preds = %j.inc
  ; if (i.cur > j.cur) break
  %i.cur2 = phi i64 [ %i.cur, %j.inc ]
  %j.cur2 = phi i64 [ %j.cur, %j.inc ]
  %cmp.ij = icmp sgt i64 %i.cur2, %j.cur2
  br i1 %cmp.ij, label %after.part, label %do.swap

do.swap:                                             ; preds = %check.swap
  ; swap base[i.cur2], base[j.cur2]
  %ip = getelementptr inbounds i32, i32* %base, i64 %i.cur2
  %jp = getelementptr inbounds i32, i32* %base, i64 %j.cur2
  %vi = load i32, i32* %ip, align 4
  %vj = load i32, i32* %jp, align 4
  store i32 %vj, i32* %ip, align 4
  store i32 %vi, i32* %jp, align 4
  ; i++, j--
  %i.next2 = add nsw i64 %i.cur2, 1
  %j.next2 = add nsw i64 %j.cur2, -1
  br label %j.dec

j.dec:                                               ; preds = %do.swap
  br label %part.loop

after.part:                                          ; preds = %check.swap
  ; Here: i = i.cur2, j = j.cur2
  %i.end = %i.cur2
  %j.end = %j.cur2

  ; Choose smaller segment to recurse
  %left.len  = sub nsw i64 %j.end, %lo.cur
  %right.len = sub nsw i64 %hi.cur, %i.end
  %left.lt.right = icmp slt i64 %left.len, %right.len
  br i1 %left.lt.right, label %left.small, label %right.small

left.small:                                          ; preds = %after.part
  ; If left exists, recurse on [lo, j]
  %have.left = icmp slt i64 %lo.cur, %j.end
  br i1 %have.left, label %recurse.left, label %skip.left

recurse.left:                                        ; preds = %left.small
  call void @quick_sort(i32* %base, i64 %lo.cur, i64 %j.end)
  br label %skip.left

skip.left:                                           ; preds = %recurse.left, %left.small
  ; Continue iteratively with [i, hi]
  %lo.next.l = %i.end
  %hi.next.l = %hi.cur
  br label %after.recurse

right.small:                                         ; preds = %after.part
  ; If right exists, recurse on [i, hi]
  %have.right = icmp slt i64 %i.end, %hi.cur
  br i1 %have.right, label %recurse.right, label %skip.right

recurse.right:                                       ; preds = %right.small
  call void @quick_sort(i32* %base, i64 %i.end, i64 %hi.cur)
  br label %skip.right

skip.right:                                          ; preds = %recurse.right, %right.small
  ; Continue iteratively with [lo, j]
  %lo.next.r = %lo.cur
  %hi.next.r = %j.end
  br label %after.recurse

after.recurse:                                       ; preds = %skip.right, %skip.left
  %lo.next = phi i64 [ %lo.next.l, %skip.left ], [ %lo.next.r, %skip.right ]
  %hi.next = phi i64 [ %hi.next.l, %skip.left ], [ %hi.next.r, %skip.right ]
  br label %loop.head

ret:                                                 ; preds = %loop.head, %entry
  ret void
}

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; int arr[10] = {9,1,5,3,7,2,8,6,4,0};
  %arr = alloca [10 x i32], align 16
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 16
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 8
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 16
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 8
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 16
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4

  ; quick_sort(arr, 0, 9)
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %base, i64 0, i64 9)

  ; print sorted array: for i=0..9: __printf_chk(1, "%d ", arr[i])
  br label %print.loop

print.loop:                                          ; preds = %print.loop, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %print.loop ]
  %elem.ptr = getelementptr inbounds i32, i32* %base, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* nonnull %fmt.ptr, i32 %elem)
  %i.next = add nuw nsw i64 %i, 1
  %cont = icmp ult i64 %i.next, 10
  br i1 %cont, label %print.loop, label %after.print

after.print:                                         ; preds = %print.loop
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* nonnull %nl.ptr)
  ret i32 0
}