; ModuleID = 'pe_section_lookup'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

declare i64 @strlen(i8* noundef)
declare i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define i8* @sub_140002570(i8* noundef %rcx) {
entry:
  %len = call i64 @strlen(i8* %rcx)
  %cmplen = icmp ugt i64 %len, 8
  br i1 %cmplen, label %ret0, label %check_mz

check_mz:
  %base = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %have_dos, label %ret0

have_dos:
  %eoff_ptr_i8 = getelementptr i8, i8* %base, i64 60
  %eoff_ptr = bitcast i8* %eoff_ptr_i8 to i32*
  %eoff = load i32, i32* %eoff_ptr, align 1
  %eoff_sext = sext i32 %eoff to i64
  %nt = getelementptr i8, i8* %base, i64 %eoff_sext
  %pesig_ptr = bitcast i8* %nt to i32*
  %pesig = load i32, i32* %pesig_ptr, align 1
  %pe_ok = icmp eq i32 %pesig, 17744
  br i1 %pe_ok, label %check_magic, label %ret0

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %check_numsec, label %ret0

check_numsec:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %has_sections = icmp ne i16 %numsec, 0
  br i1 %has_sections, label %compute_first_section, label %ret0

compute_first_section:
  %soh_ptr_i8 = getelementptr i8, i8* %nt, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh = load i16, i16* %soh_ptr, align 1
  %soh_zext = zext i16 %soh to i64
  %first_off = add i64 %soh_zext, 24
  %first_sec = getelementptr i8, i8* %nt, i64 %first_off
  %numsec_zext32 = zext i16 %numsec to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %compute_first_section ], [ %i_next, %cont ]
  %sec_ptr = phi i8* [ %first_sec, %compute_first_section ], [ %sec_next, %cont ]
  %cmpres = call i32 @strncmp(i8* %sec_ptr, i8* %rcx, i64 8)
  %is_equal = icmp eq i32 %cmpres, 0
  br i1 %is_equal, label %found, label %cont

cont:
  %i_next = add i32 %i, 1
  %sec_next = getelementptr i8, i8* %sec_ptr, i64 40
  %cont_cond = icmp ult i32 %i_next, %numsec_zext32
  br i1 %cont_cond, label %loop, label %ret0

found:
  ret i8* %sec_ptr

ret0:
  ret i8* null
}