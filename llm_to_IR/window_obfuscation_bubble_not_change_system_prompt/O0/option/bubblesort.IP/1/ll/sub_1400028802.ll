; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@xmmword_140004010 = external global <4 x i32>, align 16
@xmmword_140004020 = external global <4 x i32>, align 16
@unk_140004000 = external global i8, align 1

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)
declare void @loc_140002730(i32)

define i32 @sub_140002880() {
entry:
  call void @sub_140001520()
  %arr = alloca [10 x i32], align 16
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_140004010, align 16
  %arr0p = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %e0 = extractelement <4 x i32> %v0, i32 0
  store i32 %e0, i32* %arr0p, align 4
  %p1 = getelementptr inbounds i32, i32* %arr0p, i64 1
  %e1 = extractelement <4 x i32> %v0, i32 1
  store i32 %e1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr0p, i64 2
  %e2 = extractelement <4 x i32> %v0, i32 2
  store i32 %e2, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr0p, i64 3
  %e3 = extractelement <4 x i32> %v0, i32 3
  store i32 %e3, i32* %p3, align 4
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_140004020, align 16
  %p4 = getelementptr inbounds i32, i32* %arr0p, i64 4
  %f0 = extractelement <4 x i32> %v1, i32 0
  store i32 %f0, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr0p, i64 5
  %f1 = extractelement <4 x i32> %v1, i32 1
  store i32 %f1, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr0p, i64 6
  %f2 = extractelement <4 x i32> %v1, i32 2
  store i32 %f2, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr0p, i64 7
  %f3 = extractelement <4 x i32> %v1, i32 3
  store i32 %f3, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr0p, i64 8
  store i32 4, i32* %p8, align 4
  br label %outer_loophead

outer_loophead:
  %limit = phi i64 [ 10, %entry ], [ %final_lastswap, %after_inner ]
  %base_i8 = bitcast [10 x i32]* %arr to i8*
  br label %inner_loop

inner_loop:
  %idx = phi i64 [ 1, %outer_loophead ], [ %idx_next, %inner_continue ]
  %rdx_ptr = phi i8* [ %base_i8, %outer_loophead ], [ %rdx_next, %inner_continue ]
  %lastswap = phi i64 [ 0, %outer_loophead ], [ %lastswap_update, %inner_continue ]
  %pcur = bitcast i8* %rdx_ptr to i32*
  %a0 = load i32, i32* %pcur, align 4
  %nextptr_i8 = getelementptr inbounds i8, i8* %rdx_ptr, i64 4
  %pnext = bitcast i8* %nextptr_i8 to i32*
  %a1 = load i32, i32* %pnext, align 4
  %cond = icmp slt i32 %a1, %a0
  br i1 %cond, label %do_swap, label %no_swap

do_swap:
  store i32 %a1, i32* %pcur, align 4
  store i32 %a0, i32* %pnext, align 4
  br label %inner_continue

no_swap:
  br label %inner_continue

inner_continue:
  %lastswap_update = phi i64 [ %idx, %do_swap ], [ %lastswap, %no_swap ]
  %idx_next = add i64 %idx, 1
  %rdx_next = getelementptr inbounds i8, i8* %rdx_ptr, i64 4
  %cont = icmp ne i64 %idx_next, %limit
  br i1 %cont, label %inner_loop, label %after_inner

after_inner:
  %final_lastswap = phi i64 [ %lastswap_update, %inner_continue ]
  %check = icmp ugt i64 %final_lastswap, 1
  br i1 %check, label %outer_loophead, label %print_init

print_init:
  %base_print = bitcast [10 x i32]* %arr to i8*
  %end_ptr = getelementptr inbounds i8, i8* %base_print, i64 40
  br label %print_loop

print_loop:
  %cur = phi i8* [ %base_print, %print_init ], [ %next, %after_call ]
  %cur_i32 = bitcast i8* %cur to i32*
  %val = load i32, i32* %cur_i32, align 4
  call void @sub_1400025A0(i8* @unk_140004000, i32 %val)
  %next = getelementptr inbounds i8, i8* %cur, i64 4
  %cmp_end = icmp ne i8* %end_ptr, %next
  br i1 %cmp_end, label %after_call, label %after_print

after_call:
  br label %print_loop

after_print:
  call void @loc_140002730(i32 10)
  ret i32 0
}