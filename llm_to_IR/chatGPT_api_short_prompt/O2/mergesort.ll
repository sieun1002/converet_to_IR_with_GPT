; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x10C0
; Intent: Bottom-up mergesort of 10 ints then print them (confidence=0.94). Evidence: malloc(40) temp buffer; iterative merge with width doubling and printf("%d ").
; Preconditions: None
; Postconditions: Prints ten integers followed by newline.

; Only the necessary external declarations:
declare i32 @__printf_chk(i32, i8*, ...)
declare i8* @malloc(i64)
declare void @free(i8*)

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arrp = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  ; Initialize array: 9,1,5,3,7,2,8,6,4,0
  %p0 = getelementptr inbounds i32, i32* %arrp, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %arrp, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arrp, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arrp, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arrp, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arrp, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arrp, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arrp, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arrp, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arrp, i64 9
  store i32 0, i32* %p9, align 4

  %m = call i8* @malloc(i64 40)
  %isnull = icmp eq i8* %m, null
  br i1 %isnull, label %print, label %sort

sort:
  %tmp32 = bitcast i8* %m to i32*
  br label %outer

outer:
  %src = phi i32* [ %arrp, %sort ], [ %srcNext, %afterInnerSwap ]
  %dst = phi i32* [ %tmp32, %sort ], [ %dstNext, %afterInnerSwap ]
  %width = phi i32 [ 1, %sort ], [ %width2, %afterInnerSwap ]
  %passesLeft = phi i32 [ 4, %sort ], [ %passesDec, %afterInnerSwap ]
  br label %inner.loop

inner.loop:
  %i = phi i32 [ 0, %outer ], [ %iNext, %afterMergeRange ]
  %cond_i = icmp slt i32 %i, 10
  br i1 %cond_i, label %computeRange, label %endInner

computeRange:
  %left = %i
  %tmp1 = add nsw i32 %i, %width
  %cmp1 = icmp slt i32 %tmp1, 10
  %mid = select i1 %cmp1, i32 %tmp1, i32 10
  %twoWidth = shl i32 %width, 1
  %tmp2 = add nsw i32 %i, %twoWidth
  %cmp2 = icmp slt i32 %tmp2, 10
  %right = select i1 %cmp2, i32 %tmp2, i32 10
  br label %merge.loop

merge.loop:
  %destPos = phi i32 [ %left, %computeRange ], [ %destPosNext, %doStore ]
  %l = phi i32 [ %left, %computeRange ], [ %lNext, %doStore ]
  %r = phi i32 [ %mid, %computeRange ], [ %rNext, %doStore ]
  %cmp_dest = icmp slt i32 %destPos, %right
  br i1 %cmp_dest, label %lcheck, label %afterRange

lcheck:
  %l_lt_mid = icmp slt i32 %l, %mid
  br i1 %l_lt_mid, label %rightCheck, label %chooseRightFromElse

rightCheck:
  %r_lt_right = icmp slt i32 %r, %right
  br i1 %r_lt_right, label %bothAvail, label %chooseLeft

bothAvail:
  %l_idx64 = sext i32 %l to i64
  %r_idx64 = sext i32 %r to i64
  %lp = getelementptr inbounds i32, i32* %src, i64 %l_idx64
  %rp = getelementptr inbounds i32, i32* %src, i64 %r_idx64
  %lval = load i32, i32* %lp, align 4
  %rval = load i32, i32* %rp, align 4
  %r_less_l = icmp slt i32 %rval, %lval
  br i1 %r_less_l, label %chooseRight, label %chooseLeft

chooseLeft:
  %l_idx64.cl = sext i32 %l to i64
  %lp.cl = getelementptr inbounds i32, i32* %src, i64 %l_idx64.cl
  %valL = load i32, i32* %lp.cl, align 4
  %lNext = add nsw i32 %l, 1
  %rNext = %r
  br label %doStore

chooseRightFromElse:
  br label %chooseRight

chooseRight:
  %r_idx64.cr = sext i32 %r to i64
  %rp.cr = getelementptr inbounds i32, i32* %src, i64 %r_idx64.cr
  %valR = load i32, i32* %rp.cr, align 4
  %lNext.cr = %l
  %rNext.cr = add nsw i32 %r, 1
  br label %doStore

doStore:
  %val = phi i32 [ %valL, %chooseLeft ], [ %valR, %chooseRight ]
  %lNext.ph = phi i32 [ %lNext, %chooseLeft ], [ %lNext.cr, %chooseRight ]
  %rNext.ph = phi i32 [ %rNext, %chooseLeft ], [ %rNext.cr, %chooseRight ]
  %dest_idx64 = sext i32 %destPos to i64
  %destp = getelementptr inbounds i32, i32* %dst, i64 %dest_idx64
  store i32 %val, i32* %destp, align 4
  %destPosNext = add nsw i32 %destPos, 1
  br label %merge.loop

afterRange:
  %twoWidth2 = shl i32 %width, 1
  %iNext = add nsw i32 %i, %twoWidth2
  %cond_i2 = icmp slt i32 %iNext, 10
  br i1 %cond_i2, label %inner.loop, label %endInner

endInner:
  %passesDec = add nsw i32 %passesLeft, -1
  %done = icmp eq i32 %passesDec, 0
  br i1 %done, label %afterSortWithDst, label %afterInnerSwap

afterInnerSwap:
  %width2 = shl i32 %width, 1
  %srcNext = %dst
  %dstNext = %src
  br label %outer

afterSortWithDst:
  %dstEqArr = icmp eq i32* %dst, %arrp
  br i1 %dstEqArr, label %afterCopy, label %copyLoop

copyLoop:
  %j = phi i32 [ 0, %afterSortWithDst ], [ %jNext, %copyLoop ]
  %j64 = sext i32 %j to i64
  %srcje = getelementptr inbounds i32, i32* %dst, i64 %j64
  %valc = load i32, i32* %srcje, align 4
  %arrje = getelementptr inbounds i32, i32* %arrp, i64 %j64
  store i32 %valc, i32* %arrje, align 4
  %jNext = add nsw i32 %j, 1
  %condj = icmp slt i32 %jNext, 10
  br i1 %condj, label %copyLoop, label %afterCopy

afterCopy:
  call void @free(i8* %m)
  br label %print

print:
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  br label %print.loop

print.loop:
  %ip = phi i32 [ 0, %print ], [ %ipNext, %print.loop ]
  %ip64 = sext i32 %ip to i64
  %ppe = getelementptr inbounds i32, i32* %arrp, i64 %ip64
  %v = load i32, i32* %ppe, align 4
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtptr, i32 %v)
  %ipNext = add nsw i32 %ip, 1
  %cont = icmp slt i32 %ipNext, 10
  br i1 %cont, label %print.loop, label %printEnd

printEnd:
  %calle = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlptr)
  ret i32 0
}