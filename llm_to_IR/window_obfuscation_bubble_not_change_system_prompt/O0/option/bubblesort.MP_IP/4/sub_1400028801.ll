; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global <4 x i32>, align 16
@xmmword_140004020 = external global <4 x i32>, align 16
@unk_140004000 = external global i8, align 1

declare void @sub_140001520()
declare i32 @sub_1400025A0(i8* noundef, i32 noundef)
declare void @"loc_14000272D+3"(i32 noundef)

define i32 @sub_140002880() {
entry:
  %arr = alloca [10 x i32], align 16
  call void @sub_140001520()
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %arr.idx8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %arr.idx8, align 4
  %vec0.dst = bitcast i32* %arr.base to <4 x i32>*
  %vec0 = load <4 x i32>, <4 x i32>* @xmmword_140004010, align 16
  store <4 x i32> %vec0, <4 x i32>* %vec0.dst, align 16
  %arr.idx4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  %vec1.dst = bitcast i32* %arr.idx4 to <4 x i32>*
  %vec1 = load <4 x i32>, <4 x i32>* @xmmword_140004020, align 16
  store <4 x i32> %vec1, <4 x i32>* %vec1.dst, align 16
  br label %outer.header

outer.header:                                    ; preds = %outer.latch, %entry
  %limit = phi i64 [ 10, %entry ], [ %limit.next, %outer.latch ]
  br label %inner.header

inner.header:                                    ; preds = %inner.latch, %outer.header
  %i = phi i64 [ 1, %outer.header ], [ %i.next, %inner.latch ]
  %last = phi i64 [ 0, %outer.header ], [ %last.next, %inner.latch ]
  %cmp.i = icmp ult i64 %i, %limit
  br i1 %cmp.i, label %inner.body, label %after.inner

inner.body:                                      ; preds = %inner.header
  %im1 = add i64 %i, -1
  %p0 = getelementptr inbounds i32, i32* %arr.base, i64 %im1
  %p1 = getelementptr inbounds i32, i32* %arr.base, i64 %i
  %v0 = load i32, i32* %p0, align 4
  %v1 = load i32, i32* %p1, align 4
  %need.swap = icmp slt i32 %v1, %v0
  br i1 %need.swap, label %do.swap, label %no.swap

do.swap:                                         ; preds = %inner.body
  store i32 %v1, i32* %p0, align 4
  store i32 %v0, i32* %p1, align 4
  br label %inner.latch

no.swap:                                         ; preds = %inner.body
  br label %inner.latch

inner.latch:                                     ; preds = %no.swap, %do.swap
  %last.next = phi i64 [ %i, %do.swap ], [ %last, %no.swap ]
  %i.next = add i64 %i, 1
  br label %inner.header

after.inner:                                     ; preds = %inner.header
  %last.end = phi i64 [ %last, %inner.header ]
  %has.more = icmp ugt i64 %last.end, 1
  br i1 %has.more, label %outer.latch, label %print.init

outer.latch:                                     ; preds = %after.inner
  %limit.next = phi i64 [ %last.end, %after.inner ]
  br label %outer.header

print.init:                                      ; preds = %after.inner, %print.body
  %cur = phi i32* [ %arr.base, %after.inner ], [ %next, %print.body ]
  %end = getelementptr inbounds i32, i32* %arr.base, i64 10
  %cont = icmp ne i32* %cur, %end
  br i1 %cont, label %print.body, label %after.print

print.body:                                      ; preds = %print.init
  %val = load i32, i32* %cur, align 4
  %next = getelementptr inbounds i32, i32* %cur, i64 1
  %fmtptr = getelementptr inbounds i8, i8* @unk_140004000, i64 0
  %call = call i32 @sub_1400025A0(i8* %fmtptr, i32 %val)
  br label %print.init

after.print:                                     ; preds = %print.init
  call void @"loc_14000272D+3"(i32 10)
  ret i32 0
}