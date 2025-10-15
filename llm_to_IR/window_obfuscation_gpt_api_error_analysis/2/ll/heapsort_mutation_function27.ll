; ModuleID = 'pe_section_lookup.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare i64 @strlen(i8* noundef)
declare i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define i8* @sub_140002570(i8* noundef %name) {
entry:
  %len = call i64 @strlen(i8* noundef %name)
  %cmp_len = icmp ugt i64 %len, 8
  br i1 %cmp_len, label %fail, label %check_base

check_base:
  %baseptr_addr = load i8*, i8** @off_1400043A0
  %mzptr = bitcast i8* %baseptr_addr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_nt, label %fail

check_nt:
  %elfanew_off_ptr_i8 = getelementptr inbounds i8, i8* %baseptr_addr, i64 60
  %elfanew_off_ptr = bitcast i8* %elfanew_off_ptr_i8 to i32*
  %elfanew_off32 = load i32, i32* %elfanew_off_ptr, align 1
  %elfanew_off64 = sext i32 %elfanew_off32 to i64
  %nthdr = getelementptr inbounds i8, i8* %baseptr_addr, i64 %elfanew_off64
  %sig_ptr = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %fail

check_magic:
  %magic_ptr_i8 = getelementptr inbounds i8, i8* %nthdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %check_sections_nonzero, label %fail

check_sections_nonzero:
  %numsec_ptr_i8 = getelementptr inbounds i8, i8* %nthdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %is_zero = icmp eq i16 %numsec16, 0
  br i1 %is_zero, label %fail, label %prep_loop

prep_loop:
  %soo_ptr_i8 = getelementptr inbounds i8, i8* %nthdr, i64 20
  %soo_ptr = bitcast i8* %soo_ptr_i8 to i16*
  %soo16 = load i16, i16* %soo_ptr, align 1
  %soo64 = zext i16 %soo16 to i64
  %baseoff = add i64 %soo64, 24
  %first_sec = getelementptr inbounds i8, i8* %nthdr, i64 %baseoff
  %numsec32 = zext i16 %numsec16 to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %prep_loop ], [ %i_next, %after_compare ]
  %curr = phi i8* [ %first_sec, %prep_loop ], [ %next, %after_compare ]
  %cmpcall = call i32 @strncmp(i8* noundef %curr, i8* noundef %name, i64 noundef 8)
  %is_eq = icmp eq i32 %cmpcall, 0
  br i1 %is_eq, label %ret_match, label %after_compare

after_compare:
  %i_next = add nuw nsw i32 %i, 1
  %next = getelementptr inbounds i8, i8* %curr, i64 40
  %cont = icmp ult i32 %i_next, %numsec32
  br i1 %cont, label %loop, label %fail

ret_match:
  ret i8* %curr

fail:
  ret i8* null
}