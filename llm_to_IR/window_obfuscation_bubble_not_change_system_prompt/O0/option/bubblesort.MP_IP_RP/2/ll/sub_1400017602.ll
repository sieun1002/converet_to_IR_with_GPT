; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_14000CFBC(i8*, i8*, i32)
declare void @sub_140001700(i8*, i8*)

define void @sub_140001760(i8* %addr) local_unnamed_addr {
entry:
  %buf = alloca [48 x i8], align 16
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %cmp_le = icmp sle i32 %cnt, 0
  br i1 %cmp_le, label %not_found, label %loop.init

loop.init:                                        ; preds = %entry
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %scan_base = getelementptr inbounds i8, i8* %base0, i64 24
  br label %loop.header

loop.header:                                      ; preds = %loop.inc, %loop.init
  %i = phi i32 [ 0, %loop.init ], [ %i.next, %loop.inc ]
  %cond = icmp slt i32 %i, %cnt
  br i1 %cond, label %loop.body, label %not_found

loop.body:                                        ; preds = %loop.header
  %i64 = zext i32 %i to i64
  %off = mul nuw nsw i64 %i64, 40
  %slotptr = getelementptr inbounds i8, i8* %scan_base, i64 %off
  %slot_as_ptrptr = bitcast i8* %slotptr to i8**
  %start_ptr = load i8*, i8** %slot_as_ptrptr, align 8
  %addr_int = ptrtoint i8* %addr to i64
  %start_int = ptrtoint i8* %start_ptr to i64
  %addr_before = icmp ult i64 %addr_int, %start_int
  br i1 %addr_before, label %loop.inc, label %check_end

check_end:                                        ; preds = %loop.body
  %slot_plus8 = getelementptr inbounds i8, i8* %slotptr, i64 8
  %slot_plus8_ptrptr = bitcast i8* %slot_plus8 to i8**
  %meta_ptr = load i8*, i8** %slot_plus8_ptrptr, align 8
  %meta_plus8 = getelementptr inbounds i8, i8* %meta_ptr, i64 8
  %len_ptr = bitcast i8* %meta_plus8 to i32*
  %len32 = load i32, i32* %len_ptr, align 4
  %len64 = zext i32 %len32 to i64
  %end_int = add i64 %start_int, %len64
  %in_range = icmp ult i64 %addr_int, %end_int
  br i1 %in_range, label %early_ret, label %loop.inc

loop.inc:                                         ; preds = %check_end, %loop.body
  %i.next = add i32 %i, 1
  br label %loop.header

early_ret:                                        ; preds = %check_end
  ret void

not_found:                                        ; preds = %loop.header, %entry
  %call_alloc = call i8* @sub_140002250(i8* %addr)
  %is_null = icmp eq i8* %call_alloc, null
  br i1 %is_null, label %log_no_section, label %update_table

log_no_section:                                   ; preds = %not_found
  %fmt_ptr = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void @sub_140001700(i8* %fmt_ptr, i8* %addr)
  ret void

update_table:                                     ; preds = %not_found
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %cnt64 = sext i32 %cnt to i64
  %off2 = mul nsw i64 %cnt64, 40
  %slot_base = getelementptr inbounds i8, i8* %base1, i64 %off2
  %slot_plus32 = getelementptr inbounds i8, i8* %slot_base, i64 32
  %slot_plus32_ptrptr = bitcast i8* %slot_plus32 to i8**
  store i8* %call_alloc, i8** %slot_plus32_ptrptr, align 8
  %slot_i32ptr = bitcast i8* %slot_base to i32*
  store i32 0, i32* %slot_i32ptr, align 4
  %base2 = call i8* @sub_140002390()
  %alloc_plus12 = getelementptr inbounds i8, i8* %call_alloc, i64 12
  %len2_ptr = bitcast i8* %alloc_plus12 to i32*
  %len2 = load i32, i32* %len2_ptr, align 4
  %len2_zext = zext i32 %len2 to i64
  %dest = getelementptr inbounds i8, i8* %base2, i64 %len2_zext
  %base1a = load i8*, i8** @qword_1400070A8, align 8
  %slot_base2 = getelementptr inbounds i8, i8* %base1a, i64 %off2
  %slot_plus24 = getelementptr inbounds i8, i8* %slot_base2, i64 24
  %slot_plus24_ptrptr = bitcast i8* %slot_plus24 to i8**
  store i8* %dest, i8** %slot_plus24_ptrptr, align 8
  %buf0 = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  call void @sub_14000CFBC(i8* %dest, i8* %buf0, i32 48)
  ret void
}