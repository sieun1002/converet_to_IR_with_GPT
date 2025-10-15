; ModuleID = 'pe_section_lookup'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

declare dllimport i64 @strlen(i8* noundef)
declare dllimport i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define dso_local i8* @sub_140002570(i8* noundef %name) local_unnamed_addr {
entry:
  %len = call i64 @strlen(i8* %name)
  %len_ok = icmp ule i64 %len, 8
  br i1 %len_ok, label %check_mz, label %return_null

check_mz:
  %base = load i8*, i8** @off_1400043A0, align 8
  %magic.ptr = bitcast i8* %base to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is_mz = icmp eq i16 %magic, 23117
  br i1 %is_mz, label %after_mz, label %return_null

after_mz:
  %e_lfanew.ptr.i8 = getelementptr inbounds i8, i8* %base, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.z = zext i32 %e_lfanew to i64
  %nt.i8 = getelementptr inbounds i8, i8* %base, i64 %e_lfanew.z
  %pe.ptr = bitcast i8* %nt.i8 to i32*
  %pe = load i32, i32* %pe.ptr, align 1
  %is_pe = icmp eq i32 %pe, 17744
  br i1 %is_pe, label %check_opt_magic, label %return_null

check_opt_magic:
  %opt_magic.ptr.i8 = getelementptr inbounds i8, i8* %nt.i8, i64 24
  %opt_magic.ptr = bitcast i8* %opt_magic.ptr.i8 to i16*
  %opt_magic = load i16, i16* %opt_magic.ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %check_num_sections, label %return_null

check_num_sections:
  %numsec.ptr.i8 = getelementptr inbounds i8, i8* %nt.i8, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec = load i16, i16* %numsec.ptr, align 1
  %has_sections = icmp ne i16 %numsec, 0
  br i1 %has_sections, label %prepare_loop, label %return_null

prepare_loop:
  %sizeopt.ptr.i8 = getelementptr inbounds i8, i8* %nt.i8, i64 20
  %sizeopt.ptr = bitcast i8* %sizeopt.ptr.i8 to i16*
  %sizeopt = load i16, i16* %sizeopt.ptr, align 1
  %sizeopt.z = zext i16 %sizeopt to i64
  %sect.start = getelementptr inbounds i8, i8* %nt.i8, i64 24
  %sect.base = getelementptr inbounds i8, i8* %sect.start, i64 %sizeopt.z
  %numsec.z = zext i16 %numsec to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %prepare_loop ], [ %i.next, %loop_inc ]
  %cur = phi i8* [ %sect.base, %prepare_loop ], [ %cur.next, %loop_inc ]
  %cmpres = call i32 @strncmp(i8* %cur, i8* %name, i64 8)
  %iszero = icmp eq i32 %cmpres, 0
  br i1 %iszero, label %found, label %loop_inc

loop_inc:
  %i.next = add i32 %i, 1
  %cur.next = getelementptr inbounds i8, i8* %cur, i64 40
  %cont = icmp ult i32 %i.next, %numsec.z
  br i1 %cont, label %loop, label %return_null

found:
  ret i8* %cur

return_null:
  ret i8* null
}