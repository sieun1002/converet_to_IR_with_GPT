; ModuleID = 'sub_140002570_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*

declare i64 @strlen(i8*)
declare i32 @strncmp(i8*, i8*, i64)

define i8* @sub_140002570(i8* %str) local_unnamed_addr {
entry:
  %len = call i64 @strlen(i8* %str)
  %cmp8 = icmp ugt i64 %len, 8
  br i1 %cmp8, label %fail, label %len_ok

len_ok:
  %base = load i8*, i8** @off_1400043A0, align 8
  %p_mz = bitcast i8* %base to i16*
  %mz = load i16, i16* %p_mz, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %nt_head, label %fail

nt_head:
  %e_lfanew_ptr8 = getelementptr i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_off64 = sext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base, i64 %e_off64
  %sig_ptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %opt_magic, label %fail

opt_magic:
  %magic_ptr8 = getelementptr i8, i8* %nt, i64 24
  %magic_ptr = bitcast i8* %magic_ptr8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_20b = icmp eq i16 %magic, 523
  br i1 %is_20b, label %numsec_check, label %fail

numsec_check:
  %numsec_ptr8 = getelementptr i8, i8* %nt, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %is_zero = icmp eq i16 %numsec16, 0
  br i1 %is_zero, label %fail, label %prep_loop

prep_loop:
  %soh_ptr8 = getelementptr i8, i8* %nt, i64 20
  %soh_ptr = bitcast i8* %soh_ptr8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %start_off = add i64 %soh64, 24
  %first_sec = getelementptr i8, i8* %nt, i64 %start_off
  %numsec32 = zext i16 %numsec16 to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %prep_loop ], [ %i_next, %latch ]
  %cur = phi i8* [ %first_sec, %prep_loop ], [ %cur_next, %latch ]
  %cmpres = call i32 @strncmp(i8* %cur, i8* %str, i64 8)
  %is_eq = icmp eq i32 %cmpres, 0
  br i1 %is_eq, label %found, label %latch

latch:
  %i_next = add i32 %i, 1
  %cur_next = getelementptr i8, i8* %cur, i64 40
  %cont = icmp ult i32 %i_next, %numsec32
  br i1 %cont, label %loop, label %fail

found:
  ret i8* %cur

fail:
  ret i8* null
}