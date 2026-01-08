; ModuleID = 'sub_140002880_module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140001520()

declare i32 @sub_1400025A0(i8*, i32)

declare void @loc_14000272D(i32)

@xmmword_140004010 = external global <4 x i32>
@xmmword_140004020 = external global <4 x i32>
@unk_140004000 = external global i8

define i32 @sub_140002880() {
entry:
  %arr = alloca [11 x i32], align 16
  call void @sub_140001520()
  %base.ptr = getelementptr inbounds [11 x i32], [11 x i32]* %arr, i64 0, i64 0
  %base.vec.ptr = bitcast i32* %base.ptr to <4 x i32>*
  %g1 = load <4 x i32>, <4 x i32>* @xmmword_140004010, align 1
  store <4 x i32> %g1, <4 x i32>* %base.vec.ptr, align 1
  %base.i8 = bitcast i32* %base.ptr to i8*
  %off16 = getelementptr inbounds i8, i8* %base.i8, i64 16
  %base2.vec.ptr = bitcast i8* %off16 to <4 x i32>*
  %g2 = load <4 x i32>, <4 x i32>* @xmmword_140004020, align 1
  store <4 x i32> %g2, <4 x i32>* %base2.vec.ptr, align 1
  %elem8.ptr = getelementptr inbounds [11 x i32], [11 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %elem8.ptr, align 4
  br label %outer

outer:
  %limit = phi i64 [ 10, %entry ], [ %r10.val, %cont_outer ]
  %i.start = add i64 0, 1
  %lastswap.start = add i64 0, 0
  br label %inner

inner:
  %i.phi = phi i64 [ %i.start, %outer ], [ %i.next, %after ]
  %rdx.phi.i8 = phi i8* [ %base.i8, %outer ], [ %rdx.next, %after ]
  %lastswap.phi = phi i64 [ %lastswap.start, %outer ], [ %last.next, %after ]
  %a.ptr = bitcast i8* %rdx.phi.i8 to i32*
  %a.val = load i32, i32* %a.ptr, align 4
  %b.ptr.i8 = getelementptr inbounds i8, i8* %rdx.phi.i8, i64 4
  %b.ptr = bitcast i8* %b.ptr.i8 to i32*
  %b.val = load i32, i32* %b.ptr, align 4
  %cmp.swap = icmp slt i32 %b.val, %a.val
  br i1 %cmp.swap, label %swap, label %noswap

swap:
  store i32 %b.val, i32* %a.ptr, align 4
  store i32 %a.val, i32* %b.ptr, align 4
  br label %after

noswap:
  br label %after

after:
  %last.next = phi i64 [ %i.phi, %swap ], [ %lastswap.phi, %noswap ]
  %i.next = add i64 %i.phi, 1
  %rdx.next = getelementptr inbounds i8, i8* %rdx.phi.i8, i64 4
  %cont = icmp ne i64 %i.next, %limit
  br i1 %cont, label %inner, label %post_inner

post_inner:
  %cont.more = icmp ugt i64 %last.next, 1
  br i1 %cont.more, label %cont_outer, label %print_prep

cont_outer:
  %r10.val = add i64 %last.next, 0
  br label %outer

print_prep:
  %end.ptr.i32 = getelementptr inbounds [11 x i32], [11 x i32]* %arr, i64 0, i64 10
  %end.ptr.i8 = bitcast i32* %end.ptr.i32 to i8*
  br label %print

print:
  %rbx.phi = phi i8* [ %base.i8, %print_prep ], [ %rbx.next, %print ]
  %val.ptr = bitcast i8* %rbx.phi to i32*
  %val.load = load i32, i32* %val.ptr, align 4
  %fmt.ptr = getelementptr inbounds i8, i8* @unk_140004000, i64 0
  %call.print = call i32 @sub_1400025A0(i8* %fmt.ptr, i32 %val.load)
  %rbx.next = getelementptr inbounds i8, i8* %rbx.phi, i64 4
  %cmp.end = icmp ne i8* %rbx.next, %end.ptr.i8
  br i1 %cmp.end, label %print, label %after_print

after_print:
  %fp.int = ptrtoint void (i32)* @loc_14000272D to i64
  %fp.plus = add i64 %fp.int, 3
  %fp.cast = inttoptr i64 %fp.plus to void (i32)*
  call void %fp.cast(i32 10)
  ret i32 0
}