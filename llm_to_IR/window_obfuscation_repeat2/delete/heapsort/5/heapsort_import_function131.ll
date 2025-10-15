; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

declare i64 @sub_140002AC0(i8*)
declare i32 @sub_140002AC8(i8*, i8*, i32)

define i8* @sub_140002570(i8* %0) {
entry:
  %call = call i64 @sub_140002AC0(i8* %0)
  %cmp = icmp ugt i64 %call, 8
  br i1 %cmp, label %ret_zero, label %after_len

after_len:                                        ; preds = %entry
  %1 = load i8*, i8** @off_1400043A0, align 8
  %2 = bitcast i8* %1 to i16*
  %3 = load i16, i16* %2, align 1
  %cmp1 = icmp eq i16 %3, 23117
  br i1 %cmp1, label %check_nt, label %ret_zero

check_nt:                                          ; preds = %after_len
  %4 = getelementptr i8, i8* %1, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 1
  %7 = sext i32 %6 to i64
  %8 = getelementptr i8, i8* %1, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 1
  %cmp2 = icmp eq i32 %10, 17744
  br i1 %cmp2, label %check_optmagic, label %ret_zero

check_optmagic:                                    ; preds = %check_nt
  %11 = getelementptr i8, i8* %8, i64 24
  %12 = bitcast i8* %11 to i16*
  %13 = load i16, i16* %12, align 1
  %cmp3 = icmp eq i16 %13, 523
  br i1 %cmp3, label %check_numsec_nonzero, label %ret_zero

check_numsec_nonzero:                              ; preds = %check_optmagic
  %14 = getelementptr i8, i8* %8, i64 6
  %15 = bitcast i8* %14 to i16*
  %16 = load i16, i16* %15, align 1
  %cmp4 = icmp eq i16 %16, 0
  br i1 %cmp4, label %ret_zero, label %setup_loop

setup_loop:                                        ; preds = %check_numsec_nonzero
  %17 = getelementptr i8, i8* %8, i64 20
  %18 = bitcast i8* %17 to i16*
  %19 = load i16, i16* %18, align 1
  %20 = zext i16 %19 to i64
  %21 = getelementptr i8, i8* %8, i64 24
  %22 = getelementptr i8, i8* %21, i64 %20
  br label %loop_hdr

loop_hdr:                                          ; preds = %inc, %setup_loop
  %cur = phi i8* [ %22, %setup_loop ], [ %next_ptr, %inc ]
  %idx = phi i32 [ 0, %setup_loop ], [ %idx_next, %inc ]
  %call5 = call i32 @sub_140002AC8(i8* %cur, i8* %0, i32 8)
  %cmp6 = icmp eq i32 %call5, 0
  br i1 %cmp6, label %found, label %inc

inc:                                               ; preds = %loop_hdr
  %idx_next = add i32 %idx, 1
  %23 = getelementptr i8, i8* %8, i64 6
  %24 = bitcast i8* %23 to i16*
  %25 = load i16, i16* %24, align 1
  %26 = zext i16 %25 to i32
  %next_ptr = getelementptr i8, i8* %cur, i64 40
  %cmp7 = icmp ult i32 %idx_next, %26
  br i1 %cmp7, label %loop_hdr, label %ret_zero

found:                                             ; preds = %loop_hdr
  ret i8* %cur

ret_zero:                                          ; preds = %inc, %check_numsec_nonzero, %check_optmagic, %check_nt, %after_len, %entry
  ret i8* null
}