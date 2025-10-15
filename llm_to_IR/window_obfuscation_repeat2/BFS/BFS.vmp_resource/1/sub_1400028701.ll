; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*

define dso_local i32 @sub_140002870(i8* %addr) {
entry:
  %base = load i8*, i8** @off_1400043C0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %check_pe, label %ret0

check_pe:
  %peoff_ptr = getelementptr i8, i8* %base, i64 60
  %peoff_ptr32 = bitcast i8* %peoff_ptr to i32*
  %peoff = load i32, i32* %peoff_ptr32, align 1
  %peoff64 = zext i32 %peoff to i64
  %nthdr = getelementptr i8, i8* %base, i64 %peoff64
  %sig_ptr = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %check_optmagic, label %ret0

check_optmagic:
  %optmagic_ptr = getelementptr i8, i8* %nthdr, i64 24
  %optmagic16_ptr = bitcast i8* %optmagic_ptr to i16*
  %optmagic = load i16, i16* %optmagic16_ptr, align 1
  %is_pe32plus = icmp eq i16 %optmagic, 523
  br i1 %is_pe32plus, label %get_sections, label %ret0

get_sections:
  %numsec_ptr_i8 = getelementptr i8, i8* %nthdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret0, label %cont_sections

cont_sections:
  %soh_ptr_i8 = getelementptr i8, i8* %nthdr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %secbase_pre = getelementptr i8, i8* %nthdr, i64 24
  %soh64 = zext i16 %soh16 to i64
  %secbase = getelementptr i8, i8* %secbase_pre, i64 %soh64
  %numsec64 = zext i16 %numsec16 to i64
  %nbytes = mul nuw i64 %numsec64, 40
  %secend = getelementptr i8, i8* %secbase, i64 %nbytes
  %addr_i64 = ptrtoint i8* %addr to i64
  %base_i64 = ptrtoint i8* %base to i64
  %rva = sub i64 %addr_i64, %base_i64
  br label %loop

loop:
  %s_cur = phi i8* [ %secbase, %cont_sections ], [ %s_next, %loop_next ]
  %done = icmp eq i8* %s_cur, %secend
  br i1 %done, label %ret0, label %process

process:
  %va_ptr_i8 = getelementptr i8, i8* %s_cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %loop_next, label %check_end

check_end:
  %vs_ptr_i8 = getelementptr i8, i8* %s_cur, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs32 = load i32, i32* %vs_ptr, align 1
  %sum32 = add i32 %va32, %vs32
  %end64 = zext i32 %sum32 to i64
  %in_range = icmp ult i64 %rva, %end64
  br i1 %in_range, label %found, label %loop_next

loop_next:
  %s_next = getelementptr i8, i8* %s_cur, i64 40
  br label %loop

found:
  %char_ptr_i8 = getelementptr i8, i8* %s_cur, i64 36
  %char_ptr = bitcast i8* %char_ptr_i8 to i32*
  %ch = load i32, i32* %char_ptr, align 1
  %notch = xor i32 %ch, -1
  %res = lshr i32 %notch, 31
  ret i32 %res

ret0:
  ret i32 0
}