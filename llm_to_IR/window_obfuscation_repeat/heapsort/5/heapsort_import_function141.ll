; ModuleID = 'module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002610(i8* %addr) {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %check_pe, label %ret0

check_pe:
  %p_e_lfanew = getelementptr inbounds i8, i8* %base, i64 60
  %e_ptr = bitcast i8* %p_e_lfanew to i32*
  %e32 = load i32, i32* %e_ptr, align 1
  %e64 = sext i32 %e32 to i64
  %nt = getelementptr inbounds i8, i8* %base, i64 %e64
  %sig_ptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %pe_ok = icmp eq i32 %sig, 17744
  br i1 %pe_ok, label %check_magic, label %ret0

check_magic:
  %magic_ptr_i8 = getelementptr inbounds i8, i8* %nt, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %magic_ok = icmp eq i16 %magic, 523
  br i1 %magic_ok, label %load_sections, label %ret0

load_sections:
  %nsec_ptr_i8 = getelementptr inbounds i8, i8* %nt, i64 6
  %nsec_ptr = bitcast i8* %nsec_ptr_i8 to i16*
  %nsec16 = load i16, i16* %nsec_ptr, align 1
  %nsec_zero = icmp eq i16 %nsec16, 0
  br i1 %nsec_zero, label %ret0, label %cont

cont:
  %soh_ptr_i8 = getelementptr inbounds i8, i8* %nt, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %addr_int = ptrtoint i8* %addr to i64
  %base_int = ptrtoint i8* %base to i64
  %rva = sub i64 %addr_int, %base_int
  %first_tmp = getelementptr inbounds i8, i8* %nt, i64 24
  %first = getelementptr inbounds i8, i8* %first_tmp, i64 %soh64
  %nsec64 = zext i16 %nsec16 to i64
  %nsec_mul = mul i64 %nsec64, 40
  %end = getelementptr inbounds i8, i8* %first, i64 %nsec_mul
  br label %loop

loop:
  %cur = phi i8* [ %first, %cont ], [ %cur_next, %inc ]
  %cmp_end = icmp eq i8* %cur, %end
  br i1 %cmp_end, label %ret0, label %loop_body

loop_body:
  %va_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %size_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %size_ptr = bitcast i8* %size_ptr_i8 to i32*
  %size32 = load i32, i32* %size_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %inc, label %check_in

check_in:
  %sum32 = add i32 %va32, %size32
  %sum64 = zext i32 %sum32 to i64
  %rva_lt_sum = icmp ult i64 %rva, %sum64
  br i1 %rva_lt_sum, label %ret0, label %inc

inc:
  %cur_next = getelementptr inbounds i8, i8* %cur, i64 40
  br label %loop

ret0:
  ret i32 0
}