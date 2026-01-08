; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i32 (i8**)*

declare void @sub_1400027A8(i32, i32)

define dso_local i32 @sub_140001CB0(i8** %rcx) {
entry:
  %ld.rdx = load i8*, i8** %rcx
  %rdx.as.i32ptr = bitcast i8* %ld.rdx to i32*
  %ld.eax = load i32, i32* %rdx.as.i32ptr
  %mask = and i32 %ld.eax, 553648127
  %cmp.magic = icmp eq i32 %mask, 541541187
  br i1 %cmp.magic, label %check_flag, label %cmp_range

check_flag:                                            ; preds = %entry
  %rdx.plus4 = getelementptr i8, i8* %ld.rdx, i64 4
  %ld.byte = load i8, i8* %rdx.plus4
  %and1 = and i8 %ld.byte, 1
  %tst = icmp ne i8 %and1, 0
  br i1 %tst, label %cmp_range, label %ret_m1

cmp_range:                                             ; preds = %check_flag, %entry
  %ugt_0096 = icmp ugt i32 %ld.eax, 3221225622
  br i1 %ugt_0096, label %common, label %check_le_008B

check_le_008B:                                         ; preds = %cmp_range
  %ule_008B = icmp ule i32 %ld.eax, 3221225611
  br i1 %ule_008B, label %block_D40, label %switch_range

switch_range:                                          ; preds = %check_le_008B
  %adj = add i32 %ld.eax, 1073741683
  %inrng = icmp ule i32 %adj, 9
  br i1 %inrng, label %sw, label %ret_m1

sw:                                                    ; preds = %switch_range
  switch i32 %adj, label %ret_m1 [
    i32 0, label %call_ecx8
    i32 1, label %call_ecx8
    i32 2, label %call_ecx8
    i32 3, label %call_ecx8
    i32 4, label %call_ecx8
    i32 5, label %ret_m1
    i32 6, label %call_ecx8
    i32 7, label %call_ecx8
    i32 8, label %ret_m1
    i32 9, label %call_ecx4
  ]

call_ecx8:                                             ; preds = %sw, %sw, %sw, %sw, %sw, %sw, %sw
  call void @sub_1400027A8(i32 8, i32 0)
  br label %common

call_ecx4:                                             ; preds = %sw
  call void @sub_1400027A8(i32 4, i32 0)
  br label %common

block_D40:                                             ; preds = %check_le_008B
  %is_av = icmp eq i32 %ld.eax, 3221225477
  br i1 %is_av, label %call_ecxB, label %after_av

after_av:                                              ; preds = %block_D40
  %ugt_0005 = icmp ugt i32 %ld.eax, 3221225477
  br i1 %ugt_0005, label %block_D80, label %check_80000002

check_80000002:                                        ; preds = %after_av
  %is_80000002 = icmp eq i32 %ld.eax, 2147483650
  br i1 %is_80000002, label %ret_m1, label %common

block_D80:                                             ; preds = %after_av
  %is_0008 = icmp eq i32 %ld.eax, 3221225480
  br i1 %is_0008, label %ret_m1, label %check_001D

check_001D:                                            ; preds = %block_D80
  %is_001D = icmp eq i32 %ld.eax, 3221225501
  br i1 %is_001D, label %call_ecx4, label %common

call_ecxB:                                             ; preds = %block_D40
  call void @sub_1400027A8(i32 11, i32 0)
  br label %common

common:                                                ; preds = %check_001D, %check_80000002, %call_ecx4, %call_ecx8, %cmp_range
  %handler.ptr = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0
  %isnull = icmp eq i32 (i8**)* %handler.ptr, null
  br i1 %isnull, label %ret0, label %tailcall

ret0:                                                  ; preds = %common
  ret i32 0

tailcall:                                              ; preds = %common
  %tc = call i32 %handler.ptr(i8** %rcx)
  ret i32 %tc

ret_m1:                                                ; preds = %block_D80, %check_80000002, %sw, %sw, %switch_range, %check_flag
  ret i32 -1
}