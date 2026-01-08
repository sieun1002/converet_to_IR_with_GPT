; ModuleID = 'sub_140002250'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i32 @sub_140002250(i8* %rcx) local_unnamed_addr {
entry:
  %base = load i8*, i8** @off_1400043C0, align 8
  %base_mz_ptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %base_mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr_i8 = getelementptr inbounds i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %pehdr = getelementptr inbounds i8, i8* %base, i64 %e_lfanew64
  %sig_ptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptr_i8 = getelementptr inbounds i8, i8* %pehdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32p = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32p, label %check_sections, label %ret0

check_sections:
  %numsec_ptr_i8 = getelementptr inbounds i8, i8* %pehdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret0, label %cont

cont:
  %szopt_ptr_i8 = getelementptr inbounds i8, i8* %pehdr, i64 20
  %szopt_ptr = bitcast i8* %szopt_ptr_i8 to i16*
  %szopt16 = load i16, i16* %szopt_ptr, align 1
  %szopt32 = zext i16 %szopt16 to i32
  %szopt64 = zext i32 %szopt32 to i64
  %rcx_int = ptrtoint i8* %rcx to i64
  %base_int = ptrtoint i8* %base to i64
  %rva = sub i64 %rcx_int, %base_int
  %opt_end_off = add i64 %szopt64, 24
  %firstsec = getelementptr inbounds i8, i8* %pehdr, i64 %opt_end_off
  %numsec32 = zext i16 %numsec16 to i32
  %numsec64 = zext i32 %numsec32 to i64
  %num_minus1 = add i64 %numsec64, -1
  %times5 = mul i64 %num_minus1, 5
  %times40 = mul i64 %times5, 8
  %end_off = add i64 %times40, 40
  %endptr = getelementptr inbounds i8, i8* %firstsec, i64 %end_off
  br label %loop

loop:
  %cur = phi i8* [ %firstsec, %cont ], [ %next, %advance ]
  %va_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %advance, label %check_within

check_within:
  %vsize_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %vsize64 = zext i32 %vsize32 to i64
  %endva = add i64 %va64, %vsize64
  %rva_lt_end = icmp ult i64 %rva, %endva
  br i1 %rva_lt_end, label %ret0, label %advance

advance:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %endptr
  br i1 %done, label %ret0, label %loop

ret0:
  ret i32 0
}