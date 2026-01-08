target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*

define dso_local i32 @sub_140002250(i8* %arg) {
entry:
  %baseptr = load i8*, i8** @off_1400043C0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 2
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %check_pe, label %ret

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 4
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nthdr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sig_ptr, align 4
  %pe_ok = icmp eq i32 %sig, 17744
  br i1 %pe_ok, label %check_64, label %ret

check_64:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nthdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 2
  %magic_ok = icmp eq i16 %opt_magic, 523
  br i1 %magic_ok, label %check_sections, label %ret

check_sections:
  %numsec_ptr_i8 = getelementptr i8, i8* %nthdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 2
  %numsec_iszero = icmp eq i16 %numsec16, 0
  br i1 %numsec_iszero, label %ret, label %prepare

prepare:
  %sizeopt_ptr_i8 = getelementptr i8, i8* %nthdr, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_ptr_i8 to i16*
  %sizeopt16 = load i16, i16* %sizeopt_ptr, align 2
  %optSize64 = zext i16 %sizeopt16 to i64
  %arg_int = ptrtoint i8* %arg to i64
  %base_int = ptrtoint i8* %baseptr to i64
  %rva = sub i64 %arg_int, %base_int
  %numsec32 = zext i16 %numsec16 to i32
  %dec32 = add i32 %numsec32, -1
  %times5_32 = mul i32 %dec32, 5
  %times5_64 = zext i32 %times5_32 to i64
  %times40 = shl i64 %times5_64, 3
  %firstsec_base = getelementptr i8, i8* %nthdr, i64 24
  %firstsec = getelementptr i8, i8* %firstsec_base, i64 %optSize64
  %temp_end = getelementptr i8, i8* %firstsec, i64 %times40
  %endptr = getelementptr i8, i8* %temp_end, i64 40
  br label %loop

loop:
  %cur = phi i8* [ %firstsec, %prepare ], [ %next, %cont ]
  %vaddr_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %vaddr_ptr = bitcast i8* %vaddr_ptr_i8 to i32*
  %vaddr32 = load i32, i32* %vaddr_ptr, align 4
  %vaddr64 = zext i32 %vaddr32 to i64
  %cmp_start = icmp ult i64 %rva, %vaddr64
  br i1 %cmp_start, label %cont, label %check_in

check_in:
  %vsize_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 4
  %end32 = add i32 %vaddr32, %vsize32
  %end64 = zext i32 %end32 to i64
  %cmp_in = icmp ult i64 %rva, %end64
  br i1 %cmp_in, label %ret, label %cont

cont:
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %endptr
  br i1 %done, label %epilog, label %loop

epilog:
  br label %ret

ret:
  ret i32 0
}