; ModuleID = 'sub_140002880'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global <16 x i8>, align 16
@xmmword_140004020 = external global <16 x i8>, align 16
@unk_140004000 = external global [0 x i8]

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)
declare void @sub_140002730(i32)

define i32 @sub_140002880() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  call void @sub_140001520()
  %base.i32 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %base.i8 = bitcast i32* %base.i32 to i8*
  %off32.i8 = getelementptr inbounds i8, i8* %base.i8, i64 32
  %off32.i64p = bitcast i8* %off32.i8 to i64*
  store i64 4, i64* %off32.i64p, align 1
  %v1 = load <16 x i8>, <16 x i8>* @xmmword_140004010, align 1
  %p0.vec = bitcast i8* %base.i8 to <16 x i8>*
  store <16 x i8> %v1, <16 x i8>* %p0.vec, align 1
  %off16.i8 = getelementptr inbounds i8, i8* %base.i8, i64 16
  %p16.vec = bitcast i8* %off16.i8 to <16 x i8>*
  %v2 = load <16 x i8>, <16 x i8>* @xmmword_140004020, align 1
  store <16 x i8> %v2, <16 x i8>* %p16.vec, align 1
  br label %outer.loop

outer.loop:                                        ; preds = %outer.after, %entry
  %limit = phi i64 [ 10, %entry ], [ %lastSwap.out, %outer.after ]
  br label %inner.body

inner.body:                                        ; preds = %cont, %outer.loop
  %i = phi i64 [ 1, %outer.loop ], [ %i.next, %cont ]
  %lastSwap = phi i64 [ 0, %outer.loop ], [ %lastSwap.next, %cont ]
  %k = add i64 %i, -1
  %ptr.k = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %k
  %a = load i32, i32* %ptr.k, align 4
  %ptr.i = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %b = load i32, i32* %ptr.i, align 4
  %cmp = icmp sge i32 %b, %a
  br i1 %cmp, label %noswap, label %doswap

doswap:                                            ; preds = %inner.body
  store i32 %b, i32* %ptr.k, align 4
  store i32 %a, i32* %ptr.i, align 4
  br label %cont

noswap:                                            ; preds = %inner.body
  br label %cont

cont:                                              ; preds = %noswap, %doswap
  %lastSwap.next = phi i64 [ %i, %doswap ], [ %lastSwap, %noswap ]
  %i.next = add i64 %i, 1
  %cond.inner = icmp ne i64 %i.next, %limit
  br i1 %cond.inner, label %inner.body, label %outer.after

outer.after:                                       ; preds = %cont
  %lastSwap.out = phi i64 [ %lastSwap.next, %cont ]
  %stop = icmp ule i64 %lastSwap.out, 1
  br i1 %stop, label %print.init, label %outer.loop

print.init:                                        ; preds = %outer.after
  %start = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %end = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 10
  br label %print.loop

print.loop:                                        ; preds = %print.loop, %print.init
  %p.cur = phi i32* [ %start, %print.init ], [ %p.next, %print.loop ]
  %val = load i32, i32* %p.cur, align 4
  %fmt.ptr = bitcast [0 x i8]* @unk_140004000 to i8*
  call void @sub_1400025A0(i8* %fmt.ptr, i32 %val)
  %p.next = getelementptr inbounds i32, i32* %p.cur, i64 1
  %done = icmp ne i32* %p.next, %end
  br i1 %done, label %print.loop, label %after.print

after.print:                                       ; preds = %print.loop
  call void @sub_140002730(i32 10)
  ret i32 0
}