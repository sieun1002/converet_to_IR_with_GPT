; ModuleID = 'sub_140002610.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002610(i8* %rcx) {
entry:
  %rdx.loadptr = load i8*, i8** @off_1400043A0, align 8
  %p_mz_i8 = getelementptr inbounds i8, i8* %rdx.loadptr, i64 0
  %p_mz = bitcast i8* %p_mz_i8 to i16*
  %mz = load i16, i16* %p_mz, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %p_e_lfanew_i8 = getelementptr inbounds i8, i8* %rdx.loadptr, i64 60
  %p_e_lfanew = bitcast i8* %p_e_lfanew_i8 to i32*
  %e_lfanew = load i32, i32* %p_e_lfanew, align 1
  %off64 = sext i32 %e_lfanew to i64
  %r8.ptr = getelementptr inbounds i8, i8* %rdx.loadptr, i64 %off64
  %p_sig = bitcast i8* %r8.ptr to i32*
  %sig = load i32, i32* %p_sig, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:
  %p_magic_i8 = getelementptr inbounds i8, i8* %r8.ptr, i64 24
  %p_magic = bitcast i8* %p_magic_i8 to i16*
  %magic = load i16, i16* %p_magic, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %check_sections, label %ret0

check_sections:
  %p_numsec_i8 = getelementptr inbounds i8, i8* %r8.ptr, i64 6
  %p_numsec = bitcast i8* %p_numsec_i8 to i16*
  %numsec16 = load i16, i16* %p_numsec, align 1
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret0, label %setup_loop

setup_loop:
  %p_soh_i8 = getelementptr inbounds i8, i8* %r8.ptr, i64 20
  %p_soh = bitcast i8* %p_soh_i8 to i16*
  %soh16 = load i16, i16* %p_soh, align 1
  %rcx_int = ptrtoint i8* %rcx to i64
  %rdx_int = ptrtoint i8* %rdx.loadptr to i64
  %rcx_rva = sub i64 %rcx_int, %rdx_int
  %numsec32 = zext i16 %numsec16 to i32
  %numsec_minus1 = add i32 %numsec32, -1
  %tmp_mul = mul i32 %numsec_minus1, 5
  %tmp_mul64 = zext i32 %tmp_mul to i64
  %first_sect_ptr_pre = getelementptr inbounds i8, i8* %r8.ptr, i64 24
  %soh64 = zext i16 %soh16 to i64
  %first_sect_ptr = getelementptr inbounds i8, i8* %first_sect_ptr_pre, i64 %soh64
  %sections_span = mul i64 %tmp_mul64, 8
  %end_prel = getelementptr inbounds i8, i8* %first_sect_ptr, i64 %sections_span
  %end_ptr = getelementptr inbounds i8, i8* %end_prel, i64 40
  br label %loop

loop:
  %cur = phi i8* [ %first_sect_ptr, %setup_loop ], [ %next, %advance ]
  %p_va_i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %p_va = bitcast i8* %p_va_i8 to i32*
  %va = load i32, i32* %p_va, align 1
  %va64 = zext i32 %va to i64
  %cmp1 = icmp ult i64 %rcx_rva, %va64
  br i1 %cmp1, label %advance, label %check_inside

check_inside:
  %p_vs_i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %p_vs = bitcast i8* %p_vs_i8 to i32*
  %vs = load i32, i32* %p_vs, align 1
  %end32b = add i32 %va, %vs
  %end64b = zext i32 %end32b to i64
  %cmp2 = icmp ult i64 %rcx_rva, %end64b
  br i1 %cmp2, label %ret0, label %advance

advance:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end_ptr
  br i1 %done, label %return_zero, label %loop

ret0:
  ret i32 0

return_zero:
  ret i32 0
}