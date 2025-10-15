; ModuleID = 'pe_section_lookup'
target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002600(i8* %base, i64 %rva) {
entry:
  %eoff_ptr_i8 = getelementptr i8, i8* %base, i64 60
  %eoff_ptr_i32 = bitcast i8* %eoff_ptr_i8 to i32*
  %eoff_i32 = load i32, i32* %eoff_ptr_i32, align 1
  %eoff_i64 = sext i32 %eoff_i32 to i64
  %nt = getelementptr i8, i8* %base, i64 %eoff_i64
  %num_ptr_i8 = getelementptr i8, i8* %nt, i64 6
  %num_ptr = bitcast i8* %num_ptr_i8 to i16*
  %num_i16 = load i16, i16* %num_ptr, align 1
  %iszero = icmp eq i16 %num_i16, 0
  br i1 %iszero, label %retzero, label %cont

cont:
  %soh_ptr_i8 = getelementptr i8, i8* %nt, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh_i16 = load i16, i16* %soh_ptr, align 1
  %soh_i64 = zext i16 %soh_i16 to i64
  %num64 = zext i16 %num_i16 to i64
  %numMinus1 = add i64 %num64, -1
  %mul5 = mul i64 %numMinus1, 5
  %sec0_i8 = getelementptr i8, i8* %nt, i64 24
  %secstart = getelementptr i8, i8* %sec0_i8, i64 %soh_i64
  %scaled8 = mul i64 %mul5, 8
  %plus28 = add i64 %scaled8, 40
  %end = getelementptr i8, i8* %secstart, i64 %plus28
  br label %loop

loop:
  %cur = phi i8* [ %secstart, %cont ], [ %next, %advance ]
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %cmp1 = icmp ult i64 %rva, %va64
  br i1 %cmp1, label %advance, label %check

check:
  %vsize_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %sum32 = add i32 %va32, %vsize32
  %sum64 = zext i32 %sum32 to i64
  %cmp2 = icmp ult i64 %rva, %sum64
  br i1 %cmp2, label %found, label %advance

advance:
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end
  br i1 %done, label %retzero, label %loop

found:
  ret i8* %cur

retzero:
  ret i8* null
}