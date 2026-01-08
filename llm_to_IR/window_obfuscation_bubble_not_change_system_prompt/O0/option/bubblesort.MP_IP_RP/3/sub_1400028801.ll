; ModuleID = 'sub_140002880'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140001520()
declare void @sub_1400025A0(i8*, i32)

@xmmword_140004010 = external global [4 x i32], align 16
@xmmword_140004020 = external global [4 x i32], align 16
@unk_140004000 = external global i8, align 1

define void @sub_140002880() {
entry:
  call void @sub_140001520()
  %arr = alloca [10 x i32], align 16
  %g1e0 = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_140004010, i64 0, i64 0
  %g1v0 = load i32, i32* %g1e0, align 4
  %a0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 %g1v0, i32* %a0, align 4
  %g1e1 = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_140004010, i64 0, i64 1
  %g1v1 = load i32, i32* %g1e1, align 4
  %a1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 %g1v1, i32* %a1, align 4
  %g1e2 = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_140004010, i64 0, i64 2
  %g1v2 = load i32, i32* %g1e2, align 4
  %a2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 %g1v2, i32* %a2, align 4
  %g1e3 = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_140004010, i64 0, i64 3
  %g1v3 = load i32, i32* %g1e3, align 4
  %a3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 %g1v3, i32* %a3, align 4
  %g2e0 = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_140004020, i64 0, i64 0
  %g2v0 = load i32, i32* %g2e0, align 4
  %a4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 %g2v0, i32* %a4, align 4
  %g2e1 = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_140004020, i64 0, i64 1
  %g2v1 = load i32, i32* %g2e1, align 4
  %a5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 %g2v1, i32* %a5, align 4
  %g2e2 = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_140004020, i64 0, i64 2
  %g2v2 = load i32, i32* %g2e2, align 4
  %a6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 %g2v2, i32* %a6, align 4
  %g2e3 = getelementptr inbounds [4 x i32], [4 x i32]* @xmmword_140004020, i64 0, i64 3
  %g2v3 = load i32, i32* %g2e3, align 4
  %a7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 %g2v3, i32* %a7, align 4
  %a8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %a8, align 4
  br label %outer_loop

outer_loop:
  %bound = phi i64 [ 10, %entry ], [ %lastswap_end, %outer_continue ]
  br label %inner_loop

inner_loop:
  %i = phi i64 [ 1, %outer_loop ], [ %i_next, %after_compare ]
  %idx = phi i64 [ 0, %outer_loop ], [ %idx_next, %after_compare ]
  %lastswap = phi i64 [ 0, %outer_loop ], [ %lastswap_next, %after_compare ]
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idx
  %v0 = load i32, i32* %p0, align 4
  %idx1 = add i64 %idx, 1
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idx1
  %v1 = load i32, i32* %p1, align 4
  %cmp = icmp slt i32 %v1, %v0
  br i1 %cmp, label %swap, label %noswap

swap:
  store i32 %v1, i32* %p0, align 4
  store i32 %v0, i32* %p1, align 4
  br label %after_compare

noswap:
  br label %after_compare

after_compare:
  %lastswap_next = phi i64 [ %i, %swap ], [ %lastswap, %noswap ]
  %i_next = add i64 %i, 1
  %idx_next = add i64 %idx, 1
  %cont = icmp ne i64 %i_next, %bound
  br i1 %cont, label %inner_loop, label %after_inner

after_inner:
  %lastswap_end = phi i64 [ %lastswap_next, %after_compare ]
  %done = icmp ule i64 %lastswap_end, 1
  br i1 %done, label %final, label %outer_continue

outer_continue:
  br label %outer_loop

final:
  %fp = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %fval = load i32, i32* %fp, align 4
  call void @sub_1400025A0(i8* @unk_140004000, i32 %fval)
  ret void
}