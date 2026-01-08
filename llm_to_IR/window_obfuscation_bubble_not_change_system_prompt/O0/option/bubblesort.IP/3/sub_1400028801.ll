target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global <4 x i32>, align 16
@xmmword_140004020 = external global <4 x i32>, align 16
@unk_140004000 = external global i8

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)
declare void @loc_140002730(i32)

define i32 @sub_140002880() {
entry:
  %arr = alloca [10 x i32], align 16
  call void @sub_140001520()
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_140004010, align 16
  %idx8ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %idx8ptr, align 4
  %arr0ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %arr0vecptr = bitcast i32* %arr0ptr to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %arr0vecptr, align 16
  %v2 = load <4 x i32>, <4 x i32>* @xmmword_140004020, align 16
  %arr4ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  %arr4vecptr = bitcast i32* %arr4ptr to <4 x i32>*
  store <4 x i32> %v2, <4 x i32>* %arr4vecptr, align 16
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  br label %outer.loop

outer.loop:                                        ; preds = %entry, %outer.cont
  %r9.phi = phi i64 [ 10, %entry ], [ %r9.next, %outer.cont ]
  br label %inner.loop

inner.loop:                                        ; preds = %outer.loop, %inner.latch
  %rax.phi = phi i64 [ 1, %outer.loop ], [ %rax.next, %inner.latch ]
  %rdx.phi = phi i32* [ %base, %outer.loop ], [ %rdx.next, %inner.latch ]
  %r10.phi = phi i64 [ 0, %outer.loop ], [ %r10.update, %inner.after.swap ]
  %a.ptr = bitcast i32* %rdx.phi to i32*
  %b.ptr = getelementptr inbounds i32, i32* %rdx.phi, i64 1
  %a = load i32, i32* %a.ptr, align 4
  %b = load i32, i32* %b.ptr, align 4
  %noswap = icmp sge i32 %b, %a
  br i1 %noswap, label %no.swap, label %do.swap

do.swap:                                           ; preds = %inner.loop
  store i32 %b, i32* %a.ptr, align 4
  store i32 %a, i32* %b.ptr, align 4
  br label %inner.after.swap

no.swap:                                           ; preds = %inner.loop
  br label %inner.after.swap

inner.after.swap:                                  ; preds = %no.swap, %do.swap
  %r10.update = phi i64 [ %rax.phi, %do.swap ], [ %r10.phi, %no.swap ]
  %rax.next = add i64 %rax.phi, 1
  %rdx.next = getelementptr inbounds i32, i32* %rdx.phi, i64 1
  %cont = icmp ne i64 %rax.next, %r9.phi
  br i1 %cont, label %inner.latch, label %inner.done

inner.latch:                                       ; preds = %inner.after.swap
  br label %inner.loop

inner.done:                                        ; preds = %inner.after.swap
  %r10.end = phi i64 [ %r10.update, %inner.after.swap ]
  %le = icmp ule i64 %r10.end, 1
  br i1 %le, label %after.sort, label %outer.cont

outer.cont:                                        ; preds = %inner.done
  %r9.next = phi i64 [ %r10.end, %inner.done ]
  br label %outer.loop

after.sort:                                        ; preds = %inner.done
  %end.ptr = getelementptr inbounds i32, i32* %base, i64 10
  br label %print.loop

print.loop:                                        ; preds = %after.sort, %print.loop
  %ptr.phi = phi i32* [ %base, %after.sort ], [ %ptr.next, %print.loop ]
  %val = load i32, i32* %ptr.phi, align 4
  call void @sub_1400025A0(i8* @unk_140004000, i32 %val)
  %ptr.next = getelementptr inbounds i32, i32* %ptr.phi, i64 1
  %more = icmp ne i32* %ptr.next, %end.ptr
  br i1 %more, label %print.loop, label %print.done

print.done:                                        ; preds = %print.loop
  call void @loc_140002730(i32 10)
  ret i32 0
}