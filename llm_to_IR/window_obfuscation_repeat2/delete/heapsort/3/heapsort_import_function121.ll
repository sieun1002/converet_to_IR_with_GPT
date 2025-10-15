; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070E0 = external global i8*
@dword_1400070E8 = external global i32
@unk_140007100 = external global i8

declare void @sub_140002240()
declare void @sub_1400024E0()
declare void @sub_140002BB0(i8*)
declare void @sub_1403DDA29(i8*)
declare i32 @sub_1400E06D5(i8*)

define i32 @sub_1400023D0(i8* %rcx, i32 %edx, i8* %r8) {
entry:
  %cmp_eq2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq2, label %L498, label %Lnot2

Lnot2:                                           ; edx != 2
  %cmp_ugt2 = icmp ugt i32 %edx, 2
  br i1 %cmp_ugt2, label %L408, label %Lle2

Lle2:                                            ; edx <= 2
  %is_zero = icmp eq i32 %edx, 0
  br i1 %is_zero, label %L420, label %Lcase1

Lcase1:                                          ; edx == 1
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %flag1_zero = icmp eq i32 %flag1, 0
  br i1 %flag1_zero, label %L4C0, label %Lset1

Lset1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %Lret1

L408:                                            ; edx > 2
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %L408_is3, label %Lret1

L408_is3:                                        ; edx == 3
  %flag2 = load i32, i32* @dword_1400070E8, align 4
  %flag2_zero = icmp eq i32 %flag2, 0
  br i1 %flag2_zero, label %Lret1, label %Lcall240_then420

Lcall240_then420:
  call void @sub_140002240()
  br label %L420

L420:                                            ; common detach handling
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %flag3_nonzero = icmp ne i32 %flag3, 0
  br i1 %flag3_nonzero, label %L4B0, label %L42E

L42E:
  %flag4 = load i32, i32* @dword_1400070E8, align 4
  %is_one = icmp eq i32 %flag4, 1
  br i1 %is_one, label %L439, label %Lret1

L439:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %L46B, label %L450

L450:
  %cur = phi i8* [ %head, %L439 ], [ %next, %LafterCall ]
  %next_addr = getelementptr i8, i8* %cur, i64 16
  %next_ptrptr = bitcast i8* %next_addr to i8**
  %next = load i8*, i8** %next_ptrptr, align 8
  call void @sub_140002BB0(i8* %cur)
  %next_is_null = icmp eq i8* %next, null
  br i1 %next_is_null, label %L46B, label %LafterCall

LafterCall:
  br label %L450

L46B:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @sub_1403DDA29(i8* @unk_140007100)
  br label %Lret1

L4B0:
  call void @sub_140002240()
  br label %L4C0

L4C0:
  %ret_eax = call i32 @sub_1400E06D5(i8* @unk_140007100)
  %sum = add i32 %ret_eax, 57367
  %sum64 = zext i32 %sum to i64
  %addr = sub i64 %sum64, 1879047792
  %ptrptr = inttoptr i64 %addr to i8**
  %fnp_i8 = load i8*, i8** %ptrptr, align 8
  %fnp = bitcast i8* %fnp_i8 to void ()*
  call void %fnp()
  unreachable

L498:
  call void @sub_1400024E0()
  br label %Lret1

Lret1:
  ret i32 1
}