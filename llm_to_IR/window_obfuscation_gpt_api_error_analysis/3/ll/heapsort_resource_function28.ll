; ModuleID = 'sub_140002520.ll'
source_filename = "sub_140002520"
target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002520(i8* %base, i64 %rva) {
entry:
  %e_lfanew_ptr.i8 = getelementptr inbounds i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr.i8 to i32*
  %e_lfanew.i32 = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew = sext i32 %e_lfanew.i32 to i64
  %nt_hdr = getelementptr inbounds i8, i8* %base, i64 %e_lfanew
  %num_sections_ptr.i8 = getelementptr inbounds i8, i8* %nt_hdr, i64 6
  %num_sections_ptr = bitcast i8* %num_sections_ptr.i8 to i16*
  %num_sections.i16 = load i16, i16* %num_sections_ptr, align 1
  %num_is_zero = icmp eq i16 %num_sections.i16, 0
  br i1 %num_is_zero, label %ret_zero, label %have_sections

have_sections:
  %opt_size_ptr.i8 = getelementptr inbounds i8, i8* %nt_hdr, i64 20
  %opt_size_ptr = bitcast i8* %opt_size_ptr.i8 to i16*
  %opt_size.i16 = load i16, i16* %opt_size_ptr, align 1
  %opt_size = zext i16 %opt_size.i16 to i64
  %sect_start_off = add i64 %opt_size, 24
  %sect_start = getelementptr inbounds i8, i8* %nt_hdr, i64 %sect_start_off
  %num_sections = zext i16 %num_sections.i16 to i64
  %span_bytes = mul i64 %num_sections, 40
  %sect_end = getelementptr inbounds i8, i8* %sect_start, i64 %span_bytes
  br label %loop

loop:
  %cur = phi i8* [ %sect_start, %have_sections ], [ %next, %advance ]
  %done = icmp eq i8* %cur, %sect_end
  br i1 %done, label %ret_zero, label %body

body:
  %va_ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr.i8 to i32*
  %va.i32 = load i32, i32* %va_ptr, align 1
  %va = zext i32 %va.i32 to i64
  %cmp_lo = icmp ult i64 %rva, %va
  br i1 %cmp_lo, label %advance, label %check_hi

check_hi:
  %vsize_ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr.i8 to i32*
  %vsize.i32 = load i32, i32* %vsize_ptr, align 1
  %vsize = zext i32 %vsize.i32 to i64
  %upper = add i64 %va, %vsize
  %cmp_hi = icmp ult i64 %rva, %upper
  br i1 %cmp_hi, label %ret_found, label %advance

advance:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  br label %loop

ret_zero:
  ret i8* null

ret_found:
  ret i8* %cur
}