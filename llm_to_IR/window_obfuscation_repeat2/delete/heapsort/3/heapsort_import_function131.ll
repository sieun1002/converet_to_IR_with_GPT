; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

declare i64 @sub_140002AC0()
declare i32 @sub_140002AC8(i8*, i8*, i32)

@off_1400043A0 = external global i8*, align 8

define i8* @sub_140002570(i8* %arg) {
entry:
  %call1 = call i64 @sub_140002AC0()
  %cmp1 = icmp ugt i64 %call1, 8
  br i1 %cmp1, label %fail, label %after_cmp

after_cmp:
  %base = load i8*, i8** @off_1400043A0, align 8
  %base_i16ptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %base_i16ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %good_mz, label %fail

good_mz:
  %off_3c_ptr = getelementptr i8, i8* %base, i64 60
  %off_3c_i32ptr = bitcast i8* %off_3c_ptr to i32*
  %e_lfanew = load i32, i32* %off_3c_i32ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base, i64 %e_lfanew_sext
  %nt_i32ptr = bitcast i8* %nt to i32*
  %pe_sig = load i32, i32* %nt_i32ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %chk_opt, label %fail

chk_opt:
  %opt_magic_ptr8 = getelementptr i8, i8* %nt, i64 24
  %opt_magic_i16ptr = bitcast i8* %opt_magic_ptr8 to i16*
  %opt_magic = load i16, i16* %opt_magic_i16ptr, align 1
  %is_peplus = icmp eq i16 %opt_magic, 523
  br i1 %is_peplus, label %chk_sections_nonzero, label %fail

chk_sections_nonzero:
  %numsec_ptr8 = getelementptr i8, i8* %nt, i64 6
  %numsec_i16ptr = bitcast i8* %numsec_ptr8 to i16*
  %numsec = load i16, i16* %numsec_i16ptr, align 1
  %is_zero = icmp eq i16 %numsec, 0
  br i1 %is_zero, label %fail, label %setup_loop

setup_loop:
  %opt_size_ptr8 = getelementptr i8, i8* %nt, i64 20
  %opt_size_i16ptr = bitcast i8* %opt_size_ptr8 to i16*
  %opt_size_w = load i16, i16* %opt_size_i16ptr, align 1
  %opt_size_zext = zext i16 %opt_size_w to i64
  %rbx_init_off = add i64 %opt_size_zext, 24
  %secptr_init = getelementptr i8, i8* %nt, i64 %rbx_init_off
  %numsec32 = zext i16 %numsec to i32
  br label %loop

loop:
  %rbx_phi = phi i8* [ %secptr_init, %setup_loop ], [ %rbx_next, %inc ]
  %i_phi = phi i32 [ 0, %setup_loop ], [ %i_next, %inc ]
  %call2 = call i32 @sub_140002AC8(i8* %rbx_phi, i8* %arg, i32 8)
  %is_zero2 = icmp eq i32 %call2, 0
  br i1 %is_zero2, label %ret_rbx, label %inc

ret_rbx:
  ret i8* %rbx_phi

inc:
  %i_next = add i32 %i_phi, 1
  %rbx_next = getelementptr i8, i8* %rbx_phi, i64 40
  %cond = icmp ult i32 %i_next, %numsec32
  br i1 %cond, label %loop, label %fail

fail:
  ret i8* null
}