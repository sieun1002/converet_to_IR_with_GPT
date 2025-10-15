; ModuleID = 'sub_140002520.ll'
target triple = "x86_64-pc-windows-msvc"

define dso_local i8* @sub_140002520(i8* %base, i64 %rva) {
entry:
  %ofs_ptr = getelementptr inbounds i8, i8* %base, i64 60
  %ofs_ptr_i32 = bitcast i8* %ofs_ptr to i32*
  %e_lfanew = load i32, i32* %ofs_ptr_i32, align 1
  %e64 = zext i32 %e_lfanew to i64
  %pe_hdr = getelementptr inbounds i8, i8* %base, i64 %e64
  %nos_ptr_i8 = getelementptr inbounds i8, i8* %pe_hdr, i64 6
  %nos_ptr = bitcast i8* %nos_ptr_i8 to i16*
  %nos16 = load i16, i16* %nos_ptr, align 1
  %nos_is_zero = icmp eq i16 %nos16, 0
  br i1 %nos_is_zero, label %ret_zero, label %nonzero

nonzero:
  %soh_ptr_i8 = getelementptr inbounds i8, i8* %pe_hdr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %sect_table_base = getelementptr inbounds i8, i8* %pe_hdr, i64 24
  %first = getelementptr inbounds i8, i8* %sect_table_base, i64 %soh64
  %nos64 = zext i16 %nos16 to i64
  %bytes = mul i64 %nos64, 40
  %end = getelementptr inbounds i8, i8* %first, i64 %bytes
  br label %loop

loop:
  %cur = phi i8* [ %first, %nonzero ], [ %next, %advance ]
  %va_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %advance, label %check

check:
  %vs_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs32 = load i32, i32* %vs_ptr, align 1
  %vs64 = zext i32 %vs32 to i64
  %endaddr = add i64 %va64, %vs64
  %inrange = icmp ult i64 %rva, %endaddr
  br i1 %inrange, label %ret_found, label %advance

advance:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %neq = icmp ne i8* %next, %end
  br i1 %neq, label %loop, label %ret_zero

ret_found:
  ret i8* %cur

ret_zero:
  ret i8* null
}