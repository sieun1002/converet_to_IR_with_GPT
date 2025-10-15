; ModuleID = 'sub_140002610.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002610(i8* %rcx_param) local_unnamed_addr {
entry:
  %baseptrptr1 = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptrptr1 to i16*
  %mzval = load i16, i16* %mzptr, align 2
  %cmp_mz = icmp eq i16 %mzval, 23117
  br i1 %cmp_mz, label %after_mz, label %ret0

after_mz:
  %e_lfanew_ptr8 = getelementptr inbounds i8, i8* %baseptrptr1, i64 60
  %e_lfanew_ptr32 = bitcast i8* %e_lfanew_ptr8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_ptr32, align 4
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %ntptr = getelementptr inbounds i8, i8* %baseptrptr1, i64 %e_lfanew64
  %sigptr = bitcast i8* %ntptr to i32*
  %sigval = load i32, i32* %sigptr, align 4
  %is_pe = icmp eq i32 %sigval, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptr8 = getelementptr inbounds i8, i8* %ntptr, i64 24
  %opt_magic_ptr16 = bitcast i8* %opt_magic_ptr8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr16, align 2
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %cont1, label %ret0

cont1:
  %numsec_ptr8 = getelementptr inbounds i8, i8* %ntptr, i64 6
  %numsec_ptr16 = bitcast i8* %numsec_ptr8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr16, align 2
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret0, label %cont2

cont2:
  %szopt_ptr8 = getelementptr inbounds i8, i8* %ntptr, i64 20
  %szopt_ptr16 = bitcast i8* %szopt_ptr8 to i16*
  %szopt16 = load i16, i16* %szopt_ptr16, align 2
  %rcx_int = ptrtoint i8* %rcx_param to i64
  %base_int = ptrtoint i8* %baseptrptr1 to i64
  %rva = sub i64 %rcx_int, %base_int
  %szopt64 = zext i16 %szopt16 to i64
  %first_sect_base = getelementptr inbounds i8, i8* %ntptr, i64 24
  %first_sect = getelementptr inbounds i8, i8* %first_sect_base, i64 %szopt64
  %numsec32 = zext i16 %numsec16 to i32
  %numsec64 = zext i32 %numsec32 to i64
  %table_bytes = mul nuw nsw i64 %numsec64, 40
  %endptr = getelementptr inbounds i8, i8* %first_sect, i64 %table_bytes
  br label %loop

loop:
  %cur = phi i8* [ %first_sect, %cont2 ], [ %next, %incr ]
  %done = icmp uge i8* %cur, %endptr
  br i1 %done, label %endloop, label %body

body:
  %va_ptr8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va_ptr32 = bitcast i8* %va_ptr8 to i32*
  %va32 = load i32, i32* %va_ptr32, align 4
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %incr, label %range_check

range_check:
  %vsize_ptr8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vsize_ptr32 = bitcast i8* %vsize_ptr8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr32, align 4
  %vsize64 = zext i32 %vsize32 to i64
  %end_rva = add i64 %va64, %vsize64
  %in_range = icmp ult i64 %rva, %end_rva
  br i1 %in_range, label %ret0, label %incr

incr:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  br label %loop

endloop:
  br label %ret0

ret0:
  ret i32 0
}