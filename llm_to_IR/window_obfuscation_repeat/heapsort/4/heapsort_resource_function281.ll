; ModuleID = 'pe_section_contains_rva'
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @sub_140002520(i8* nocapture readonly %base, i64 %rva) local_unnamed_addr {
entry:
  %off_ptr.i8 = getelementptr inbounds i8, i8* %base, i64 60
  %off_ptr = bitcast i8* %off_ptr.i8 to i32*
  %pe_off32 = load i32, i32* %off_ptr, align 1
  %pe_off = zext i32 %pe_off32 to i64
  %nt_hdr = getelementptr inbounds i8, i8* %base, i64 %pe_off
  %numsec_ptr.i8 = getelementptr inbounds i8, i8* %nt_hdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret0, label %nonzero

nonzero:                                          ; preds = %entry
  %opthdrsz_ptr.i8 = getelementptr inbounds i8, i8* %nt_hdr, i64 20
  %opthdrsz_ptr = bitcast i8* %opthdrsz_ptr.i8 to i16*
  %opthdrsz16 = load i16, i16* %opthdrsz_ptr, align 1
  %opthdrsz = zext i16 %opthdrsz16 to i64
  %sect_table_off = add i64 %opthdrsz, 24
  %sect_base = getelementptr inbounds i8, i8* %nt_hdr, i64 %sect_table_off
  %numsec64 = zext i16 %numsec16 to i64
  %sect_bytes = mul i64 %numsec64, 40
  %sect_end = getelementptr inbounds i8, i8* %sect_base, i64 %sect_bytes
  br label %loop

loop:                                             ; preds = %nextblock, %nonzero
  %cur = phi i8* [ %sect_base, %nonzero ], [ %next, %nextblock ]
  %va_ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr.i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va
  br i1 %rva_lt_va, label %advance, label %check_high

check_high:                                       ; preds = %loop
  %vsize_ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr.i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %vsize = zext i32 %vsize32 to i64
  %upper = add i64 %va, %vsize
  %in_range = icmp ult i64 %rva, %upper
  br i1 %in_range, label %ret1, label %advance

advance:                                          ; preds = %check_high, %loop
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %sect_end
  br i1 %done, label %ret0, label %nextblock

nextblock:                                        ; preds = %advance
  br label %loop

ret0:                                             ; preds = %advance, %entry
  ret i32 0

ret1:                                             ; preds = %check_high
  ret i32 1
}