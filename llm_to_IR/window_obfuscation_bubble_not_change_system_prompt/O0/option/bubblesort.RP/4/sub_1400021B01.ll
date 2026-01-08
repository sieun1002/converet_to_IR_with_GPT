; ModuleID = 'sub_1400021B0.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @strlen(i8* noundef)
declare i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define dso_local i8* @sub_1400021B0(i8* noundef %str) {
entry:
  %len = call i64 @strlen(i8* %str)
  %cmp_len = icmp ugt i64 %len, 8
  br i1 %cmp_len, label %fail, label %check_mz

check_mz:
  %base_ptr = load i8*, i8** @off_1400043C0, align 8
  %mzptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %get_pe, label %fail

get_pe:
  %e_off_ptr = getelementptr i8, i8* %base_ptr, i64 60
  %e_off32ptr = bitcast i8* %e_off_ptr to i32*
  %e_off32 = load i32, i32* %e_off32ptr, align 1
  %e_off = sext i32 %e_off32 to i64
  %pehdr = getelementptr i8, i8* %base_ptr, i64 %e_off
  %pe_sig_ptr = bitcast i8* %pehdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %sig_ok = icmp eq i32 %pe_sig, 17744
  br i1 %sig_ok, label %check_magic, label %fail

check_magic:
  %opt_magic_i8 = getelementptr i8, i8* %pehdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %check_numsec, label %fail

check_numsec:
  %numsec_i8 = getelementptr i8, i8* %pehdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_i8 to i16*
  %numsec_val = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec_val, 0
  br i1 %numsec_zero, label %fail, label %prep_loop

prep_loop:
  %soh_i8 = getelementptr i8, i8* %pehdr, i64 20
  %soh_ptr = bitcast i8* %soh_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh = zext i16 %soh16 to i64
  %sec0_off = add i64 %soh, 24
  %sec0_ptr = getelementptr i8, i8* %pehdr, i64 %sec0_off
  br label %loop

loop:
  %i = phi i32 [ 0, %prep_loop ], [ %i.next, %inc ]
  %cursec = phi i8* [ %sec0_ptr, %prep_loop ], [ %nextsec, %inc ]
  %call = call i32 @strncmp(i8* %cursec, i8* %str, i64 8)
  %match = icmp eq i32 %call, 0
  br i1 %match, label %found, label %inc

inc:
  %numsec_i8.again = getelementptr i8, i8* %pehdr, i64 6
  %numsec_ptr.again = bitcast i8* %numsec_i8.again to i16*
  %numsec_val.again16 = load i16, i16* %numsec_ptr.again, align 1
  %numsec_val.again = zext i16 %numsec_val.again16 to i32
  %i.next = add i32 %i, 1
  %nextsec = getelementptr i8, i8* %cursec, i64 40
  %cont = icmp ult i32 %i.next, %numsec_val.again
  br i1 %cont, label %loop, label %fail

found:
  ret i8* %cursec

fail:
  ret i8* null
}