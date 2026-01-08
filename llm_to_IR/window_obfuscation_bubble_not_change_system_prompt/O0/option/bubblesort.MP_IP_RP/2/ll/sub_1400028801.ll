target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external dso_local global [16 x i8], align 16
@xmmword_140004020 = external dso_local global [16 x i8], align 16
@unk_140004000 = external dso_local global i8, align 1

declare dso_local void @sub_140001520()
declare dso_local void @sub_1400025A0(i8*, i32)

define dso_local void @sub_140002880() {
entry:
  %arr = alloca [10 x i32], align 16
  call void @sub_140001520()

  ; copy 16 bytes from xmmword_140004010 into arr[0..3]
  %g1_i32ptr = bitcast [16 x i8]* @xmmword_140004010 to i32*
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  %g1p0 = getelementptr inbounds i32, i32* %g1_i32ptr, i64 0
  %g1v0 = load i32, i32* %g1p0, align 1
  store i32 %g1v0, i32* %arr0, align 4
  %g1p1 = getelementptr inbounds i32, i32* %g1_i32ptr, i64 1
  %g1v1 = load i32, i32* %g1p1, align 1
  store i32 %g1v1, i32* %arr1, align 4
  %g1p2 = getelementptr inbounds i32, i32* %g1_i32ptr, i64 2
  %g1v2 = load i32, i32* %g1p2, align 1
  store i32 %g1v2, i32* %arr2, align 4
  %g1p3 = getelementptr inbounds i32, i32* %g1_i32ptr, i64 3
  %g1v3 = load i32, i32* %g1p3, align 1
  store i32 %g1v3, i32* %arr3, align 4

  ; r9d = 0xA
  br label %copy2

copy2:
  ; copy 16 bytes from xmmword_140004020 into arr[4..7]
  %g2_i32ptr = bitcast [16 x i8]* @xmmword_140004020 to i32*
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  %g2p0 = getelementptr inbounds i32, i32* %g2_i32ptr, i64 0
  %g2v0 = load i32, i32* %g2p0, align 1
  store i32 %g2v0, i32* %arr4, align 4
  %g2p1 = getelementptr inbounds i32, i32* %g2_i32ptr, i64 1
  %g2v1 = load i32, i32* %g2p1, align 1
  store i32 %g2v1, i32* %arr5, align 4
  %g2p2 = getelementptr inbounds i32, i32* %g2_i32ptr, i64 2
  %g2v2 = load i32, i32* %g2p2, align 1
  store i32 %g2v2, i32* %arr6, align 4
  %g2p3 = getelementptr inbounds i32, i32* %g2_i32ptr, i64 3
  %g2v3 = load i32, i32* %g2p3, align 1
  store i32 %g2v3, i32* %arr7, align 4

  ; arr[8] = 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 4

  br label %outer_header

outer_header:
  %bound = phi i64 [ 10, %copy2 ], [ %new_bound, %outer_continue ]
  %base_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  br label %inner_body

inner_body:
  %idx = phi i64 [ 1, %outer_header ], [ %idx_next, %cont ]
  %cur_ptr = phi i32* [ %base_ptr, %outer_header ], [ %ptr_next2, %cont ]
  %lastswap = phi i64 [ 0, %outer_header ], [ %lastswap2, %cont ]
  %v0 = load i32, i32* %cur_ptr, align 4
  %ptr_next = getelementptr inbounds i32, i32* %cur_ptr, i64 1
  %v1 = load i32, i32* %ptr_next, align 4
  %cmp_ge = icmp sge i32 %v1, %v0
  br i1 %cmp_ge, label %no_swap, label %do_swap

do_swap:
  store i32 %v1, i32* %cur_ptr, align 4
  store i32 %v0, i32* %ptr_next, align 4
  br label %cont_swap

no_swap:
  br label %cont_noswap

cont_swap:
  br label %cont

cont_noswap:
  br label %cont

cont:
  %lastswap2 = phi i64 [ %idx, %cont_swap ], [ %lastswap, %cont_noswap ]
  %idx_next = add i64 %idx, 1
  %ptr_next2 = getelementptr inbounds i32, i32* %cur_ptr, i64 1
  %cont_cmp = icmp ne i64 %idx_next, %bound
  br i1 %cont_cmp, label %inner_body, label %after_inner

after_inner:
  %gt1 = icmp ugt i64 %lastswap2, 1
  br i1 %gt1, label %outer_continue, label %final

outer_continue:
  %new_bound = phi i64 [ %lastswap2, %after_inner ]
  br label %outer_header

final:
  %last_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  %first_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %first_val = load i32, i32* %first_ptr, align 4
  %fmt_ptr = getelementptr inbounds i8, i8* @unk_140004000, i64 0
  call void @sub_1400025A0(i8* %fmt_ptr, i32 %first_val)
  ret void
}