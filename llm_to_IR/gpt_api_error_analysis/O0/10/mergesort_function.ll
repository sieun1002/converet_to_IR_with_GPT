target triple = "x86_64-unknown-linux-gnu"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* noundef %dest, i64 noundef %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %alloc

alloc:
  %bytes = shl i64 %n, 2
  %m = call i8* @malloc(i64 %bytes)
  %isnull = icmp eq i8* %m, null
  br i1 %isnull, label %ret, label %init

init:
  %tmp0 = bitcast i8* %m to i32*
  br label %outer

outer:
  %srcPhi = phi i32* [ %dest, %init ], [ %srcSwapped, %afterInner ]
  %tmpPhi = phi i32* [ %tmp0, %init ], [ %tmpSwapped, %afterInner ]
  %width = phi i64 [ 1, %init ], [ %widthNext, %afterInner ]
  %cmpWidth = icmp ult i64 %width, %n
  br i1 %cmpWidth, label %innerHeader, label %afterOuter

innerHeader:
  %iBlock = phi i64 [ 0, %outer ], [ %iNext, %afterBlock ]
  %hasMoreBlocks = icmp ult i64 %iBlock, %n
  br i1 %hasMoreBlocks, label %blockInit, label %afterInner

blockInit:
  %midCand = add i64 %iBlock, %width
  %midCond = icmp ult i64 %midCand, %n
  %mid = select i1 %midCond, i64 %midCand, i64 %n
  %twoW_outer = add i64 %width, %width
  %rightCand = add i64 %iBlock, %twoW_outer
  %rightCond = icmp ult i64 %rightCand, %n
  %right = select i1 %rightCond, i64 %rightCand, i64 %n
  %k0 = add i64 %iBlock, 0
  %l0 = add i64 %iBlock, 0
  %r0 = add i64 %mid, 0
  br label %mergeLoop

mergeLoop:
  %k = phi i64 [ %k0, %blockInit ], [ %kNextL, %takeL ], [ %kNextR, %takeR ]
  %l = phi i64 [ %l0, %blockInit ], [ %lNext, %takeL ], [ %l, %takeR ]
  %r = phi i64 [ %r0, %blockInit ], [ %r, %takeL ], [ %rNext, %takeR ]
  %kCond = icmp ult i64 %k, %right
  br i1 %kCond, label %cmpL, label %afterBlock

cmpL:
  %lLT = icmp ult i64 %l, %mid
  br i1 %lLT, label %checkR, label %takeR

checkR:
  %rLT = icmp ult i64 %r, %right
  br i1 %rLT, label %loadBoth, label %takeL

loadBoth:
  %lptr1 = getelementptr inbounds i32, i32* %srcPhi, i64 %l
  %aval1 = load i32, i32* %lptr1, align 4
  %rptr1 = getelementptr inbounds i32, i32* %srcPhi, i64 %r
  %bval1 = load i32, i32* %rptr1, align 4
  %leCmp = icmp sle i32 %aval1, %bval1
  br i1 %leCmp, label %takeL, label %takeR

takeL:
  %lptr2 = getelementptr inbounds i32, i32* %srcPhi, i64 %l
  %valL = load i32, i32* %lptr2, align 4
  %tptrL = getelementptr inbounds i32, i32* %tmpPhi, i64 %k
  store i32 %valL, i32* %tptrL, align 4
  %lNext = add i64 %l, 1
  %kNextL = add i64 %k, 1
  br label %mergeLoop

takeR:
  %rptr2 = getelementptr inbounds i32, i32* %srcPhi, i64 %r
  %valR = load i32, i32* %rptr2, align 4
  %tptrR = getelementptr inbounds i32, i32* %tmpPhi, i64 %k
  store i32 %valR, i32* %tptrR, align 4
  %rNext = add i64 %r, 1
  %kNextR = add i64 %k, 1
  br label %mergeLoop

afterBlock:
  %iNext = add i64 %iBlock, %twoW_outer
  br label %innerHeader

afterInner:
  %srcSwapped = add i32* %tmpPhi, null
  %tmpSwapped = add i32* %srcPhi, null
  %widthNext = shl i64 %width, 1
  br label %outer

afterOuter:
  %srcFinal = add i32* %srcPhi, null
  %needCopy = icmp ne i32* %srcFinal, %dest
  br i1 %needCopy, label %doCopy, label %skipCopy

doCopy:
  %dest8 = bitcast i32* %dest to i8*
  %src8 = bitcast i32* %srcFinal to i8*
  %callmem = call i8* @memcpy(i8* %dest8, i8* %src8, i64 %bytes)
  br label %freeblock

skipCopy:
  br label %freeblock

freeblock:
  call void @free(i8* %m)
  br label %ret

ret:
  ret void
}