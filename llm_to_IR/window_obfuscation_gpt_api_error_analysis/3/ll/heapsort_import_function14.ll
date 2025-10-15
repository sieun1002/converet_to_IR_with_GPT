; ModuleID = 'sub_140002610.ll'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002610(i8* %rcx_arg) local_unnamed_addr nounwind {
entry:
  %base_ptr_ptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base_ptr_ptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base_ptr_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew to i64
  %nt_i8 = getelementptr i8, i8* %base_ptr_ptr, i64 %e_lfanew64
  %pe_sig_ptr = bitcast i8* %nt_i8 to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %pe_ok = icmp eq i32 %pe_sig, 17744
  br i1 %pe_ok, label %check_opt_magic, label %ret0

check_opt_magic:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nt_i8, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %load_counts, label %ret0

load_counts:
  %numsecs_ptr_i8 = getelementptr i8, i8* %nt_i8, i64 6
  %numsecs_ptr = bitcast i8* %numsecs_ptr_i8 to i16*
  %numsecs16 = load i16, i16* %numsecs_ptr, align 1
  %numsecs_is_zero = icmp eq i16 %numsecs16, 0
  br i1 %numsecs_is_zero, label %ret0, label %setup

setup:
  %sizeopt_ptr_i8 = getelementptr i8, i8* %nt_i8, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_ptr_i8 to i16*
  %sizeopt16 = load i16, i16* %sizeopt_ptr, align 1
  %rcx_int = ptrtoint i8* %rcx_arg to i64
  %base_int = ptrtoint i8* %base_ptr_ptr to i64
  %offset = sub i64 %rcx_int, %base_int
  %sizeopt_zext = zext i16 %sizeopt16 to i64
  %sectab_start_i8 = getelementptr i8, i8* %nt_i8, i64 24
  %sectab_start_pre = getelementptr i8, i8* %sectab_start_i8, i64 %sizeopt_zext
  %numsecs_zext = zext i16 %numsecs16 to i64
  %nbytes = mul nuw i64 %numsecs_zext, 40
  %sectab_end = getelementptr i8, i8* %sectab_start_pre, i64 %nbytes
  br label %loop

loop:
  %cur = phi i8* [ %sectab_start_pre, %setup ], [ %cur_next, %inc ]
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %offset_lt_va = icmp ult i64 %offset, %va64
  br i1 %offset_lt_va, label %inc, label %check_range

check_range:
  %vsize_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %vsize64 = zext i32 %vsize32 to i64
  %va_plus_vsize = add i64 %va64, %vsize64
  %inrange = icmp ult i64 %offset, %va_plus_vsize
  br i1 %inrange, label %ret0, label %inc

inc:
  %cur_next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %cur_next, %sectab_end
  br i1 %done, label %end, label %loop

end:
  br label %ret0

ret0:
  ret i32 0
}