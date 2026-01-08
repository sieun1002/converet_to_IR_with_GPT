target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global <4 x i32>, align 16
@xmmword_140004020 = external global <4 x i32>, align 16
@unk_140004000 = external global i8, align 1

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)
declare void @sub_140002730(i32)

define i32 @sub_140002880() {
entry:
  call void @sub_140001520()
  %arr = alloca [10 x i32], align 4
  %base_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %vecptr0 = bitcast i32* %base_ptr to <4 x i32>*
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_140004010, align 1
  store <4 x i32> %v0, <4 x i32>* %vecptr0, align 1
  %p4 = getelementptr inbounds i32, i32* %base_ptr, i64 4
  %vecptr1 = bitcast i32* %p4 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_140004020, align 1
  store <4 x i32> %v1, <4 x i32>* %vecptr1, align 1
  %p8 = getelementptr inbounds i32, i32* %base_ptr, i64 8
  store i32 4, i32* %p8, align 4
  %limit.slot = alloca i64, align 8
  store i64 10, i64* %limit.slot, align 8
  %swap.slot = alloca i64, align 8
  br label %outer

outer:
  store i64 0, i64* %swap.slot, align 8
  %rdx.init = getelementptr inbounds i32, i32* %base_ptr, i64 0
  br label %inner

inner:
  %i.phi = phi i64 [ 1, %outer ], [ %i.next, %cont ]
  %ptr.phi = phi i32* [ %rdx.init, %outer ], [ %ptr.next2, %cont ]
  %a.load = load i32, i32* %ptr.phi, align 4
  %ptr.next = getelementptr inbounds i32, i32* %ptr.phi, i64 1
  %b.load = load i32, i32* %ptr.next, align 4
  %cmp.ge = icmp sge i32 %b.load, %a.load
  br i1 %cmp.ge, label %noswap, label %doswap

doswap:
  store i32 %b.load, i32* %ptr.phi, align 4
  store i32 %a.load, i32* %ptr.next, align 4
  store i64 %i.phi, i64* %swap.slot, align 8
  br label %cont

noswap:
  br label %cont

cont:
  %i.next = add i64 %i.phi, 1
  %ptr.next2 = getelementptr inbounds i32, i32* %ptr.phi, i64 1
  %limit.curr = load i64, i64* %limit.slot, align 8
  %cmp.ne = icmp ne i64 %i.next, %limit.curr
  br i1 %cmp.ne, label %inner, label %inner_done

inner_done:
  %lastswap.load = load i64, i64* %swap.slot, align 8
  %need.more = icmp ugt i64 %lastswap.load, 1
  br i1 %need.more, label %outer_update, label %after_sort

outer_update:
  store i64 %lastswap.load, i64* %limit.slot, align 8
  br label %outer

after_sort:
  %end.ptr = getelementptr inbounds i32, i32* %base_ptr, i64 10
  br label %print_loop

print_loop:
  %cur.ptr = phi i32* [ %base_ptr, %after_sort ], [ %next.ptr3, %print_body ]
  %val.load = load i32, i32* %cur.ptr, align 4
  call void @sub_1400025A0(i8* @unk_140004000, i32 %val.load)
  %next.ptr3 = getelementptr inbounds i32, i32* %cur.ptr, i64 1
  %cmp.end = icmp ne i32* %next.ptr3, %end.ptr
  br i1 %cmp.end, label %print_body, label %after_print

print_body:
  br label %print_loop

after_print:
  call void @sub_140002730(i32 10)
  ret i32 0
}