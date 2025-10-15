; ModuleID = 'pe_section_lookup'
source_filename = "pe_section_lookup"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*

define dso_local i8* @sub_140002610(i8* %addr) local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr_i8 = getelementptr i8, i8* %base_ptr, i64 0
  %mz_ptr = bitcast i8* %mz_ptr_i8 to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_nt, label %ret_null

check_nt:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_i64 = sext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base_ptr, i64 %e_lfanew_i64
  %sig_ptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret_null

check_opt:
  %magic_ptr_i8 = getelementptr i8, i8* %nt, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %cont1, label %ret_null

cont1:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret_null, label %cont2

cont2:
  %soh_ptr_i8 = getelementptr i8, i8* %nt, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %opt_start = getelementptr i8, i8* %nt, i64 24
  %first = getelementptr i8, i8* %opt_start, i64 %soh64
  %numsec64 = zext i16 %numsec16 to i64
  %nbytes = mul i64 %numsec64, 40
  %end = getelementptr i8, i8* %first, i64 %nbytes
  %addr_i64 = ptrtoint i8* %addr to i64
  %base_i64 = ptrtoint i8* %base_ptr to i64
  %rva = sub i64 %addr_i64, %base_i64
  br label %body

body:
  %p = phi i8* [ %first, %cont2 ], [ %next, %inc ]
  %va_ptr_i8 = getelementptr i8, i8* %p, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %inc, label %check2

check2:
  %vsz_ptr_i8 = getelementptr i8, i8* %p, i64 8
  %vsz_ptr = bitcast i8* %vsz_ptr_i8 to i32*
  %vsz32 = load i32, i32* %vsz_ptr, align 1
  %vsz64 = zext i32 %vsz32 to i64
  %limit = add i64 %va64, %vsz64
  %inrange = icmp ult i64 %rva, %limit
  br i1 %inrange, label %ret_p, label %inc

inc:
  %next = getelementptr i8, i8* %p, i64 40
  %done = icmp eq i8* %next, %end
  br i1 %done, label %ret_null, label %body

ret_p:
  ret i8* %p

ret_null:
  ret i8* null
}