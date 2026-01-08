; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @sub_140002700()
declare i32 @sub_140002708(i8*, i8*, i64)

define i8* @sub_1400021B0(i8* %rcx) {
entry:
  %call0 = call i64 @sub_140002700()
  %cmp0 = icmp ugt i64 %call0, 8
  br i1 %cmp0, label %ret_zero, label %after_ja

after_ja:
  %base_ptr = load i8*, i8** @off_1400043C0
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %mz_good, label %ret_zero

mz_good:
  %elfanew_i8 = getelementptr i8, i8* %base_ptr, i64 60
  %elfanew_i32p = bitcast i8* %elfanew_i8 to i32*
  %elfanew32 = load i32, i32* %elfanew_i32p
  %elfanew64 = sext i32 %elfanew32 to i64
  %pehdr = getelementptr i8, i8* %base_ptr, i64 %elfanew64
  %pe_sig_ptr = bitcast i8* %pehdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr
  %pe_ok = icmp eq i32 %pe_sig, 17744
  br i1 %pe_ok, label %pe_good, label %ret_zero

pe_good:
  %opt_magic_i8 = getelementptr i8, i8* %pehdr, i64 24
  %opt_magic_p = bitcast i8* %opt_magic_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_p
  %is_pe32p = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32p, label %magic_good, label %ret_zero

magic_good:
  %numsec_i8 = getelementptr i8, i8* %pehdr, i64 6
  %numsec_p = bitcast i8* %numsec_i8 to i16*
  %numsec16 = load i16, i16* %numsec_p
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret_zero, label %prep_loop

prep_loop:
  %soh_i8 = getelementptr i8, i8* %pehdr, i64 20
  %soh_p = bitcast i8* %soh_i8 to i16*
  %soh16 = load i16, i16* %soh_p
  %soh64 = zext i16 %soh16 to i64
  %sec0_off = add i64 %soh64, 24
  %sec_cur = getelementptr i8, i8* %pehdr, i64 %sec0_off
  %nsec = zext i16 %numsec16 to i32
  br label %loop_header

loop_header:
  %i = phi i32 [ 0, %prep_loop ], [ %inext, %after_test ]
  %rbx_cur = phi i8* [ %sec_cur, %prep_loop ], [ %rbx_next, %after_test ]
  %call1 = call i32 @sub_140002708(i8* %rbx_cur, i8* %rcx, i64 8)
  %is_zero = icmp eq i32 %call1, 0
  br i1 %is_zero, label %found, label %after_test

after_test:
  %inext = add i32 %i, 1
  %rbx_next = getelementptr i8, i8* %rbx_cur, i64 40
  %cont = icmp ult i32 %inext, %nsec
  br i1 %cont, label %loop_header, label %ret_zero

found:
  ret i8* %rbx_cur

ret_zero:
  ret i8* null
}