; ModuleID = 'm'
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_140002B68(i32 %ecx, i32 %edx)
declare void @sub_1400024E0()

@qword_1400070D0 = external global i32 (i8**)*

define i32 @sub_140002080(i8** %rcx) {
entry:
  %p = load i8*, i8** %rcx, align 8
  %p_i32 = bitcast i8* %p to i32*
  %code = load i32, i32* %p_i32, align 1
  %masked = and i32 %code, 553648127
  %cmpmask = icmp eq i32 %masked, 541541187
  %p_plus4 = getelementptr i8, i8* %p, i64 4
  %b4 = load i8, i8* %p_plus4, align 1
  %bit1 = and i8 %b4, 1
  %flag_nonzero = icmp ne i8 %bit1, 0
  %not_sig = xor i1 %cmpmask, true
  %proceed = or i1 %not_sig, %flag_nonzero
  br i1 %proceed, label %process, label %ret_default

process:                                          ; corresponds to loc_1400020A1 onwards
  %cmp_hi = icmp ugt i32 %code, 3221225622
  br i1 %cmp_hi, label %fallback, label %check_low

check_low:
  %cmp_le_8B = icmp ule i32 %code, 3221225611
  br i1 %cmp_le_8B, label %handle_110, label %switch_prep

switch_prep:
  %idx = add i32 %code, 1073741683
  %idx_gt9 = icmp ugt i32 %idx, 9
  br i1 %idx_gt9, label %ret_default, label %sw

sw:
  switch i32 %idx, label %ret_default [
    i32 0, label %handle_d0
    i32 1, label %handle_d0
    i32 2, label %handle_d0
    i32 3, label %handle_d0
    i32 4, label %handle_d0
    i32 5, label %ret_default
    i32 6, label %handle_d0
    i32 7, label %handle_190
    i32 8, label %ret_default
    i32 9, label %handle_d0
  ]

handle_d0:                                        ; loc_1400020D0 group
  %r_d0 = call i64 @sub_140002B68(i32 8, i32 0)
  %is_one_d0 = icmp eq i64 %r_d0, 1
  br i1 %is_one_d0, label %case_2224, label %d0_check_zero

d0_check_zero:
  %is_zero_d0 = icmp eq i64 %r_d0, 0
  br i1 %is_zero_d0, label %fallback, label %call_ptr_8

handle_190:                                       ; loc_140002190 case 0xC0000094
  %r_190 = call i64 @sub_140002B68(i32 8, i32 0)
  %is_one_190 = icmp eq i64 %r_190, 1
  br i1 %is_one_190, label %case_190_second, label %h190_check_zero

h190_check_zero:
  %is_zero_190 = icmp eq i64 %r_190, 0
  br i1 %is_zero_190, label %fallback, label %call_ptr_8

case_190_second:
  %r_190b = call i64 @sub_140002B68(i32 8, i32 1)
  br label %ret_default

case_2224:                                        ; loc_140002224
  %r_2224a = call i64 @sub_140002B68(i32 8, i32 1)
  call void @sub_1400024E0()
  br label %ret_default

call_ptr_8:                                       ; loc_1400021F0
  %fp8 = inttoptr i64 %r_d0 to void (i32)*
  call void %fp8(i32 8)
  br label %ret_default

handle_110:                                       ; loc_140002110 region
  %is_av = icmp eq i32 %code, 3221225477
  br i1 %is_av, label %handle_1C0, label %check_gt_5

check_gt_5:
  %ugt_5 = icmp ugt i32 %code, 3221225477
  br i1 %ugt_5, label %loc_150, label %check_80000002

check_80000002:
  %is_80000002 = icmp eq i32 %code, 2147483650
  br i1 %is_80000002, label %ret_default, label %fallback

loc_150:                                          ; loc_140002150
  %is_0008 = icmp eq i32 %code, 3221225480
  br i1 %is_0008, label %ret_default, label %check_001D

check_001D:
  %is_001D = icmp eq i32 %code, 3221225501
  br i1 %is_001D, label %handle_15E, label %fallback

handle_15E:                                       ; loc_14000215E group (ecx=4)
  %r_15E = call i64 @sub_140002B68(i32 4, i32 0)
  %is_one_15E = icmp eq i64 %r_15E, 1
  br i1 %is_one_15E, label %case_210, label %h15E_check_zero

h15E_check_zero:
  %is_zero_15E = icmp eq i64 %r_15E, 0
  br i1 %is_zero_15E, label %fallback, label %call_ptr_4

case_210:                                         ; loc_140002210
  %r_210 = call i64 @sub_140002B68(i32 4, i32 1)
  br label %ret_default

call_ptr_4:
  %fp4 = inttoptr i64 %r_15E to void (i32)*
  call void %fp4(i32 4)
  br label %ret_default

handle_1C0:                                       ; loc_1400021C0 group (ecx=0xB)
  %r_1C0 = call i64 @sub_140002B68(i32 11, i32 0)
  %is_one_1C0 = icmp eq i64 %r_1C0, 1
  br i1 %is_one_1C0, label %case_1FC, label %h1C0_check_zero

h1C0_check_zero:
  %is_zero_1C0 = icmp eq i64 %r_1C0, 0
  br i1 %is_zero_1C0, label %fallback, label %call_ptr_B

case_1FC:                                         ; loc_1400021FC
  %r_1FC = call i64 @sub_140002B68(i32 11, i32 1)
  br label %ret_default

call_ptr_B:
  %fpB = inttoptr i64 %r_1C0 to void (i32)*
  call void %fpB(i32 11)
  br label %ret_default

fallback:                                         ; loc_1400020EF
  %g = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %g_null = icmp eq i32 (i8**)* %g, null
  br i1 %g_null, label %ret_zero, label %call_g

call_g:
  %ret_from_g = call i32 %g(i8** %rcx)
  ret i32 %ret_from_g

ret_zero:                                         ; loc_140002140
  ret i32 0

ret_default:                                      ; def_1400020C7
  ret i32 -1
}