target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002160(i8* %rcx, i64 %rdx) local_unnamed_addr {
entry:
  %e_lfanew.ptr = getelementptr inbounds i8, i8* %rcx, i64 60
  %e_lfanew.p32 = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew.i32 = load i32, i32* %e_lfanew.p32, align 1
  %e_lfanew.i64 = sext i32 %e_lfanew.i32 to i64
  %pe = getelementptr inbounds i8, i8* %rcx, i64 %e_lfanew.i64
  %numsec.ptr = getelementptr inbounds i8, i8* %pe, i64 6
  %numsec.p16 = bitcast i8* %numsec.ptr to i16*
  %numsec.i16 = load i16, i16* %numsec.p16, align 1
  %numsec.zero = icmp eq i16 %numsec.i16, 0
  br i1 %numsec.zero, label %notfound, label %cont

cont:
  %soh.ptr = getelementptr inbounds i8, i8* %pe, i64 20
  %soh.p16 = bitcast i8* %soh.ptr to i16*
  %soh.i16 = load i16, i16* %soh.p16, align 1
  %soh.i64 = zext i16 %soh.i16 to i64
  %first.off = add i64 %soh.i64, 24
  %first = getelementptr inbounds i8, i8* %pe, i64 %first.off
  %numsec.i32 = zext i16 %numsec.i16 to i32
  %numm1 = sub i32 %numsec.i32, 1
  %times5 = mul i32 %numm1, 5
  %times5.i64 = zext i32 %times5 to i64
  %rcx8 = shl i64 %times5.i64, 3
  %end.off = add i64 %rcx8, 40
  %end = getelementptr inbounds i8, i8* %first, i64 %end.off
  br label %loop

loop:
  %cur = phi i8* [ %first, %cont ], [ %next, %advance ]
  %va.ptr = getelementptr inbounds i8, i8* %cur, i64 12
  %va.p32 = bitcast i8* %va.ptr to i32*
  %va.i32 = load i32, i32* %va.p32, align 1
  %va.i64 = zext i32 %va.i32 to i64
  %lt.start = icmp ult i64 %rdx, %va.i64
  br i1 %lt.start, label %advance, label %check

check:
  %vsize.ptr = getelementptr inbounds i8, i8* %cur, i64 8
  %vsize.p32 = bitcast i8* %vsize.ptr to i32*
  %vsize.i32 = load i32, i32* %vsize.p32, align 1
  %sum.i32 = add i32 %va.i32, %vsize.i32
  %sum.i64 = zext i32 %sum.i32 to i64
  %inside = icmp ult i64 %rdx, %sum.i64
  br i1 %inside, label %found, label %advance

advance:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end
  br i1 %done, label %notfound, label %loop

found:
  ret i8* %cur

notfound:
  ret i8* null
}