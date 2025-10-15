target triple = "x86_64-pc-windows-msvc"

define dso_local i8* @sub_140002520(i8* %rcx.arg, i64 %rdx.arg) {
entry:
  %e_lfanew.ptr = getelementptr i8, i8* %rcx.arg, i64 60
  %e_lfanew.i32ptr = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew.val.i32 = load i32, i32* %e_lfanew.i32ptr, align 1
  %e_lfanew.val.i64 = sext i32 %e_lfanew.val.i32 to i64
  %nt.ptr = getelementptr i8, i8* %rcx.arg, i64 %e_lfanew.val.i64
  %numsects.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 6
  %numsects.ptr = bitcast i8* %numsects.ptr.i8 to i16*
  %numsects.i16 = load i16, i16* %numsects.ptr, align 1
  %numsects.zero = icmp eq i16 %numsects.i16, 0
  br i1 %numsects.zero, label %ret_zero, label %have_sections

have_sections:
  %opthdrsz.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 20
  %opthdrsz.ptr = bitcast i8* %opthdrsz.ptr.i8 to i16*
  %opthdrsz.i16 = load i16, i16* %opthdrsz.ptr, align 1
  %opthdrsz.i64 = zext i16 %opthdrsz.i16 to i64
  %first_after_filehdr = getelementptr i8, i8* %nt.ptr, i64 24
  %first_sect = getelementptr i8, i8* %first_after_filehdr, i64 %opthdrsz.i64
  %numsects.i32 = zext i16 %numsects.i16 to i32
  %num_minus_one.i32 = add i32 %numsects.i32, 4294967295
  %num_minus_one.i64 = zext i32 %num_minus_one.i32 to i64
  %times5.i64 = mul i64 %num_minus_one.i64, 5
  %bytes_span.i64 = mul i64 %times5.i64, 8
  %endptr.tmp = getelementptr i8, i8* %first_sect, i64 %bytes_span.i64
  %endptr = getelementptr i8, i8* %endptr.tmp, i64 40
  br label %loop

loop:
  %cur = phi i8* [ %first_sect, %have_sections ], [ %next, %advance ]
  %virtaddr.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %virtaddr.ptr = bitcast i8* %virtaddr.ptr.i8 to i32*
  %virtaddr.i32 = load i32, i32* %virtaddr.ptr, align 1
  %virtaddr.i64 = zext i32 %virtaddr.i32 to i64
  %cmp1 = icmp ult i64 %rdx.arg, %virtaddr.i64
  br i1 %cmp1, label %advance, label %check_range

check_range:
  %vsize.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize.i32 = load i32, i32* %vsize.ptr, align 1
  %sum.i32 = add i32 %virtaddr.i32, %vsize.i32
  %sum.i64 = zext i32 %sum.i32 to i64
  %cmp2 = icmp ult i64 %rdx.arg, %sum.i64
  br i1 %cmp2, label %found, label %advance

advance:
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %endptr
  br i1 %done, label %ret_zero, label %loop

found:
  ret i8* %cur

ret_zero:
  ret i8* null
}