; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i32 (i8*)*

declare i8* @sub_1400027A8(i32, i32)
declare void @sub_140002120()

define i32 @sub_140001CB0(i8** %rcx) local_unnamed_addr nounwind {
entry:
  %rdx = load i8*, i8** %rcx, align 8
  %status.ptr = bitcast i8* %rdx to i32*
  %status = load i32, i32* %status.ptr, align 4
  %masked = and i32 %status, 553648127
  %cmp_hdr = icmp eq i32 %masked, 541549379
  br i1 %cmp_hdr, label %hdr_true, label %cmp_chain

hdr_true:                                            ; preds = %entry
  %flag.ptr = getelementptr i8, i8* %rdx, i64 4
  %flag.byte = load i8, i8* %flag.ptr, align 1
  %flag.and = and i8 %flag.byte, 1
  %flag.nz = icmp ne i8 %flag.and, 0
  br i1 %flag.nz, label %cmp_chain, label %ret_m1

cmp_chain:                                           ; preds = %hdr_true, %entry
  %ugt_hi = icmp ugt i32 %status, 3221225622
  br i1 %ugt_hi, label %tailcall, label %le_8B

le_8B:                                               ; preds = %cmp_chain
  %ule_lo = icmp ule i32 %status, 3221225611
  br i1 %ule_lo, label %blk_d40, label %jt_prep

jt_prep:                                             ; preds = %le_8B
  %idx_add = add i32 %status, 1073741683
  %idx_gt9 = icmp ugt i32 %idx_add, 9
  br i1 %idx_gt9, label %ret_m1, label %switch

switch:                                              ; preds = %jt_prep
  switch i32 %idx_add, label %ret_m1 [
    i32 0, label %case_d00
    i32 1, label %case_d00
    i32 2, label %case_d00
    i32 3, label %case_d00
    i32 4, label %case_d00
    i32 6, label %case_d00
    i32 7, label %case_dc0
    i32 9, label %case_d8e
    i32 5, label %ret_m1
    i32 8, label %ret_m1
  ]

case_d00:                                            ; preds = %switch, %switch, %switch, %switch, %switch, %switch
  %retp_d00 = call i8* @sub_1400027A8(i32 8, i32 0)
  %retp_d00_int = ptrtoint i8* %retp_d00 to i64
  %is_one_d00 = icmp eq i64 %retp_d00_int, 1
  br i1 %is_one_d00, label %blk_e54, label %d00_testnull

d00_testnull:                                        ; preds = %case_d00
  %is_null_d00 = icmp eq i8* %retp_d00, null
  br i1 %is_null_d00, label %tailcall, label %blk_e20

blk_e20:                                             ; preds = %d00_testnull
  %fn8ptr = bitcast i8* %retp_d00 to void (i32)*
  call void %fn8ptr(i32 8)
  br label %ret_m1

case_dc0:                                            ; preds = %switch
  %retp_dc0 = call i8* @sub_1400027A8(i32 8, i32 0)
  %retp_dc0_int = ptrtoint i8* %retp_dc0 to i64
  %is_one_dc0 = icmp eq i64 %retp_dc0_int, 1
  br i1 %is_one_dc0, label %dc0_one, label %dc0_not_one

dc0_not_one:                                         ; preds = %case_dc0
  %is_null_dc0 = icmp eq i8* %retp_dc0, null
  br i1 %is_null_dc0, label %tailcall, label %dc0_call

dc0_call:                                            ; preds = %dc0_not_one
  %fn8ptr_dc0 = bitcast i8* %retp_dc0 to void (i32)*
  call void %fn8ptr_dc0(i32 8)
  br label %ret_m1

dc0_one:                                             ; preds = %case_dc0
  %tmp_call_e54_only = call i8* @sub_1400027A8(i32 8, i32 1)
  br label %ret_m1

case_d8e:                                            ; preds = %switch
  %retp_d8e = call i8* @sub_1400027A8(i32 4, i32 0)
  %retp_d8e_int = ptrtoint i8* %retp_d8e to i64
  %is_one_d8e = icmp eq i64 %retp_d8e_int, 1
  br i1 %is_one_d8e, label %blk_e40, label %d8e_testnull

d8e_testnull:                                        ; preds = %case_d8e
  %is_null_d8e = icmp eq i8* %retp_d8e, null
  br i1 %is_null_d8e, label %tailcall, label %d8e_call

d8e_call:                                            ; preds = %d8e_testnull
  %fn4ptr = bitcast i8* %retp_d8e to void (i32)*
  call void %fn4ptr(i32 4)
  br label %ret_m1

blk_e40:                                             ; preds = %case_d8e
  %tmp_call_e40 = call i8* @sub_1400027A8(i32 4, i32 1)
  br label %ret_m1

blk_d40:                                             ; preds = %le_8B
  %eq_av = icmp eq i32 %status, 3221225477
  br i1 %eq_av, label %blk_df0, label %d40_next

d40_next:                                            ; preds = %blk_d40
  %ugt_av = icmp ugt i32 %status, 3221225477
  br i1 %ugt_av, label %blk_d80, label %d40_low

d40_low:                                             ; preds = %d40_next
  %eq_80000002 = icmp eq i32 %status, 2147483650
  br i1 %eq_80000002, label %ret_m1, label %tailcall

blk_d80:                                             ; preds = %d40_next
  %eq_c0000008 = icmp eq i32 %status, 3221225480
  br i1 %eq_c0000008, label %ret_m1, label %d80_next

d80_next:                                            ; preds = %blk_d80
  %eq_c000001d = icmp eq i32 %status, 3221225501
  br i1 %eq_c000001d, label %case_d8e, label %tailcall

blk_df0:                                             ; preds = %blk_d40
  %retp_df0 = call i8* @sub_1400027A8(i32 11, i32 0)
  %retp_df0_int = ptrtoint i8* %retp_df0 to i64
  %is_one_df0 = icmp eq i64 %retp_df0_int, 1
  br i1 %is_one_df0, label %blk_e2c, label %df0_testnull

df0_testnull:                                        ; preds = %blk_df0
  %is_null_df0 = icmp eq i8* %retp_df0, null
  br i1 %is_null_df0, label %tailcall, label %df0_call

df0_call:                                            ; preds = %df0_testnull
  %fnBptr = bitcast i8* %retp_df0 to void (i32)*
  call void %fnBptr(i32 11)
  br label %ret_m1

blk_e2c:                                             ; preds = %blk_df0
  %tmp_call_e2c = call i8* @sub_1400027A8(i32 11, i32 1)
  br label %ret_m1

blk_e54:                                             ; preds = %case_d00
  %tmp_call_e54a = call i8* @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %ret_m1

tailcall:                                            ; preds = %df0_testnull, %d80_next, %d40_low, %d00_testnull, %cmp_chain
  %fp = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %fp_isnull = icmp eq i32 (i8*)* %fp, null
  br i1 %fp_isnull, label %ret_0, label %do_tail

do_tail:                                             ; preds = %tailcall
  %arg_cast = bitcast i8** %rcx to i8*
  %callres = musttail call i32 %fp(i8* %arg_cast)
  ret i32 %callres

ret_0:                                               ; preds = %tailcall
  ret i32 0

ret_m1:                                              ; preds = %blk_e54, %blk_e2c, %df0_call, %d8e_call, %d8e_testnull, %blk_e40, %dc0_call, %dc0_not_one, %dc0_one, %blk_e20, %switch, %jt_prep, %hdr_true
  ret i32 -1
}