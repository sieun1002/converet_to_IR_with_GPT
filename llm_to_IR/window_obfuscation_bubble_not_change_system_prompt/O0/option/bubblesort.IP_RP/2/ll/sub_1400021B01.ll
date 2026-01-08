; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @sub_140002700(i8*)

define i8* @sub_1400021B0(i8* %0) {
entry:
  %call0 = call i64 @sub_140002700(i8* %0)
  %cmp0 = icmp ugt i64 %call0, 8
  br i1 %cmp0, label %ret_zero, label %cont_a

ret_zero:                                         ; preds = %loop_latch, %magic_true, %pe_true, %mz_true, %entry
  ret i8* null

cont_a:                                           ; preds = %entry
  %pbase = load i8*, i8** @off_1400043C0, align 8
  %p_mz = bitcast i8* %pbase to i16*
  %mz = load i16, i16* %p_mz, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %mz_true, label %ret_zero

mz_true:                                          ; preds = %cont_a
  %eoff_ptr = getelementptr i8, i8* %pbase, i64 60
  %eoff32p = bitcast i8* %eoff_ptr to i32*
  %eoff32 = load i32, i32* %eoff32p, align 1
  %eoff64 = sext i32 %eoff32 to i64
  %nthdr = getelementptr i8, i8* %pbase, i64 %eoff64
  %sigp = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sigp, align 1
  %ispe = icmp eq i32 %sig, 17744
  br i1 %ispe, label %pe_true, label %ret_zero

pe_true:                                          ; preds = %mz_true
  %magicp_i8 = getelementptr i8, i8* %nthdr, i64 24
  %magicp = bitcast i8* %magicp_i8 to i16*
  %magic = load i16, i16* %magicp, align 1
  %is20B = icmp eq i16 %magic, 523
  br i1 %is20B, label %magic_true, label %ret_zero

magic_true:                                       ; preds = %pe_true
  %numsec_p_i8 = getelementptr i8, i8* %nthdr, i64 6
  %numsec_p = bitcast i8* %numsec_p_i8 to i16*
  %numsec16 = load i16, i16* %numsec_p, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret_zero, label %after_numsec

after_numsec:                                     ; preds = %magic_true
  %sizeopt_p_i8 = getelementptr i8, i8* %nthdr, i64 20
  %sizeopt_p = bitcast i8* %sizeopt_p_i8 to i16*
  %sizeopt16 = load i16, i16* %sizeopt_p, align 1
  %sizeopt64 = zext i16 %sizeopt16 to i64
  %sectoff = add i64 %sizeopt64, 24
  %first_sect = getelementptr i8, i8* %nthdr, i64 %sectoff
  br label %loop

loop:                                             ; preds = %after_numsec, %loop_latch
  %i = phi i32 [ 0, %after_numsec ], [ %i.next, %loop_latch ]
  %cur = phi i8* [ %first_sect, %after_numsec ], [ %next, %loop_latch ]
  %callee = inttoptr i64 5368719112 to i32 (i8*, i8*, i32)*
  %call = call i32 %callee(i8* %cur, i8* %0, i32 8)
  %iszero = icmp eq i32 %call, 0
  br i1 %iszero, label %ret_cur, label %loop_latch

ret_cur:                                          ; preds = %loop
  ret i8* %cur

loop_latch:                                       ; preds = %loop
  %i.next = add i32 %i, 1
  %next = getelementptr i8, i8* %cur, i64 40
  %numsec16_2 = load i16, i16* %numsec_p, align 1
  %numsec32_2 = zext i16 %numsec16_2 to i32
  %cont = icmp ult i32 %i.next, %numsec32_2
  br i1 %cont, label %loop, label %ret_zero
}