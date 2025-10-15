; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare void @sub_140002240()
declare void @sub_140002BB0(i8*)
declare void @sub_1403DDA29(i8*)
declare void @sub_1400024E0()
declare i32 @sub_1400E06D5(i8*)

@qword_1400070E0 = external global i8*
@dword_1400070E8 = external global i32
@unk_140007100 = external global i8

define i32 @sub_1400023D0(i8* %rcx, i32 %edx) {
entry:
  %var10 = alloca i8*, align 8
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %loc_2498, label %check_gt2

check_gt2:
  %gt2 = icmp ugt i32 %edx, 2
  br i1 %gt2, label %loc_2408, label %edx_le2

edx_le2:
  %isZero = icmp eq i32 %edx, 0
  br i1 %isZero, label %loc_2420, label %edx_is1

edx_is1:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1_zero = icmp eq i32 %g1, 0
  br i1 %g1_zero, label %loc_24C0, label %set_flag_and_ret

set_flag_and_ret:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

loc_2408:
  %eq3 = icmp eq i32 %edx, 3
  br i1 %eq3, label %edx_is3, label %ret1

edx_is3:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %g2_zero = icmp eq i32 %g2, 0
  br i1 %g2_zero, label %ret1, label %call_2240_then_2420

call_2240_then_2420:
  call void @sub_140002240()
  br label %loc_2420

loc_2420:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3_nz = icmp ne i32 %g3, 0
  br i1 %g3_nz, label %loc_24B0, label %loc_242E

loc_242E:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %g4_is1 = icmp eq i32 %g4, 1
  br i1 %g4_is1, label %loc_2439, label %ret1

loc_2439:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_iszero = icmp eq i8* %head, null
  br i1 %head_iszero, label %loc_146B, label %loc_1450

loc_1450:
  br label %loop

loop:
  %phi_curr = phi i8* [ %head, %loc_1450 ], [ %reloaded, %after_call ]
  %curr_plus16 = getelementptr i8, i8* %phi_curr, i64 16
  %curr_plus16_as_ptrptr = bitcast i8* %curr_plus16 to i8**
  %next = load i8*, i8** %curr_plus16_as_ptrptr, align 8
  store i8* %next, i8** %var10, align 8
  call void @sub_140002BB0(i8* %phi_curr)
  %reloaded = load i8*, i8** %var10, align 8
  %hasnext = icmp ne i8* %reloaded, null
  br i1 %hasnext, label %after_call, label %loc_146B

after_call:
  br label %loop

loc_146B:
  %rcx_unk = getelementptr i8, i8* @unk_140007100, i64 0
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @sub_1403DDA29(i8* %rcx_unk)
  br label %ret1

loc_2498:
  call void @sub_1400024E0()
  br label %ret1

loc_24B0:
  call void @sub_140002240()
  br label %loc_24C0

loc_24C0:
  %rcx_unk2 = getelementptr i8, i8* @unk_140007100, i64 0
  %eax0 = call i32 @sub_1400E06D5(i8* %rcx_unk2)
  %eax_sub = add i32 %eax0, 57367
  %rax64 = zext i32 %eax_sub to i64
  %addr = sub i64 %rax64, 1869574000
  %ptr = inttoptr i64 %addr to i8**
  %callee = load i8*, i8** %ptr, align 8
  %callee_fn = bitcast i8* %callee to void ()*
  call void %callee_fn()
  unreachable

ret1:
  ret i32 1
}