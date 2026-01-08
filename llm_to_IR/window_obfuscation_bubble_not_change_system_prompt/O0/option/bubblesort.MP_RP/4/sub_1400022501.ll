target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*

define dso_local i32 @sub_140002250(i8* %0) {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %nt_check, label %ret0

nt_check:
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew = sext i32 %e_lfanew32 to i64
  %pe = getelementptr i8, i8* %base.ptr, i64 %e_lfanew
  %sig.ptr = bitcast i8* %pe to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %opt_hdr_magic, label %ret0

opt_hdr_magic:
  %magic.ptr.i8 = getelementptr i8, i8* %pe, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is_pe32_plus = icmp eq i16 %magic, 523
  br i1 %is_pe32_plus, label %section_count, label %ret0

section_count:
  %numsec.ptr.i8 = getelementptr i8, i8* %pe, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret0, label %compute_start

compute_start:
  %soh.ptr.i8 = getelementptr i8, i8* %pe, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 1
  %soh32 = zext i16 %soh16 to i32
  %addr_i64 = ptrtoint i8* %0 to i64
  %base_i64 = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %addr_i64, %base_i64
  %opt_base = getelementptr i8, i8* %pe, i64 24
  %soh64 = zext i16 %soh16 to i64
  %sect_base = getelementptr i8, i8* %opt_base, i64 %soh64
  %numsec32 = zext i16 %numsec16 to i32
  %numsec64 = zext i32 %numsec32 to i64
  %sections_bytes = mul i64 %numsec64, 40
  %end = getelementptr i8, i8* %sect_base, i64 %sections_bytes
  br label %loop_body

loop_body:
  %cur = phi i8* [ %sect_base, %compute_start ], [ %cur_next, %loop_inc ]
  %va.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %loop_inc, label %check_limit

check_limit:
  %vs.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vs.ptr = bitcast i8* %vs.ptr.i8 to i32*
  %vs32 = load i32, i32* %vs.ptr, align 1
  %limit32 = add i32 %va32, %vs32
  %limit64 = zext i32 %limit32 to i64
  %rva_lt_limit = icmp ult i64 %rva, %limit64
  br i1 %rva_lt_limit, label %ret_success, label %loop_inc

loop_inc:
  %cur_next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %cur_next, %end
  br i1 %done, label %ret0, label %loop_body

ret_success:
  ret i32 %soh32

ret0:
  ret i32 0
}