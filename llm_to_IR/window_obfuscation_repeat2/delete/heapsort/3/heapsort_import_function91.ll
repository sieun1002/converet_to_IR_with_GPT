; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i32 (i8*)*

declare i8* @sub_140002B68(i32, i32)
declare void @sub_1400024E0()

define dso_local i32 @sub_140002080(i8** %rcx) local_unnamed_addr {
entry:
  %rdx = load i8*, i8** %rcx, align 8
  %rdx_i32ptr = bitcast i8* %rdx to i32*
  %eax0 = load i32, i32* %rdx_i32ptr, align 4
  %and = and i32 %eax0, 553648127
  %cmp_sig = icmp eq i32 %and, 541543875
  br i1 %cmp_sig, label %check_hdr, label %sw_entry

check_hdr:                                        ; preds = %entry
  %rdx_plus4 = getelementptr i8, i8* %rdx, i64 4
  %b = load i8, i8* %rdx_plus4, align 1
  %b1 = and i8 %b, 1
  %bit_set = icmp ne i8 %b1, 0
  br i1 %bit_set, label %sw_entry, label %ret_m1

sw_entry:                                         ; preds = %check_hdr, %entry
  %cmp_ja = icmp ugt i32 %eax0, 3221225622
  br i1 %cmp_ja, label %loc_0EF, label %cmp_range

cmp_range:                                        ; preds = %sw_entry
  %cmp_jbe = icmp ule i32 %eax0, 3221225611
  br i1 %cmp_jbe, label %loc_110, label %switch_cases

loc_110:                                          ; preds = %cmp_range
  %is_c0000005 = icmp eq i32 %eax0, 3221225477
  br i1 %is_c0000005, label %loc_1C0, label %loc_110_gt

loc_110_gt:                                       ; preds = %loc_110
  %gt_c0000005 = icmp ugt i32 %eax0, 3221225477
  br i1 %gt_c0000005, label %loc_150, label %loc_110_else

loc_110_else:                                     ; preds = %loc_110_gt
  %is_80000002 = icmp eq i32 %eax0, 2147483650
  br i1 %is_80000002, label %ret_m1, label %loc_0EF

loc_150:                                          ; preds = %loc_110_gt
  %is_c0000008 = icmp eq i32 %eax0, 3221225480
  br i1 %is_c0000008, label %ret_m1, label %loc_150_next

loc_150_next:                                     ; preds = %loc_150
  %is_c000001d = icmp eq i32 %eax0, 3221225501
  br i1 %is_c000001d, label %loc_15E, label %loc_0EF

switch_cases:                                     ; preds = %cmp_range
  %case_1676 = icmp eq i32 %eax0, -1073741676
  br i1 %case_1676, label %loc_190, label %sc_check2

sc_check2:                                        ; preds = %switch_cases
  %case_1674 = icmp eq i32 %eax0, -1073741674
  br i1 %case_1674, label %loc_15E, label %sc_check3

sc_check3:                                        ; preds = %sc_check2
  %ge_low = icmp sge i32 %eax0, -1073741683
  %le_high = icmp sle i32 %eax0, -1073741679
  %in_range = and i1 %ge_low, %le_high
  br i1 %in_range, label %loc_0D0, label %sc_check4

sc_check4:                                        ; preds = %sc_check3
  %is_1677 = icmp eq i32 %eax0, -1073741677
  br i1 %is_1677, label %loc_0D0, label %ret_m1

loc_0D0:                                          ; preds = %sc_check4, %sc_check3
  %call_d0 = call i8* @sub_140002B68(i32 8, i32 0)
  %call_d0_int = ptrtoint i8* %call_d0 to i64
  %is_one_d0 = icmp eq i64 %call_d0_int, 1
  br i1 %is_one_d0, label %loc_224, label %d0_test

d0_test:                                          ; preds = %loc_0D0
  %is_nonzero_d0 = icmp ne i8* %call_d0, null
  br i1 %is_nonzero_d0, label %loc_1F0, label %loc_0EF

loc_190:                                          ; preds = %switch_cases
  %call_190 = call i8* @sub_140002B68(i32 8, i32 0)
  %call_190_int = ptrtoint i8* %call_190 to i64
  %is_one_190 = icmp eq i64 %call_190_int, 1
  br i1 %is_one_190, label %loc_1A6, label %loc_0E6

loc_0E6:                                          ; preds = %loc_190
  %is_nonzero_190 = icmp ne i8* %call_190, null
  br i1 %is_nonzero_190, label %loc_1F0_2, label %loc_0EF

loc_1F0_2:                                        ; preds = %loc_0E6
  %fnptr_190 = bitcast i8* %call_190 to i32 (i32)*
  %res_ignored_190 = call i32 %fnptr_190(i32 8)
  br label %ret_m1

loc_1A6:                                          ; preds = %loc_190
  %tmp1 = call i8* @sub_140002B68(i32 8, i32 1)
  br label %ret_m1

loc_15E:                                          ; preds = %loc_150_next, %sc_check2
  %call_15e = call i8* @sub_140002B68(i32 4, i32 0)
  %call_15e_int = ptrtoint i8* %call_15e to i64
  %is_one_15e = icmp eq i64 %call_15e_int, 1
  br i1 %is_one_15e, label %loc_210, label %l15e_test

l15e_test:                                        ; preds = %loc_15E
  %is_nonzero_15e = icmp ne i8* %call_15e, null
  br i1 %is_nonzero_15e, label %l15e_call, label %loc_0EF

l15e_call:                                        ; preds = %l15e_test
  %fnptr_15e = bitcast i8* %call_15e to i32 (i32)*
  %res_ignored_15e = call i32 %fnptr_15e(i32 4)
  br label %ret_m1

loc_210:                                          ; preds = %loc_15E
  %tmp2 = call i8* @sub_140002B68(i32 4, i32 1)
  br label %ret_m1

loc_1C0:                                          ; preds = %loc_110
  %call_1c0 = call i8* @sub_140002B68(i32 11, i32 0)
  %call_1c0_int = ptrtoint i8* %call_1c0 to i64
  %is_one_1c0 = icmp eq i64 %call_1c0_int, 1
  br i1 %is_one_1c0, label %loc_1FC, label %l1c0_test

l1c0_test:                                        ; preds = %loc_1C0
  %is_nonzero_1c0 = icmp ne i8* %call_1c0, null
  br i1 %is_nonzero_1c0, label %l1c0_call, label %loc_0EF

l1c0_call:                                        ; preds = %l1c0_test
  %fnptr_1c0 = bitcast i8* %call_1c0 to i32 (i32)*
  %res_ignored_1c0 = call i32 %fnptr_1c0(i32 11)
  br label %ret_m1

loc_1FC:                                          ; preds = %loc_1C0
  %tmp3 = call i8* @sub_140002B68(i32 11, i32 1)
  br label %ret_m1

loc_1F0:                                          ; preds = %d0_test
  %fnptr_d0 = bitcast i8* %call_d0 to i32 (i32)*
  %res_ignored_d0 = call i32 %fnptr_d0(i32 8)
  br label %ret_m1

loc_224:                                          ; preds = %loc_0D0
  %tmp4 = call i8* @sub_140002B68(i32 8, i32 1)
  call void @sub_1400024E0()
  br label %ret_m1

loc_0EF:                                          ; preds = %l1c0_test, %l15e_test, %loc_0E6, %d0_test, %loc_150_next, %loc_110_else, %cmp_range, %sw_entry
  %fp = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %isnullfp = icmp eq i32 (i8*)* %fp, null
  br i1 %isnullfp, label %ret_0, label %tailjmp

tailjmp:                                          ; preds = %loc_0EF
  %rcx_cast = bitcast i8** %rcx to i8*
  %tailres = tail call i32 %fp(i8* %rcx_cast)
  ret i32 %tailres

ret_m1:                                           ; preds = %loc_224, %loc_1F0, %loc_1FC, %l1c0_call, %l15e_call, %loc_210, %loc_1A6, %loc_1F0_2, %sc_check4, %loc_150, %loc_110_else, %check_hdr
  ret i32 -1

ret_0:                                            ; preds = %loc_0EF
  ret i32 0
}