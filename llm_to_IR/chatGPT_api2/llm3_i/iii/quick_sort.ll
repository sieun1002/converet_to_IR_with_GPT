; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10C0
; Intent: iterative mergesort of 10 ints then print (confidence=0.93). Evidence: malloc of 40 bytes (10 i32); iterative merge loops over runs; prints "%d "
; Preconditions: None
; Postconditions: Prints the (sorted if malloc succeeds) sequence then returns 0

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 16
  %p1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 5, i32* %p2, align 8
  %p3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7, i32* %p4, align 16
  %p5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 8, i32* %p6, align 8
  %p7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %p8, align 16
  %p9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0, i32* %p9, align 4
  %tmpraw = call noalias i8* @malloc(i64 40)
  %isnull = icmp eq i8* %tmpraw, null
  br i1 %isnull, label %print, label %sort.init

sort.init:
  %tmp = bitcast i8* %tmpraw to i32*
  br label %outer

outer:
  %len = phi i32 [ 1, %sort.init ], [ %len.next, %outer.end ]
  %rounds = phi i32 [ 4, %sort.init ], [ %rounds.next, %outer.end ]
  %src = phi i32* [ %arr0, %sort.init ], [ %src.next, %outer.end ]
  %dst = phi i32* [ %tmp, %sort.init ], [ %dst.next, %outer.end ]
  br label %for.i

for.i:
  %i = phi i32 [ 0, %outer ], [ %i.next, %for.i.end ]
  %icmp = icmp slt i32 %i, 10
  br i1 %icmp, label %prepare.merge, label %outer.end

prepare.merge:
  %i64 = sext i32 %i to i64
  %mid0 = add i32 %i, %len
  %mid_gt = icmp sgt i32 %mid0, 10
  %mid = select i1 %mid_gt, i32 10, i32 %mid0
  %s0 = add i32 %mid0, %len
  %r_gt = icmp sgt i32 %s0, 10
  %right = select i1 %r_gt, i32 10, i32 %s0
  %r_le_i = icmp sle i32 %right, %i
  br i1 %r_le_i, label %for.i.end, label %merge.init

merge.init:
  %mid64 = sext i32 %mid to i64
  %right64 = sext i32 %right to i64
  br label %merge.loop

merge.loop:
  %leftIdx = phi i64 [ %i64, %merge.init ], [ %leftIdx.next.phi, %merge.loop.next ]
  %rightIdx = phi i64 [ %mid64, %merge.init ], [ %rightIdx.next.phi, %merge.loop.next ]
  %destOff = phi i64 [ %i64, %merge.init ], [ %destOff.next.phi, %merge.loop.next ]
  %dest_lt_right = icmp slt i64 %destOff, %right64
  br i1 %dest_lt_right, label %choose, label %for.i.end

choose:
  %left_ge_mid = icmp sge i64 %leftIdx, %mid64
  br i1 %left_ge_mid, label %take.right, label %check.right.bound

check.right.bound:
  %right_ge_right = icmp sge i64 %rightIdx, %right64
  br i1 %right_ge_right, label %take.left, label %compare

compare:
  %leftPtr = getelementptr inbounds i32, i32* %src, i64 %leftIdx
  %leftVal = load i32, i32* %leftPtr, align 4
  %rightPtr = getelementptr inbounds i32, i32* %src, i64 %rightIdx
  %rightVal = load i32, i32* %rightPtr, align 4
  %cmp = icmp slt i32 %rightVal, %leftVal
  br i1 %cmp, label %take.right, label %take.left

take.left:
  %destPtrL = getelementptr inbounds i32, i32* %dst, i64 %destOff
  %leftPtrL = getelementptr inbounds i32, i32* %src, i64 %leftIdx
  %leftValL = load i32, i32* %leftPtrL, align 4
  store i32 %leftValL, i32* %destPtrL, align 4
  %leftIdx.next = add i64 %leftIdx, 1
  %rightIdx.nextL = %rightIdx
  %destOff.next = add i64 %destOff, 1
  br label %merge.loop.next

take.right:
  %destPtrR = getelementptr inbounds i32, i32* %dst, i64 %destOff
  %rightPtrR = getelementptr inbounds i32, i32* %src, i64 %rightIdx
  %rightValR = load i32, i32* %rightPtrR, align 4
  store i32 %rightValR, i32* %destPtrR, align 4
  %leftIdx.nextR = %leftIdx
  %rightIdx.next = add i64 %rightIdx, 1
  %destOff.nextR = add i64 %destOff, 1
  br label %merge.loop.next

merge.loop.next:
  %leftIdx.next.phi = phi i64 [ %leftIdx.next, %take.left ], [ %leftIdx.nextR, %take.right ]
  %rightIdx.next.phi = phi i64 [ %rightIdx.nextL, %take.left ], [ %rightIdx.next, %take.right ]
  %destOff.next.phi = phi i64 [ %destOff.next, %take.left ], [ %destOff.nextR, %take.right ]
  br label %merge.loop

for.i.end:
  %doubleLen = shl i32 %len, 1
  %i.next = add i32 %i, %doubleLen
  br label %for.i

outer.end:
  %src.next = %dst
  %dst.next = %src
  %len.next = shl i32 %len, 1
  %rounds.next = add i32 %rounds, -1
  %more = icmp ne i32 %rounds.next, 0
  br i1 %more, label %outer, label %after.sort

after.sort:
  %src.final = phi i32* [ %src, %outer.end ]
  %needCopy = icmp ne i32* %src.final, %arr0
  br i1 %needCopy, label %copy.loop, label %free.block

copy.loop:
  br label %copy.head

copy.head:
  %ci = phi i32 [ 0, %copy.loop ], [ %ci.next, %copy.body ]
  %ci.lt = icmp slt i32 %ci, 10
  br i1 %ci.lt, label %copy.body, label %free.block

copy.body:
  %ci64 = sext i32 %ci to i64
  %src.ptr = getelementptr inbounds i32, i32* %src.final, i64 %ci64
  %val = load i32, i32* %src.ptr, align 4
  %dst.ptr = getelementptr inbounds i32, i32* %arr0, i64 %ci64
  store i32 %val, i32* %dst.ptr, align 4
  %ci.next = add i32 %ci, 1
  br label %copy.head

free.block:
  call void @free(i8* %tmpraw)
  br label %print

print:
  br label %print.head

print.head:
  %pi = phi i32 [ 0, %print ], [ 0, %free.block ]
  %pi.lt = icmp slt i32 %pi, 10
  br i1 %pi.lt, label %print.body, label %print.end

print.body:
  %pi64 = sext i32 %pi to i64
  %val.ptr = getelementptr inbounds i32, i32* %arr0, i64 %pi64
  %ival = load i32, i32* %val.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %ival)
  %pi.next = add i32 %pi, 1
  br label %print.head

print.end:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}