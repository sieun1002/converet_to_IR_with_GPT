; ModuleID = 'sub_140002250'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i32 @sub_140002250(i64 %rcx) {
entry:
  %baseptr = load i8*, i8** @off_1400043C0, align 8
  %base_i16ptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %base_i16ptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_i32ptr, align 4
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %pehdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 4
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_optmagic, label %ret0

check_optmagic:
  %optmagic_ptr_i8 = getelementptr i8, i8* %pehdr, i64 24
  %optmagic_ptr = bitcast i8* %optmagic_ptr_i8 to i16*
  %optmagic = load i16, i16* %optmagic_ptr, align 2
  %is_pe32plus = icmp eq i16 %optmagic, 523
  br i1 %is_pe32plus, label %load_nsects, label %ret0

load_nsects:
  %nsects_ptr_i8 = getelementptr i8, i8* %pehdr, i64 6
  %nsects_ptr = bitcast i8* %nsects_ptr_i8 to i16*
  %nsects16 = load i16, i16* %nsects_ptr, align 2
  %nsects_is_zero = icmp eq i16 %nsects16, 0
  br i1 %nsects_is_zero, label %ret0, label %cont1

cont1:
  %sizeopt_ptr_i8 = getelementptr i8, i8* %pehdr, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_ptr_i8 to i16*
  %sizeopt16 = load i16, i16* %sizeopt_ptr, align 2
  %base_int = ptrtoint i8* %baseptr to i64
  %rva = sub i64 %rcx, %base_int
  %nsects32 = zext i16 %nsects16 to i32
  %nsects_minus1_32 = add i32 %nsects32, 4294967295
  %nsects_minus1_64 = zext i32 %nsects_minus1_32 to i64
  %times5 = mul i64 %nsects_minus1_64, 5
  %sizeopt64 = zext i16 %sizeopt16 to i64
  %firstsect = getelementptr i8, i8* %pehdr, i64 %sizeopt64
  %firstsect2 = getelementptr i8, i8* %firstsect, i64 24
  %rdx8 = mul i64 %times5, 8
  %endptr_pre = getelementptr i8, i8* %firstsect2, i64 %rdx8
  %endptr = getelementptr i8, i8* %endptr_pre, i64 40
  br label %loop

loop:
  %secptr = phi i8* [ %firstsect2, %cont1 ], [ %secptr_next, %advance ]
  %va_ptr_i8 = getelementptr i8, i8* %secptr, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 4
  %va64 = zext i32 %va to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %advance, label %check_end

check_end:
  %vsz_ptr_i8 = getelementptr i8, i8* %secptr, i64 8
  %vsz_ptr = bitcast i8* %vsz_ptr_i8 to i32*
  %vsz = load i32, i32* %vsz_ptr, align 4
  %sum32 = add i32 %va, %vsz
  %sum64 = zext i32 %sum32 to i64
  %inrange = icmp ult i64 %rva, %sum64
  br i1 %inrange, label %ret0, label %advance

advance:
  %secptr_next = getelementptr i8, i8* %secptr, i64 40
  %at_end = icmp eq i8* %secptr_next, %endptr
  br i1 %at_end, label %final_ret, label %loop

ret0:
  ret i32 0

final_ret:
  ret i32 0
}