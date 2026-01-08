; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global <4 x i32>, align 16
@xmmword_140004020 = external global <4 x i32>, align 16
@unk_140004000 = external global i8, align 1

declare void @sub_140001520()
declare i32 @sub_1400025A0(i8*, i32)
declare void @loc_140002730(i32)

define i32 @sub_140002880() {
entry:
  call void @sub_140001520()

  %buf = alloca [40 x i8], align 16
  %base.i8 = getelementptr inbounds [40 x i8], [40 x i8]* %buf, i64 0, i64 0

  %vptr0 = bitcast i8* %base.i8 to <4 x i32>*
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_140004010, align 16
  store <4 x i32> %v0, <4 x i32>* %vptr0, align 1

  %off16 = getelementptr inbounds i8, i8* %base.i8, i64 16
  %vptr1 = bitcast i8* %off16 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_140004020, align 16
  store <4 x i32> %v1, <4 x i32>* %vptr1, align 1

  %off32 = getelementptr inbounds i8, i8* %base.i8, i64 32
  %off32.i32 = bitcast i8* %off32 to i32*
  store i32 4, i32* %off32.i32, align 1

  br label %outer.header

outer.header:
  %right = phi i32 [ 10, %entry ], [ %right.next, %outer.latch ]
  br label %inner.header

inner.header:
  %i = phi i32 [ 1, %outer.header ], [ %i.next, %inner.latch ]
  %rdx.ptr = phi i8* [ %base.i8, %outer.header ], [ %rdx.next, %inner.latch ]
  %lastSwap = phi i32 [ 0, %outer.header ], [ %last.next, %inner.latch ]
  %cmp.end = icmp eq i32 %i, %right
  br i1 %cmp.end, label %after.inner, label %do.cmp

do.cmp:
  %a.ptr = bitcast i8* %rdx.ptr to i32*
  %a = load i32, i32* %a.ptr, align 1
  %b.ptr.i8 = getelementptr inbounds i8, i8* %rdx.ptr, i64 4
  %b.ptr = bitcast i8* %b.ptr.i8 to i32*
  %b = load i32, i32* %b.ptr, align 1
  %need.swap = icmp slt i32 %b, %a
  br i1 %need.swap, label %do.swap, label %no.swap

do.swap:
  store i32 %b, i32* %a.ptr, align 1
  store i32 %a, i32* %b.ptr, align 1
  br label %inner.latch

no.swap:
  br label %inner.latch

inner.latch:
  %last.next = phi i32 [ %i, %do.swap ], [ %lastSwap, %no.swap ]
  %i.next = add i32 %i, 1
  %rdx.next = getelementptr inbounds i8, i8* %rdx.ptr, i64 4
  br label %inner.header

after.inner:
  %gt1 = icmp ugt i32 %lastSwap, 1
  br i1 %gt1, label %outer.latch, label %print.prep

outer.latch:
  %right.next = phi i32 [ %lastSwap, %after.inner ]
  br label %outer.header

print.prep:
  %end.ptr = getelementptr inbounds i8, i8* %base.i8, i64 40
  br label %print.loop

print.loop:
  %p = phi i8* [ %base.i8, %print.prep ], [ %p.next, %print.latch ]
  %done = icmp eq i8* %p, %end.ptr
  br i1 %done, label %after.print, label %print.body

print.body:
  %ival.ptr = bitcast i8* %p to i32*
  %ival = load i32, i32* %ival.ptr, align 1
  %call = call i32 @sub_1400025A0(i8* @unk_140004000, i32 %ival)
  br label %print.latch

print.latch:
  %p.next = getelementptr inbounds i8, i8* %p, i64 4
  br label %print.loop

after.print:
  call void @loc_140002730(i32 10)
  ret i32 0
}