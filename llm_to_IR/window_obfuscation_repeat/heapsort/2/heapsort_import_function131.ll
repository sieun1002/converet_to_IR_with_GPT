; ModuleID = 'module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_140002AC0(i8*)
declare i32 @sub_140002AC8(i8*, i8*, i32)

@off_1400043A0 = external global i8*, align 8

define i8* @sub_140002570(i8* %arg) {
entry:
  %len = call i64 @sub_140002AC0(i8* %arg)
  %len_gt8 = icmp ugt i64 %len, 8
  br i1 %len_gt8, label %ret_zero, label %check_mz

check_mz:
  %base = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %pe_header, label %ret_zero

pe_header:
  %ofs_ptr = getelementptr i8, i8* %base, i64 60
  %ofs32p = bitcast i8* %ofs_ptr to i32*
  %ofs32 = load i32, i32* %ofs32p, align 1
  %ofs64 = sext i32 %ofs32 to i64
  %peptr = getelementptr i8, i8* %base, i64 %ofs64
  %pesigp = bitcast i8* %peptr to i32*
  %pesig = load i32, i32* %pesigp, align 1
  %is_pe = icmp eq i32 %pesig, 17744
  br i1 %is_pe, label %check_magic, label %ret_zero

check_magic:
  %magicp8 = getelementptr i8, i8* %peptr, i64 24
  %magicp16 = bitcast i8* %magicp8 to i16*
  %magic = load i16, i16* %magicp16, align 1
  %is_20b = icmp eq i16 %magic, 523
  br i1 %is_20b, label %check_numsec, label %ret_zero

check_numsec:
  %numsecp8 = getelementptr i8, i8* %peptr, i64 6
  %numsecp16 = bitcast i8* %numsecp8 to i16*
  %numsec16 = load i16, i16* %numsecp16, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret_zero, label %prep_loop

prep_loop:
  %opthdrp8 = getelementptr i8, i8* %peptr, i64 20
  %opthdrp16 = bitcast i8* %opthdrp8 to i16*
  %opthdrsz16 = load i16, i16* %opthdrp16, align 1
  %opthdrsz64 = zext i16 %opthdrsz16 to i64
  %sectbase_pre = getelementptr i8, i8* %peptr, i64 24
  %sectbase = getelementptr i8, i8* %sectbase_pre, i64 %opthdrsz64
  %numsec32 = zext i16 %numsec16 to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %prep_loop ], [ %i.next, %loop_continue ]
  %secptr = phi i8* [ %sectbase, %prep_loop ], [ %sec.next, %loop_continue ]
  %cmpcall = call i32 @sub_140002AC8(i8* %secptr, i8* %arg, i32 8)
  %eq = icmp eq i32 %cmpcall, 0
  br i1 %eq, label %found, label %loop_continue

loop_continue:
  %i.next = add i32 %i, 1
  %sec.next = getelementptr i8, i8* %secptr, i64 40
  %cont = icmp ult i32 %i.next, %numsec32
  br i1 %cont, label %loop, label %ret_zero

found:
  ret i8* %secptr

ret_zero:
  ret i8* null
}