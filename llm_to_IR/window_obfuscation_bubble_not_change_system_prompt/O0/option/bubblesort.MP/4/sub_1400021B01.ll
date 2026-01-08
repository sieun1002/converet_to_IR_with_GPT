; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_140002700()
declare i32 @sub_140002708(i8*, i8*, i32)

@off_1400043C0 = external global i8*, align 8

define dso_local i8* @sub_1400021B0(i8* %arg) {
entry:
  %ret0 = call i64 @sub_140002700()
  %cmp = icmp ugt i64 %ret0, 8
  br i1 %cmp, label %fail, label %after_sub

after_sub:
  %base_ptr = load i8*, i8** @off_1400043C0, align 8
  %dos_magic_ptr = bitcast i8* %base_ptr to i16*
  %dos_magic = load i16, i16* %dos_magic_ptr, align 1
  %is_mz = icmp eq i16 %dos_magic, 23117
  br i1 %is_mz, label %check_pe, label %fail

check_pe:
  %lfanew_ptr_i8 = getelementptr i8, i8* %base_ptr, i64 60
  %lfanew_ptr = bitcast i8* %lfanew_ptr_i8 to i32*
  %lfanew = load i32, i32* %lfanew_ptr, align 1
  %lfanew_sext = sext i32 %lfanew to i64
  %nt_hdr = getelementptr i8, i8* %base_ptr, i64 %lfanew_sext
  %pe_sig_ptr = bitcast i8* %nt_hdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %fail

check_magic:
  %opt_magic_off = getelementptr i8, i8* %nt_hdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_off to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %check_sections, label %fail

check_sections:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %fail, label %prepare_loop

prepare_loop:
  %sizeofoptoff_i8 = getelementptr i8, i8* %nt_hdr, i64 20
  %sizeofoptoff_ptr = bitcast i8* %sizeofoptoff_i8 to i16*
  %sizeofopt16 = load i16, i16* %sizeofoptoff_ptr, align 1
  %sizeofopt64 = zext i16 %sizeofopt16 to i64
  %firstsec = getelementptr i8, i8* %nt_hdr, i64 24
  %startsec = getelementptr i8, i8* %firstsec, i64 %sizeofopt64
  %numsec32 = zext i16 %numsec16 to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %prepare_loop ], [ %i.next, %cont ]
  %secptr = phi i8* [ %startsec, %prepare_loop ], [ %nextsec, %cont ]
  %call = call i32 @sub_140002708(i8* %secptr, i8* %arg, i32 8)
  %is_zero = icmp eq i32 %call, 0
  br i1 %is_zero, label %return_match, label %cont

return_match:
  ret i8* %secptr

cont:
  %i.next = add i32 %i, 1
  %nextsec = getelementptr i8, i8* %secptr, i64 40
  %cond = icmp ult i32 %i.next, %numsec32
  br i1 %cond, label %loop, label %fail

fail:
  ret i8* null
}