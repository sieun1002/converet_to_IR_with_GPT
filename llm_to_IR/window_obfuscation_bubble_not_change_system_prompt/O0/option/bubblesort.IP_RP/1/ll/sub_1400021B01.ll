; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @sub_140002700(i8*)
declare i32 @loc_140002705(i8*, i8*, i32)

define i8* @sub_1400021B0(i8* %0) {
entry:
  %call0 = call i64 @sub_140002700(i8* %0)
  %cmp0 = icmp ugt i64 %call0, 8
  br i1 %cmp0, label %ret_zero, label %after_cmp8

after_cmp8:
  %baseptr_loadptr = load i8*, i8** @off_1400043C0, align 8
  %base_i16ptr = bitcast i8* %baseptr_loadptr to i16*
  %mz = load i16, i16* %base_i16ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %has_mz, label %ret_zero

has_mz:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr_loadptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew_i32 = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_i64 = sext i32 %e_lfanew_i32 to i64
  %nt_base = getelementptr i8, i8* %baseptr_loadptr, i64 %e_lfanew_i64
  %sig_ptr = bitcast i8* %nt_base to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_zero

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt_base, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_20b = icmp eq i16 %magic, 523
  br i1 %is_20b, label %check_numsec, label %ret_zero

check_numsec:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_base, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %is_zero = icmp eq i16 %numsec, 0
  br i1 %is_zero, label %ret_zero, label %setup_loop

setup_loop:
  %sizeopt_ptr_i8 = getelementptr i8, i8* %nt_base, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_ptr_i8 to i16*
  %sizeopt = load i16, i16* %sizeopt_ptr, align 1
  %sizeopt_zext = zext i16 %sizeopt to i64
  %sect0_off = add i64 %sizeopt_zext, 24
  %sect_ptr = getelementptr i8, i8* %nt_base, i64 %sect0_off
  br label %loop

loop:
  %idx = phi i32 [ 0, %setup_loop ], [ %idx.next, %loop_cont ]
  %cur = phi i8* [ %sect_ptr, %setup_loop ], [ %next, %loop_cont ]
  %call2 = call i32 @loc_140002705(i8* %cur, i8* %0, i32 8)
  %is_zero2 = icmp eq i32 %call2, 0
  br i1 %is_zero2, label %ret_found, label %loop_cont

ret_found:
  ret i8* %cur

loop_cont:
  %numsec2_ptr_i8 = getelementptr i8, i8* %nt_base, i64 6
  %numsec2_ptr = bitcast i8* %numsec2_ptr_i8 to i16*
  %numsec2 = load i16, i16* %numsec2_ptr, align 1
  %idx.next = add i32 %idx, 1
  %next = getelementptr i8, i8* %cur, i64 40
  %numsec2_i32 = zext i16 %numsec2 to i32
  %cmpjb = icmp ult i32 %idx.next, %numsec2_i32
  br i1 %cmpjb, label %loop, label %ret_zero

ret_zero:
  ret i8* null
}