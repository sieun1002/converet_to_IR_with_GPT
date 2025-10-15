; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare i64 @strlen(i8* noundef)
declare i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define i8* @sub_140002570(i8* noundef %name) nounwind {
entry:
  %len = call i64 @strlen(i8* %name)
  %gt8 = icmp ugt i64 %len, 8
  br i1 %gt8, label %return_null, label %check_mz

return_null:
  ret i8* null

check_mz:
  %base = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mzval = load i16, i16* %mzptr, align 1
  %mz_ok = icmp eq i16 %mzval, 23117
  br i1 %mz_ok, label %read_nt, label %return_null

read_nt:
  %lfanew_ptr_i8 = getelementptr i8, i8* %base, i64 60
  %lfanew_ptr = bitcast i8* %lfanew_ptr_i8 to i32*
  %lfanew32 = load i32, i32* %lfanew_ptr, align 1
  %lfanew = sext i32 %lfanew32 to i64
  %nt_hdr = getelementptr i8, i8* %base, i64 %lfanew
  %sig_ptr = bitcast i8* %nt_hdr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %return_null

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %check_sections, label %return_null

check_sections:
  %numsect_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 6
  %numsect_ptr = bitcast i8* %numsect_ptr_i8 to i16*
  %numsects16 = load i16, i16* %numsect_ptr, align 1
  %numsects_zero = icmp eq i16 %numsects16, 0
  br i1 %numsects_zero, label %return_null, label %have_sections

have_sections:
  %opt_size_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 20
  %opt_size_ptr = bitcast i8* %opt_size_ptr_i8 to i16*
  %opt_size16 = load i16, i16* %opt_size_ptr, align 1
  %numsects = zext i16 %numsects16 to i32
  %opt_size = zext i16 %opt_size16 to i64
  %sect0_off = add i64 %opt_size, 24
  %sect_ptr = getelementptr i8, i8* %nt_hdr, i64 %sect0_off
  br label %loop

loop:
  %i = phi i32 [ 0, %have_sections ], [ %i.next, %cont ]
  %cur = phi i8* [ %sect_ptr, %have_sections ], [ %cur.next, %cont ]
  %cmp = call i32 @strncmp(i8* %cur, i8* %name, i64 8)
  %eq = icmp eq i32 %cmp, 0
  br i1 %eq, label %found, label %cont

found:
  ret i8* %cur

cont:
  %i.next = add i32 %i, 1
  %cur.next = getelementptr i8, i8* %cur, i64 40
  %more = icmp ult i32 %i.next, %numsects
  br i1 %more, label %loop, label %return_null
}