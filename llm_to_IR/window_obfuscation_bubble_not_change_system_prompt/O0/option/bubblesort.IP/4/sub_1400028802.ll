; ModuleID = 'sub_140002880'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global <16 x i8>
@xmmword_140004020 = external global <16 x i8>
@unk_140004000 = external global i8

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)
declare void @loc_140002730(i32)

define i32 @sub_140002880() {
entry:
  %arr = alloca [10 x i32], align 16
  %base.i8 = bitcast [10 x i32]* %arr to i8*
  call void @sub_140001520()
  %g1 = load <16 x i8>, <16 x i8>* @xmmword_140004010, align 1
  %p0 = bitcast i8* %base.i8 to <16 x i8>*
  store <16 x i8> %g1, <16 x i8>* %p0, align 1
  %g2 = load <16 x i8>, <16 x i8>* @xmmword_140004020, align 1
  %base.plus16 = getelementptr i8, i8* %base.i8, i64 16
  %p16 = bitcast i8* %base.plus16 to <16 x i8>*
  store <16 x i8> %g2, <16 x i8>* %p16, align 1
  %idx8 = getelementptr [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %idx8, align 4
  br label %outer.init

outer.init:
  %limit = phi i64 [ 10, %entry ], [ %new.limit, %end.pass.more ]
  %ptr0 = phi i8* [ %base.i8, %entry ], [ %base.i8, %end.pass.more ]
  br label %inner

inner:
  %j = phi i64 [ 1, %outer.init ], [ %j.next, %after.swap ]
  %ptr = phi i8* [ %ptr0, %outer.init ], [ %ptr.next, %after.swap ]
  %swapped = phi i64 [ 0, %outer.init ], [ %swapped.next, %after.swap ]
  %ptr.i32 = bitcast i8* %ptr to i32*
  %a = load i32, i32* %ptr.i32, align 1
  %ptr.plus4 = getelementptr i8, i8* %ptr, i64 4
  %ptr.plus4.i32 = bitcast i8* %ptr.plus4 to i32*
  %b = load i32, i32* %ptr.plus4.i32, align 1
  %cmp.swap = icmp slt i32 %b, %a
  br i1 %cmp.swap, label %do.swap, label %no.swap

do.swap:
  store i32 %b, i32* %ptr.i32, align 1
  store i32 %a, i32* %ptr.plus4.i32, align 1
  br label %after.swap

no.swap:
  br label %after.swap

after.swap:
  %swapped.next = phi i64 [ %j, %do.swap ], [ %swapped, %no.swap ]
  %j.next = add i64 %j, 1
  %ptr.next = getelementptr i8, i8* %ptr, i64 4
  %cont = icmp ne i64 %j.next, %limit
  br i1 %cont, label %inner, label %end.pass

end.pass:
  %more = icmp ugt i64 %swapped.next, 1
  br i1 %more, label %end.pass.more, label %print.init

end.pass.more:
  %new.limit = phi i64 [ %swapped.next, %end.pass ]
  br label %outer.init

print.init:
  %cur0 = phi i8* [ %base.i8, %end.pass ]
  %end.ptr = getelementptr i8, i8* %base.i8, i64 40
  br label %print.loop

print.loop:
  %cur = phi i8* [ %cur0, %print.init ], [ %cur.next, %print.loop ]
  %cur.i32p = bitcast i8* %cur to i32*
  %val = load i32, i32* %cur.i32p, align 1
  %cur.next = getelementptr i8, i8* %cur, i64 4
  call void @sub_1400025A0(i8* @unk_140004000, i32 %val)
  %more.print = icmp ne i8* %cur.next, %end.ptr
  br i1 %more.print, label %print.loop, label %after.print

after.print:
  call void @loc_140002730(i32 10)
  ret i32 0
}