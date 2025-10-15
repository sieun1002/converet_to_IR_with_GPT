; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i32 @sub_140002730(i8* %p) local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzwptr = bitcast i8* %baseptr to i16*
  %mzval = load i16, i16* %mzwptr, align 1
  %cmpmz = icmp eq i16 %mzval, 23117
  br i1 %cmpmz, label %check_pe, label %ret0

check_pe:                                            ; preds = %entry
  %off_ptr = getelementptr i8, i8* %baseptr, i64 60
  %off32ptr = bitcast i8* %off_ptr to i32*
  %off32 = load i32, i32* %off32ptr, align 1
  %off64 = sext i32 %off32 to i64
  %ntptr = getelementptr i8, i8* %baseptr, i64 %off64
  %peptr = bitcast i8* %ntptr to i32*
  %pesig = load i32, i32* %peptr, align 1
  %cmppe = icmp eq i32 %pesig, 17744
  br i1 %cmppe, label %check_magic, label %ret0

check_magic:                                         ; preds = %check_pe
  %optmagicptr_i8 = getelementptr i8, i8* %ntptr, i64 24
  %optmagicptr = bitcast i8* %optmagicptr_i8 to i16*
  %optmagic = load i16, i16* %optmagicptr, align 1
  %ispe32plus = icmp eq i16 %optmagic, 523
  br i1 %ispe32plus, label %load_sections, label %ret0

load_sections:                                       ; preds = %check_magic
  %numsecptr_i8 = getelementptr i8, i8* %ntptr, i64 6
  %numsecptr = bitcast i8* %numsecptr_i8 to i16*
  %numsec = load i16, i16* %numsecptr, align 1
  %isz = icmp eq i16 %numsec, 0
  br i1 %isz, label %ret0, label %cont

cont:                                                ; preds = %load_sections
  %soh_ptr_i8 = getelementptr i8, i8* %ntptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh = load i16, i16* %soh_ptr, align 1
  %p_i64 = ptrtoint i8* %p to i64
  %base_i64 = ptrtoint i8* %baseptr to i64
  %rva = sub i64 %p_i64, %base_i64
  %soh_zext = zext i16 %soh to i64
  %firstsec_off = add i64 %soh_zext, 24
  %firstsec_ptr = getelementptr i8, i8* %ntptr, i64 %firstsec_off
  %numsec_z = zext i16 %numsec to i64
  %secsize = mul i64 %numsec_z, 40
  %end_ptr = getelementptr i8, i8* %firstsec_ptr, i64 %secsize
  br label %loop

loop:                                                ; preds = %loop_next, %cont
  %phi_p = phi i8* [ %firstsec_ptr, %cont ], [ %next_p, %loop_next ]
  %cmp_end = icmp eq i8* %phi_p, %end_ptr
  br i1 %cmp_end, label %ret0, label %in_loop

in_loop:                                             ; preds = %loop
  %va_ptr_i8 = getelementptr i8, i8* %phi_p, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 1
  %va_z = zext i32 %va to i64
  %cmp_lt_va = icmp ult i64 %rva, %va_z
  br i1 %cmp_lt_va, label %loop_next, label %check_within

check_within:                                        ; preds = %in_loop
  %vs_ptr_i8 = getelementptr i8, i8* %phi_p, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs = load i32, i32* %vs_ptr, align 1
  %vs_z = zext i32 %vs to i64
  %va_plus_vs = add i64 %va_z, %vs_z
  %cmp_in = icmp ult i64 %rva, %va_plus_vs
  br i1 %cmp_in, label %found, label %loop_next

loop_next:                                           ; preds = %check_within, %in_loop
  %next_p = getelementptr i8, i8* %phi_p, i64 40
  br label %loop

found:                                               ; preds = %check_within
  %ch_ptr_i8 = getelementptr i8, i8* %phi_p, i64 36
  %ch_ptr = bitcast i8* %ch_ptr_i8 to i32*
  %ch = load i32, i32* %ch_ptr, align 1
  %notch = xor i32 %ch, -1
  %shr = lshr i32 %notch, 31
  ret i32 %shr

ret0:                                                ; preds = %loop, %cont, %load_sections, %check_magic, %check_pe, %entry
  ret i32 0
}