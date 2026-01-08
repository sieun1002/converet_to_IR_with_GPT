target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @sub_140002700(i8*)
declare i32 @sub_140002708(i8*, i8*, i64)

define i8* @sub_1400021B0(i8* %0) {
entry:
  %len = call i64 @sub_140002700(i8* %0)
  %cmp_len = icmp ugt i64 %len, 8
  br i1 %cmp_len, label %fail, label %after_len

after_len:                                        ; preds = %entry
  %dos_base.ptr = load i8*, i8** @off_1400043C0
  %mz.ptr = bitcast i8* %dos_base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %check_pe, label %fail

check_pe:                                         ; preds = %after_len
  %e_lfanew.ptr = getelementptr i8, i8* %dos_base.ptr, i64 60
  %e_lfanew.i32ptr = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew.i32ptr, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %pe_base = getelementptr i8, i8* %dos_base.ptr, i64 %e_lfanew.sext
  %pe_sig.ptr = bitcast i8* %pe_base to i32*
  %pe_sig = load i32, i32* %pe_sig.ptr, align 1
  %pe_sig_ok = icmp eq i32 %pe_sig, 17744
  br i1 %pe_sig_ok, label %check_magic, label %fail

check_magic:                                      ; preds = %check_pe
  %opt_magic.ptr = getelementptr i8, i8* %pe_base, i64 24
  %opt_magic.i16ptr = bitcast i8* %opt_magic.ptr to i16*
  %opt_magic = load i16, i16* %opt_magic.i16ptr, align 1
  %opt_magic_ok = icmp eq i16 %opt_magic, 523
  br i1 %opt_magic_ok, label %check_numsec, label %fail

check_numsec:                                     ; preds = %check_magic
  %numsec.ptr = getelementptr i8, i8* %pe_base, i64 6
  %numsec.i16ptr = bitcast i8* %numsec.ptr to i16*
  %numsec.i16 = load i16, i16* %numsec.i16ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec.i16, 0
  br i1 %numsec_is_zero, label %fail, label %setup_loop

setup_loop:                                       ; preds = %check_numsec
  %szopt.ptr = getelementptr i8, i8* %pe_base, i64 20
  %szopt.i16ptr = bitcast i8* %szopt.ptr to i16*
  %szopt.i16 = load i16, i16* %szopt.i16ptr, align 1
  %szopt.zext = zext i16 %szopt.i16 to i64
  %sec_start.off = add i64 %szopt.zext, 24
  %sec_ptr.init = getelementptr i8, i8* %pe_base, i64 %sec_start.off
  br label %loop_head

loop_head:                                        ; preds = %loop_latch, %setup_loop
  %sec_ptr = phi i8* [ %sec_ptr.init, %setup_loop ], [ %sec_ptr.next, %loop_latch ]
  %idx = phi i32 [ 0, %setup_loop ], [ %idx.next, %loop_latch ]
  %call = call i32 @sub_140002708(i8* %sec_ptr, i8* %0, i64 8)
  %is_zero = icmp eq i32 %call, 0
  br i1 %is_zero, label %ret_found, label %loop_latch

loop_latch:                                       ; preds = %loop_head
  %numsec2.ptr = getelementptr i8, i8* %pe_base, i64 6
  %numsec2.i16ptr = bitcast i8* %numsec2.ptr to i16*
  %numsec2.i16 = load i16, i16* %numsec2.i16ptr, align 1
  %numsec2 = zext i16 %numsec2.i16 to i32
  %idx.next = add i32 %idx, 1
  %sec_ptr.next = getelementptr i8, i8* %sec_ptr, i64 40
  %cont = icmp ult i32 %idx.next, %numsec2
  br i1 %cont, label %loop_head, label %fail

ret_found:                                        ; preds = %loop_head
  ret i8* %sec_ptr

fail:                                             ; preds = %loop_latch, %check_numsec, %check_magic, %check_pe, %after_len, %entry
  ret i8* null
}