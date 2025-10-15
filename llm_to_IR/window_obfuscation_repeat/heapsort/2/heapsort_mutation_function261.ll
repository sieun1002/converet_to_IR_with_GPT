; ModuleID = 'pe_section_lookup'
source_filename = "pe_section_lookup.ll"
target triple = "x86_64-pc-windows-msvc"

define dso_local i8* @sub_140002520(i8* %base, i64 %rva) local_unnamed_addr {
entry:
  %p_e_lfanew_i8 = getelementptr i8, i8* %base, i64 60
  %p_e_lfanew_i32ptr = bitcast i8* %p_e_lfanew_i8 to i32*
  %e_lfanew_i32 = load i32, i32* %p_e_lfanew_i32ptr, align 1
  %e_lfanew_i64 = sext i32 %e_lfanew_i32 to i64
  %p_nt = getelementptr i8, i8* %base, i64 %e_lfanew_i64
  %numsecs_ptr_i8 = getelementptr i8, i8* %p_nt, i64 6
  %numsecs_ptr_i16 = bitcast i8* %numsecs_ptr_i8 to i16*
  %numsecs_i16 = load i16, i16* %numsecs_ptr_i16, align 1
  %numsecs_is_zero = icmp eq i16 %numsecs_i16, 0
  br i1 %numsecs_is_zero, label %ret_zero, label %setup

setup:
  %soh_ptr_i8 = getelementptr i8, i8* %p_nt, i64 20
  %soh_ptr_i16 = bitcast i8* %soh_ptr_i8 to i16*
  %soh_i16 = load i16, i16* %soh_ptr_i16, align 1
  %soh_i64 = zext i16 %soh_i16 to i64
  %first_off = add i64 %soh_i64, 24
  %p_first = getelementptr i8, i8* %p_nt, i64 %first_off
  %numsecs_i32 = zext i16 %numsecs_i16 to i32
  %dec_i32 = add i32 %numsecs_i32, -1
  %times4_i32 = mul i32 %dec_i32, 4
  %sum5_i32 = add i32 %dec_i32, %times4_i32
  %sum5_i64 = zext i32 %sum5_i32 to i64
  %scaled_i64 = shl i64 %sum5_i64, 3
  %end_off = add i64 %scaled_i64, 40
  %p_end = getelementptr i8, i8* %p_first, i64 %end_off
  br label %loop

loop:
  %cur = phi i8* [ %p_first, %setup ], [ %next, %cont ]
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr_i32 = bitcast i8* %va_ptr_i8 to i32*
  %va_i32 = load i32, i32* %va_ptr_i32, align 1
  %va_i64 = zext i32 %va_i32 to i64
  %rva_below_va = icmp ult i64 %rva, %va_i64
  br i1 %rva_below_va, label %cont, label %check_inside

check_inside:
  %vsz_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vsz_ptr_i32 = bitcast i8* %vsz_ptr_i8 to i32*
  %vsz_i32 = load i32, i32* %vsz_ptr_i32, align 1
  %end32_i32 = add i32 %va_i32, %vsz_i32
  %end32_i64 = zext i32 %end32_i32 to i64
  %rva_inside = icmp ult i64 %rva, %end32_i64
  br i1 %rva_inside, label %ret_found, label %cont

cont:
  %next = getelementptr i8, i8* %cur, i64 40
  %at_end = icmp eq i8* %next, %p_end
  br i1 %at_end, label %ret_zero, label %loop

ret_zero:
  ret i8* null

ret_found:
  ret i8* %cur
}