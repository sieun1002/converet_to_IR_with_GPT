; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global <4 x i32>, align 16
@xmmword_140004020 = external global <4 x i32>, align 16
@unk_140004000 = external global i8

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)
declare void @sub_140002730(i32)

define i32 @sub_140002880() {
entry:
  %arr = alloca [10 x i32], align 16
  %base_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @sub_140001520()
  %vec1 = load <4 x i32>, <4 x i32>* @xmmword_140004010, align 16
  %vecptr0 = bitcast i32* %base_ptr to <4 x i32>*
  store <4 x i32> %vec1, <4 x i32>* %vecptr0, align 4
  %ptr4 = getelementptr inbounds i32, i32* %base_ptr, i64 4
  %vecptr1 = bitcast i32* %ptr4 to <4 x i32>*
  %vec2 = load <4 x i32>, <4 x i32>* @xmmword_140004020, align 16
  store <4 x i32> %vec2, <4 x i32>* %vecptr1, align 4
  %idx8 = getelementptr inbounds i32, i32* %base_ptr, i64 8
  store i32 4, i32* %idx8, align 4
  br label %outer.loop

outer.loop:
  %n.cur = phi i64 [ 10, %entry ], [ %lastswap.final, %outer.after ]
  br label %inner.loop

inner.loop:
  %i = phi i64 [ 1, %outer.loop ], [ %i.next, %inner.inc ]
  %p = phi i32* [ %base_ptr, %outer.loop ], [ %p.next, %inner.inc ]
  %lastswap = phi i64 [ 0, %outer.loop ], [ %lastswap.new, %inner.inc ]
  %v0 = load i32, i32* %p, align 4
  %p.plus1 = getelementptr inbounds i32, i32* %p, i64 1
  %v1 = load i32, i32* %p.plus1, align 4
  %cmp = icmp sge i32 %v1, %v0
  br i1 %cmp, label %no.swap, label %do.swap

do.swap:
  store i32 %v1, i32* %p, align 4
  store i32 %v0, i32* %p.plus1, align 4
  br label %inner.inc

no.swap:
  br label %inner.inc

inner.inc:
  %lastswap.new = phi i64 [ %i, %do.swap ], [ %lastswap, %no.swap ]
  %i.next = add i64 %i, 1
  %p.next = getelementptr inbounds i32, i32* %p, i64 1
  %continue = icmp ne i64 %i.next, %n.cur
  br i1 %continue, label %inner.loop, label %outer.after

outer.after:
  %lastswap.final = phi i64 [ %lastswap.new, %inner.inc ]
  %check = icmp ugt i64 %lastswap.final, 1
  br i1 %check, label %outer.loop, label %printing_prep

printing_prep:
  %end.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 10
  br label %print.loop

print.loop:
  %cur = phi i32* [ %base_ptr, %printing_prep ], [ %cur.next, %print.cont ]
  %val = load i32, i32* %cur, align 4
  call void @sub_1400025A0(i8* @unk_140004000, i32 %val)
  %cur.next = getelementptr inbounds i32, i32* %cur, i64 1
  %cont = icmp ne i32* %cur.next, %end.ptr
  br i1 %cont, label %print.cont, label %print.done

print.cont:
  br label %print.loop

print.done:
  call void @sub_140002730(i32 10)
  ret i32 0
}