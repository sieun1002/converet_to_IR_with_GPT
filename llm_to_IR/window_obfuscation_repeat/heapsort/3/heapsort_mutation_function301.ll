; ModuleID = 'pe_section_checker'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_1400026D0(i64 %rcx) {
entry:
  %base_ptr.addr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base_ptr.addr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %after_mz, label %ret0

after_mz:
  %e_lfanew_ptr.i8 = getelementptr i8, i8* %base_ptr.addr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %base_ptr.addr, i64 %e_lfanew.sext
  %sig_ptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %after_pe, label %ret0

after_pe:
  %opt_magic_ptr.i8 = getelementptr i8, i8* %pehdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr.i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %check_sections, label %ret0

check_sections:
  %numsec_ptr.i8 = getelementptr i8, i8* %pehdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret0, label %have_sections

have_sections:
  %soh_ptr.i8 = getelementptr i8, i8* %pehdr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr.i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %opt_header_start = getelementptr i8, i8* %pehdr, i64 24
  %first_section = getelementptr i8, i8* %opt_header_start, i64 %soh64
  %numsec64 = zext i16 %numsec16 to i64
  %sections_size = mul i64 %numsec64, 40
  %end_ptr = getelementptr i8, i8* %first_section, i64 %sections_size
  br label %loop

loop:
  %cur = phi i8* [ %first_section, %have_sections ], [ %cur_next, %cont ]
  %rem = phi i64 [ %rcx, %have_sections ], [ %rem2, %cont ]
  %char_byte_ptr = getelementptr i8, i8* %cur, i64 39
  %char_byte = load i8, i8* %char_byte_ptr, align 1
  %exec_mask = and i8 %char_byte, 32
  %is_exec = icmp ne i8 %exec_mask, 0
  br i1 %is_exec, label %ifexec, label %noexec

ifexec:
  %rem_is_zero = icmp eq i64 %rem, 0
  br i1 %rem_is_zero, label %ret0, label %decbranch

decbranch:
  %rem_dec = add i64 %rem, -1
  br label %cont

noexec:
  br label %cont

cont:
  %rem2 = phi i64 [ %rem_dec, %decbranch ], [ %rem, %noexec ]
  %cur_next = getelementptr i8, i8* %cur, i64 40
  %more = icmp ne i8* %cur_next, %end_ptr
  br i1 %more, label %loop, label %end

end:
  ret i32 0

ret0:
  ret i32 0
}