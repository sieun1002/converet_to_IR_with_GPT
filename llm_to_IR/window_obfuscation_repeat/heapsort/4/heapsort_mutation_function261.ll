; ModuleID = 'pe_section_lookup'
target triple = "x86_64-pc-windows-msvc"

define dso_local i8* @sub_140002520(i8* %rcx, i64 %rdx) {
entry:
  %base_plus_3c.i8 = getelementptr inbounds i8, i8* %rcx, i64 60
  %base_plus_3c.i32p = bitcast i8* %base_plus_3c.i8 to i32*
  %e_lfanew.i32 = load i32, i32* %base_plus_3c.i32p, align 1
  %e_lfanew.i64 = sext i32 %e_lfanew.i32 to i64
  %nt = getelementptr inbounds i8, i8* %rcx, i64 %e_lfanew.i64
  %num_sec_ptr.i8 = getelementptr inbounds i8, i8* %nt, i64 6
  %num_sec_ptr = bitcast i8* %num_sec_ptr.i8 to i16*
  %num_sec.u16 = load i16, i16* %num_sec_ptr, align 1
  %is_zero = icmp eq i16 %num_sec.u16, 0
  br i1 %is_zero, label %ret_zero, label %cont

cont:
  %soh_ptr.i8 = getelementptr inbounds i8, i8* %nt, i64 20
  %soh_ptr = bitcast i8* %soh_ptr.i8 to i16*
  %soh.u16 = load i16, i16* %soh_ptr, align 1
  %soh.zext = zext i16 %soh.u16 to i64
  %after_opt = getelementptr inbounds i8, i8* %nt, i64 24
  %first_section = getelementptr inbounds i8, i8* %after_opt, i64 %soh.zext
  %n.zext = zext i16 %num_sec.u16 to i64
  %mul40 = mul nuw nsw i64 %n.zext, 40
  %end_ptr = getelementptr inbounds i8, i8* %first_section, i64 %mul40
  br label %loop

loop:
  %cur = phi i8* [ %first_section, %cont ], [ %next_section, %loop_continue ]
  %cmp_end = icmp eq i8* %cur, %end_ptr
  br i1 %cmp_end, label %ret_zero, label %loop_body

loop_body:
  %va_ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr.i8 to i32*
  %va.u32 = load i32, i32* %va_ptr, align 1
  %va.zext = zext i32 %va.u32 to i64
  %cmp_rdx_va = icmp ult i64 %rdx, %va.zext
  br i1 %cmp_rdx_va, label %loop_continue, label %ge_va

ge_va:
  %vs_ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vs_ptr = bitcast i8* %vs_ptr.i8 to i32*
  %vs.u32 = load i32, i32* %vs_ptr, align 1
  %vs.zext = zext i32 %vs.u32 to i64
  %va_plus_vs = add i64 %va.zext, %vs.zext
  %in_range = icmp ult i64 %rdx, %va_plus_vs
  br i1 %in_range, label %ret_cur, label %loop_continue

loop_continue:
  %next_section = getelementptr inbounds i8, i8* %cur, i64 40
  br label %loop

ret_cur:
  ret i8* %cur

ret_zero:
  ret i8* null
}