target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002160(i8* %rcx, i64 %rdx) {
entry:
  %eaddr = getelementptr i8, i8* %rcx, i64 60
  %eaddr.i32ptr = bitcast i8* %eaddr to i32*
  %e = load i32, i32* %eaddr.i32ptr, align 1
  %e.sext = sext i32 %e to i64
  %nthdr = getelementptr i8, i8* %rcx, i64 %e.sext
  %numsec.ptr.i8 = getelementptr i8, i8* %nthdr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %iszero = icmp eq i16 %numsec16, 0
  br i1 %iszero, label %ret_zero, label %cont

cont:
  %numsec32 = zext i16 %numsec16 to i32
  %numsec.minus1 = add i32 %numsec32, -1
  %optsz.ptr.i8 = getelementptr i8, i8* %nthdr, i64 20
  %optsz.ptr = bitcast i8* %optsz.ptr.i8 to i16*
  %optsz16 = load i16, i16* %optsz.ptr, align 1
  %optsz64 = zext i16 %optsz16 to i64
  %nthdr.plus18 = getelementptr i8, i8* %nthdr, i64 24
  %sectbase = getelementptr i8, i8* %nthdr.plus18, i64 %optsz64
  %mul5 = mul i32 %numsec.minus1, 5
  %mul5.z = zext i32 %mul5 to i64
  %off8 = shl i64 %mul5.z, 3
  %end.pre = getelementptr i8, i8* %sectbase, i64 %off8
  %end = getelementptr i8, i8* %end.pre, i64 40
  br label %loop

loop:
  %cur = phi i8* [ %sectbase, %cont ], [ %next, %advance ]
  %va.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %cmp1 = icmp ult i64 %rdx, %va64
  br i1 %cmp1, label %advance, label %check

check:
  %vs.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vs.ptr = bitcast i8* %vs.ptr.i8 to i32*
  %vs32 = load i32, i32* %vs.ptr, align 1
  %sum32 = add i32 %va32, %vs32
  %sum64 = zext i32 %sum32 to i64
  %cmp2 = icmp ult i64 %rdx, %sum64
  br i1 %cmp2, label %ret_found, label %advance

advance:
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end
  br i1 %done, label %ret_zero, label %loop

ret_found:
  ret i8* %cur

ret_zero:
  ret i8* null
}