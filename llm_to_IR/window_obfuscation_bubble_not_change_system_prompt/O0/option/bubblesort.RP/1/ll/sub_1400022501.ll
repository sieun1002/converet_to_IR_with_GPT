; ModuleID = 'sub_140002250'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i64 @sub_140002250(i8* %p) {
entry:
  %base_ptr = load i8*, i8** @off_1400043C0, align 8
  %dos_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %dos_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %lfanew_ptr_i8 = getelementptr inbounds i8, i8* %base_ptr, i64 60
  %lfanew_ptr = bitcast i8* %lfanew_ptr_i8 to i32*
  %lfanew = load i32, i32* %lfanew_ptr, align 1
  %lfanew64 = sext i32 %lfanew to i64
  %nt_ptr = getelementptr inbounds i8, i8* %base_ptr, i64 %lfanew64
  %sig_ptr = bitcast i8* %nt_ptr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptr_i8 = getelementptr inbounds i8, i8* %nt_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pep = icmp eq i16 %opt_magic, 523
  br i1 %is_pep, label %sections_prep, label %ret0

sections_prep:
  %nsec_ptr_i8 = getelementptr inbounds i8, i8* %nt_ptr, i64 6
  %nsec_ptr = bitcast i8* %nsec_ptr_i8 to i16*
  %nsec = load i16, i16* %nsec_ptr, align 1
  %nsec_is_zero = icmp eq i16 %nsec, 0
  br i1 %nsec_is_zero, label %ret0, label %have_sections

have_sections:
  %soh_ptr_i8 = getelementptr inbounds i8, i8* %nt_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh = load i16, i16* %soh_ptr, align 1
  %p_int = ptrtoint i8* %p to i64
  %base_int = ptrtoint i8* %base_ptr to i64
  %rva = sub i64 %p_int, %base_int
  %soh64 = zext i16 %soh to i64
  %sect_off = add i64 %soh64, 24
  %sect_start = getelementptr inbounds i8, i8* %nt_ptr, i64 %sect_off
  %nsec64 = zext i16 %nsec to i64
  %total = mul i64 %nsec64, 40
  %sect_end = getelementptr inbounds i8, i8* %sect_start, i64 %total
  br label %loop

loop:
  %curr = phi i8* [ %sect_start, %have_sections ], [ %next, %loop_next ]
  %done = icmp eq i8* %curr, %sect_end
  br i1 %done, label %ret0_tail, label %loop_body

loop_body:
  %va_ptr_i8 = getelementptr inbounds i8, i8* %curr, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %loop_next, label %check_range

check_range:
  %vs_ptr_i8 = getelementptr inbounds i8, i8* %curr, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs32 = load i32, i32* %vs_ptr, align 1
  %vs64 = zext i32 %vs32 to i64
  %va_plus_vs = add i64 %va64, %vs64
  %inrange = icmp ult i64 %rva, %va_plus_vs
  br i1 %inrange, label %ret0, label %loop_next

loop_next:
  %next = getelementptr inbounds i8, i8* %curr, i64 40
  br label %loop

ret0_tail:
  br label %ret0

ret0:
  ret i64 0
}