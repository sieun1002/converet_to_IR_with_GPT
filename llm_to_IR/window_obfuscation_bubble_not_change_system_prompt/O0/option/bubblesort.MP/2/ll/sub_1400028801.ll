; ModuleID = 'sub_140002880'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external constant <4 x i32>, align 16
@xmmword_140004020 = external constant <4 x i32>, align 16
@unk_140004000 = external constant i8

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)
declare void @sub_140002730(i32)

define i32 @sub_140002880() {
entry:
  %arr = alloca [10 x i32], align 16
  call void @sub_140001520()
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_140004010, align 16
  %arr.vec0 = bitcast [10 x i32]* %arr to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %arr.vec0, align 16
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_140004020, align 16
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  %p4.vec = bitcast i32* %p4 to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %p4.vec, align 16
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 4
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %n64 = zext i32 10 to i64
  br label %outer.hdr

outer.hdr:
  %limit = phi i64 [ %n64, %entry ], [ %new.limit, %outer.repeat ]
  br label %inner.loop

inner.loop:
  %cur = phi i32* [ %base, %outer.hdr ], [ %cur.next, %after.cmp ]
  %i = phi i64 [ 1, %outer.hdr ], [ %i.next, %after.cmp ]
  %last = phi i64 [ 0, %outer.hdr ], [ %last.upd, %after.cmp ]
  %a = load i32, i32* %cur, align 4
  %cur.plus1 = getelementptr inbounds i32, i32* %cur, i64 1
  %b = load i32, i32* %cur.plus1, align 4
  %need.swap = icmp slt i32 %b, %a
  br i1 %need.swap, label %swap, label %noswap

swap:
  store i32 %b, i32* %cur, align 4
  store i32 %a, i32* %cur.plus1, align 4
  br label %after.cmp

noswap:
  br label %after.cmp

after.cmp:
  %last.upd = phi i64 [ %i, %swap ], [ %last, %noswap ]
  %i.next = add i64 %i, 1
  %cur.next = getelementptr inbounds i32, i32* %cur, i64 1
  %cont = icmp ne i64 %i.next, %limit
  br i1 %cont, label %inner.loop, label %after.inner

after.inner:
  %done = icmp ule i64 %last.upd, 1
  br i1 %done, label %print.setup, label %outer.repeat

outer.repeat:
  %new.limit = phi i64 [ %last.upd, %after.inner ]
  br label %outer.hdr

print.setup:
  %end = getelementptr inbounds i32, i32* %base, i64 10
  br label %print.loop

print.loop:
  %p = phi i32* [ %base, %print.setup ], [ %p.next, %print.loop ]
  %val = load i32, i32* %p, align 4
  call void @sub_1400025A0(i8* @unk_140004000, i32 %val)
  %p.next = getelementptr inbounds i32, i32* %p, i64 1
  %more = icmp ne i32* %p.next, %end
  br i1 %more, label %print.loop, label %after.print

after.print:
  call void @sub_140002730(i32 10)
  ret i32 0
}