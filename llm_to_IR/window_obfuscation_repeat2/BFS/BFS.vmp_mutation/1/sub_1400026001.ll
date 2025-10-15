; ModuleID = 'pe_section_lookup'
target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002600(i8* %rcx, i64 %rdx) {
entry:
  %p_e = getelementptr i8, i8* %rcx, i64 60
  %p_e_i32 = bitcast i8* %p_e to i32*
  %e32 = load i32, i32* %p_e_i32, align 1
  %e64 = sext i32 %e32 to i64
  %nthdr = getelementptr i8, i8* %rcx, i64 %e64
  %p_num = getelementptr i8, i8* %nthdr, i64 6
  %p_num_i16 = bitcast i8* %p_num to i16*
  %num16 = load i16, i16* %p_num_i16, align 1
  %iszero = icmp eq i16 %num16, 0
  br i1 %iszero, label %notfound, label %cont

cont:                                             ; preds = %entry
  %p_opt = getelementptr i8, i8* %nthdr, i64 20
  %p_opt_i16 = bitcast i8* %p_opt to i16*
  %opt16 = load i16, i16* %p_opt_i16, align 1
  %opt64 = zext i16 %opt16 to i64
  %first_off = add i64 %opt64, 24
  %first = getelementptr i8, i8* %nthdr, i64 %first_off
  %ns64 = zext i16 %num16 to i64
  %span = mul i64 %ns64, 40
  %end = getelementptr i8, i8* %first, i64 %span
  br label %loop

loop:                                             ; preds = %adv, %cont
  %cur = phi i8* [ %first, %cont ], [ %next, %adv ]
  %p_va = getelementptr i8, i8* %cur, i64 12
  %p_va_i32 = bitcast i8* %p_va to i32*
  %va32 = load i32, i32* %p_va_i32, align 1
  %va64 = zext i32 %va32 to i64
  %cmp_lt_va = icmp ult i64 %rdx, %va64
  br i1 %cmp_lt_va, label %adv, label %check_range

check_range:                                      ; preds = %loop
  %p_vs = getelementptr i8, i8* %cur, i64 8
  %p_vs_i32 = bitcast i8* %p_vs to i32*
  %vs32 = load i32, i32* %p_vs_i32, align 1
  %sum32 = add i32 %va32, %vs32
  %sum64 = zext i32 %sum32 to i64
  %in_range = icmp ult i64 %rdx, %sum64
  br i1 %in_range, label %found, label %adv

adv:                                              ; preds = %check_range, %loop
  %next = getelementptr i8, i8* %cur, i64 40
  %has_more = icmp ne i8* %next, %end
  br i1 %has_more, label %loop, label %notfound

found:                                            ; preds = %check_range
  ret i8* %cur

notfound:                                         ; preds = %adv, %entry
  ret i8* null
}