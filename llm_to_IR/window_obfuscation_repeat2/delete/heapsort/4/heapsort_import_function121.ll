; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i64
@unk_140007100 = external global i8

declare void @sub_140002240()
declare void @sub_140002BB0(i8*)
declare void @sub_1403DDA29(i8*)
declare void @sub_1400024E0()
declare i32 @sub_1400E06D5(i8*)

define i32 @sub_1400023D0(i32 %arg0, i32 %arg1) {
entry:
  %cmp_edx_eq2 = icmp eq i32 %arg1, 2
  br i1 %cmp_edx_eq2, label %case2, label %not2

case2:                                            ; edx == 2
  call void @sub_1400024E0()
  br label %ret1

not2:
  %cmp_gt2 = icmp ugt i32 %arg1, 2
  br i1 %cmp_gt2, label %gt2, label %le2

gt2:                                              ; edx > 2
  %cmp_ne3 = icmp ne i32 %arg1, 3
  br i1 %cmp_ne3, label %ret1, label %eq3

eq3:                                              ; edx == 3
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %flag1_is_zero = icmp eq i32 %flag1, 0
  br i1 %flag1_is_zero, label %ret1, label %call2240_then_420

call2240_then_420:
  call void @sub_140002240()
  br label %loc_420

le2:                                              ; edx <= 2 and edx != 2
  %is_zero = icmp eq i32 %arg1, 0
  br i1 %is_zero, label %loc_420, label %edx_is1

edx_is1:                                          ; edx == 1
  %flag2 = load i32, i32* @dword_1400070E8, align 4
  %flag2_is_zero = icmp eq i32 %flag2, 0
  br i1 %flag2_is_zero, label %loc_4C0, label %setflag_ret

setflag_ret:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

loc_420:
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %flag3_nonzero = icmp ne i32 %flag3, 0
  br i1 %flag3_nonzero, label %loc_4B0, label %check_one

check_one:
  %flag4 = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %flag4, 1
  br i1 %is_one, label %cleanup_start, label %ret1

loc_4B0:
  call void @sub_140002240()
  br label %loc_4C0

cleanup_start:
  %head0 = load i64, i64* @qword_1400070E0, align 8
  br label %loop_cond

loop_cond:
  %head_cur = phi i64 [ %head0, %cleanup_start ], [ %next, %loop_body ]
  %is_null = icmp eq i64 %head_cur, 0
  br i1 %is_null, label %after_loop, label %loop_body

loop_body:
  %node_ptr2 = inttoptr i64 %head_cur to i8*
  %next_addr = getelementptr i8, i8* %node_ptr2, i64 16
  %next_i64ptr = bitcast i8* %next_addr to i64*
  %next = load i64, i64* %next_i64ptr, align 8
  call void @sub_140002BB0(i8* %node_ptr2)
  br label %loop_cond

after_loop:
  store i64 0, i64* @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @sub_1403DDA29(i8* @unk_140007100)
  br label %ret1

loc_4C0:
  %tret = call i32 @sub_1400E06D5(i8* @unk_140007100)
  %tadj = add i32 %tret, 57367
  %rax64 = zext i32 %tadj to i64
  %addr = sub i64 %rax64, 1879574000
  %ptrptr = inttoptr i64 %addr to i8**
  %callee_i8 = load i8*, i8** %ptrptr, align 8
  %callee = bitcast i8* %callee_i8 to void ()*
  call void %callee()
  br label %ret1

ret1:
  ret i32 1
}