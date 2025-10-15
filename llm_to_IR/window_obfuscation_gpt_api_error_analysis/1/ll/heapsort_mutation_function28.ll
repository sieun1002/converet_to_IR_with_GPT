target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002610(i8* %addr) local_unnamed_addr nounwind {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew.ptr.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew.ptr, align 4
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew64
  %pe.sig.ptr = bitcast i8* %nt to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr, align 4
  %is_pe = icmp eq i32 %pe.sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %magic.off = getelementptr inbounds i8, i8* %nt, i64 24
  %magic.ptr = bitcast i8* %magic.off to i16*
  %magic = load i16, i16* %magic.ptr, align 2
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %numsec_check, label %ret0

numsec_check:
  %numsec.off = getelementptr inbounds i8, i8* %nt, i64 6
  %numsec.ptr = bitcast i8* %numsec.off to i16*
  %numsec = load i16, i16* %numsec.ptr, align 2
  %numsec.is.zero = icmp eq i16 %numsec, 0
  br i1 %numsec.is.zero, label %ret0, label %cont

cont:
  %sizeopt.off = getelementptr inbounds i8, i8* %nt, i64 20
  %sizeopt.ptr = bitcast i8* %sizeopt.off to i16*
  %sizeopt16 = load i16, i16* %sizeopt.ptr, align 2
  %addr.int = ptrtoint i8* %addr to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %addr.int, %base.int
  %sizeopt64 = zext i16 %sizeopt16 to i64
  %optstart = getelementptr inbounds i8, i8* %nt, i64 24
  %firstsec = getelementptr inbounds i8, i8* %optstart, i64 %sizeopt64
  %numsec64 = zext i16 %numsec to i64
  %numsec.minus1 = add i64 %numsec64, -1
  %mul4 = mul i64 %numsec.minus1, 4
  %times5 = add i64 %mul4, %numsec.minus1
  %times8 = shl i64 %times5, 3
  %span = add i64 %times8, 40
  %end = getelementptr inbounds i8, i8* %firstsec, i64 %span
  br label %loop

loop:
  %p = phi i8* [ %firstsec, %cont ], [ %p.next, %inc ]
  %va.off = getelementptr inbounds i8, i8* %p, i64 12
  %va.ptr = bitcast i8* %va.off to i32*
  %va32 = load i32, i32* %va.ptr, align 4
  %va64 = zext i32 %va32 to i64
  %rva.lt.va = icmp ult i64 %rva, %va64
  br i1 %rva.lt.va, label %inc, label %check_endva

check_endva:
  %vs.off = getelementptr inbounds i8, i8* %p, i64 8
  %vs.ptr = bitcast i8* %vs.off to i32*
  %vs32 = load i32, i32* %vs.ptr, align 4
  %vs64 = zext i32 %vs32 to i64
  %endva = add i64 %va64, %vs64
  %rva.lt.end = icmp ult i64 %rva, %endva
  br i1 %rva.lt.end, label %ret0, label %inc

inc:
  %p.next = getelementptr inbounds i8, i8* %p, i64 40
  %done = icmp eq i8* %p.next, %end
  br i1 %done, label %exit, label %loop

exit:
  br label %ret0

ret0:
  ret i32 0
}