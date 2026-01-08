; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external constant [16 x i8]
@xmmword_140004020 = external constant [16 x i8]
@unk_140004000 = external global i8

declare void @sub_140001520()
declare void @sub_1400025A0(i8* noundef, i32 noundef)
declare void @loc_140002730(i32 noundef)

define i32 @sub_140002880() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 4
  call void @sub_140001520()
  %g1.cast = bitcast [16 x i8]* @xmmword_140004010 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* %g1.cast, align 1
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %arr0.vec = bitcast i32* %arr0 to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %arr0.vec, align 1
  %g2.cast = bitcast [16 x i8]* @xmmword_140004020 to <4 x i32>*
  %v2 = load <4 x i32>, <4 x i32>* %g2.cast, align 1
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  %arr4.vec = bitcast i32* %arr4 to <4 x i32>*
  store <4 x i32> %v2, <4 x i32>* %arr4.vec, align 1
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %arr8, align 4
  br label %outer.preheader

outer.preheader:                                   ; preds = %outer.update, %entry
  %limit.phi = phi i64 [ 10, %entry ], [ %limit.update, %outer.update ]
  br label %inner.cond

inner.cond:                                        ; preds = %cont, %outer.preheader
  %idx.phi = phi i64 [ 1, %outer.preheader ], [ %idx.next, %cont ]
  %curPtr.phi = phi i32* [ %arr0, %outer.preheader ], [ %curPtr.next, %cont ]
  %lastSwap.phi = phi i64 [ 0, %outer.preheader ], [ %lastSwap.sel, %cont ]
  %cmp.loop = icmp ne i64 %idx.phi, %limit.phi
  br i1 %cmp.loop, label %inner.body, label %outer.latch

inner.body:                                        ; preds = %inner.cond
  %a = load i32, i32* %curPtr.phi, align 4
  %nextPtr = getelementptr inbounds i32, i32* %curPtr.phi, i64 1
  %b = load i32, i32* %nextPtr, align 4
  %need.swap = icmp slt i32 %b, %a
  br i1 %need.swap, label %do.swap, label %no.swap

do.swap:                                           ; preds = %inner.body
  store i32 %b, i32* %curPtr.phi, align 4
  store i32 %a, i32* %nextPtr, align 4
  br label %cont

no.swap:                                           ; preds = %inner.body
  br label %cont

cont:                                              ; preds = %no.swap, %do.swap
  %lastSwap.sel = phi i64 [ %idx.phi, %do.swap ], [ %lastSwap.phi, %no.swap ]
  %idx.next = add i64 %idx.phi, 1
  %curPtr.next = getelementptr inbounds i32, i32* %curPtr.phi, i64 1
  br label %inner.cond

outer.latch:                                       ; preds = %inner.cond
  %done.or.not = icmp ule i64 %lastSwap.phi, 1
  br i1 %done.or.not, label %print.init, label %outer.update

outer.update:                                      ; preds = %outer.latch
  %limit.update = add i64 %lastSwap.phi, 0
  br label %outer.preheader

print.init:                                        ; preds = %outer.latch
  %endPtr = getelementptr inbounds i32, i32* %arr0, i64 10
  br label %print.loop

print.loop:                                        ; preds = %print.call, %print.init
  %p.phi = phi i32* [ %arr0, %print.init ], [ %p.next, %print.call ]
  %print.cond = icmp ne i32* %p.phi, %endPtr
  br i1 %print.cond, label %print.call, label %after.print

print.call:                                        ; preds = %print.loop
  %val = load i32, i32* %p.phi, align 4
  call void @sub_1400025A0(i8* noundef @unk_140004000, i32 noundef %val)
  %p.next = getelementptr inbounds i32, i32* %p.phi, i64 1
  br label %print.loop

after.print:                                       ; preds = %print.loop
  call void @loc_140002730(i32 noundef 10)
  ret i32 0
}