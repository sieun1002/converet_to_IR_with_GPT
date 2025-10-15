; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare i64 @sub_140002AC0(i8*)
declare i32 @sub_140002AC8(i8*, i8*, i32)

define i8* @sub_140002570(i8* %arg) {
entry:
  %len = call i64 @sub_140002AC0(i8* %arg)
  %cmp_len = icmp ugt i64 %len, 8
  br i1 %cmp_len, label %fail0, label %check_mz

fail0:
  ret i8* null

check_mz:
  %baseptr = load i8*, i8** @off_1400043A0
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %loc_5A8, label %fail0_2

fail0_2:
  ret i8* null

loc_5A8:
  %ptr_3c = getelementptr i8, i8* %baseptr, i64 60
  %ptr_3c_i32p = bitcast i8* %ptr_3c to i32*
  %e_lfanew_i32 = load i32, i32* %ptr_3c_i32p, align 1
  %e_lfanew = sext i32 %e_lfanew_i32 to i64
  %ntptr = getelementptr i8, i8* %baseptr, i64 %e_lfanew
  %sigp = bitcast i8* %ntptr to i32*
  %sig = load i32, i32* %sigp, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

ret0:
  ret i8* null

check_magic:
  %magicptr_i8 = getelementptr i8, i8* %ntptr, i64 24
  %magicptr = bitcast i8* %magicptr_i8 to i16*
  %magic = load i16, i16* %magicptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %check_numsec, label %ret0

check_numsec:
  %numsec_ptr_i8 = getelementptr i8, i8* %ntptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %is_nonzero = icmp ne i16 %numsec, 0
  br i1 %is_nonzero, label %prepare_loop, label %ret0

prepare_loop:
  %soh_ptr_i8 = getelementptr i8, i8* %ntptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh = zext i16 %soh16 to i64
  %firstsec = getelementptr i8, i8* %ntptr, i64 24
  %secs = getelementptr i8, i8* %firstsec, i64 %soh
  %numsec32 = zext i16 %numsec to i32
  br label %loop

loop:
  %secptr = phi i8* [ %secs, %prepare_loop ], [ %secptr_next, %loop_cont ]
  %i = phi i32 [ 0, %prepare_loop ], [ %i_next, %loop_cont ]
  %call = call i32 @sub_140002AC8(i8* %secptr, i8* %arg, i32 8)
  %is_zero = icmp eq i32 %call, 0
  br i1 %is_zero, label %ret_secptr, label %loop_cont

loop_cont:
  %i_next = add i32 %i, 1
  %secptr_next = getelementptr i8, i8* %secptr, i64 40
  %cond = icmp ult i32 %i_next, %numsec32
  br i1 %cond, label %loop, label %ret0

ret_secptr:
  ret i8* %secptr
}