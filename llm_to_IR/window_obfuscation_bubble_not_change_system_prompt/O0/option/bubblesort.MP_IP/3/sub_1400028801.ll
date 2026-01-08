; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global <4 x i32>, align 16
@xmmword_140004020 = external global <4 x i32>, align 16
@unk_140004000 = external global [0 x i8]

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)
declare void @"loc_14000272D+3"(i32)

define i32 @sub_140002880() {
entry:
  %arr = alloca [10 x i32], align 16
  call void @sub_140001520()
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_140004010, align 16
  %vecptr0 = bitcast i32* %arr.base to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %vecptr0, align 16
  %arr.base.plus4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  %vecptr1 = bitcast i32* %arr.base.plus4 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_140004020, align 16
  store <4 x i32> %v1, <4 x i32>* %vecptr1, align 16
  %elem8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %elem8, align 4
  br label %outer.prep

outer.prep:
  %n = phi i64 [ 10, %entry ], [ %n2, %outer.restart ]
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  br label %inner.cond

inner.cond:
  %i = phi i64 [ 1, %outer.prep ], [ %i.next, %cont ]
  %p = phi i32* [ %p0, %outer.prep ], [ %p.next, %cont ]
  %lastSwap.phi = phi i64 [ 0, %outer.prep ], [ %lastSwap.updated, %cont ]
  %cmp.i.n = icmp eq i64 %i, %n
  br i1 %cmp.i.n, label %inner.done, label %inner.body

inner.body:
  %a = load i32, i32* %p, align 4
  %p.plus1 = getelementptr inbounds i32, i32* %p, i64 1
  %b = load i32, i32* %p.plus1, align 4
  %need.swap = icmp slt i32 %b, %a
  br i1 %need.swap, label %swap, label %noswap

swap:
  store i32 %b, i32* %p, align 4
  store i32 %a, i32* %p.plus1, align 4
  br label %cont

noswap:
  br label %cont

cont:
  %lastSwap.updated = phi i64 [ %i, %swap ], [ %lastSwap.phi, %noswap ]
  %i.next = add i64 %i, 1
  %p.next = getelementptr inbounds i32, i32* %p, i64 1
  br label %inner.cond

inner.done:
  %anyMore = icmp ugt i64 %lastSwap.phi, 1
  br i1 %anyMore, label %outer.restart, label %print.prelude

outer.restart:
  %n2 = add i64 %lastSwap.phi, 0
  br label %outer.prep

print.prelude:
  %start = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %end = getelementptr inbounds i32, i32* %start, i64 10
  br label %print.loop

print.loop:
  %cur = phi i32* [ %start, %print.prelude ], [ %next, %print.cont ]
  %done = icmp eq i32* %cur, %end
  br i1 %done, label %print.done, label %print.body

print.body:
  %val = load i32, i32* %cur, align 4
  %fmtptr = getelementptr inbounds [0 x i8], [0 x i8]* @unk_140004000, i64 0, i64 0
  call void @sub_1400025A0(i8* %fmtptr, i32 %val)
  br label %print.cont

print.cont:
  %next = getelementptr inbounds i32, i32* %cur, i64 1
  br label %print.loop

print.done:
  call void @"loc_14000272D+3"(i32 10)
  ret i32 0
}