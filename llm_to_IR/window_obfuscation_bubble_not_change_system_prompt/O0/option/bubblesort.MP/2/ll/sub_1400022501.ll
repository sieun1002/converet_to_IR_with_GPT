target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i32 @sub_140002250(i8* %rcx) {
entry:
  %base.p = load i8*, i8** @off_1400043C0, align 8
  %base.i16p = bitcast i8* %base.p to i16*
  %mz = load i16, i16* %base.i16p, align 1
  %is.mz = icmp eq i16 %mz, 23117
  br i1 %is.mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew.ptr = getelementptr inbounds i8, i8* %base.p, i64 60
  %e_lfanew.i32p = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew.i32 = load i32, i32* %e_lfanew.i32p, align 1
  %e_lfanew.i64 = sext i32 %e_lfanew.i32 to i64
  %nthdr = getelementptr inbounds i8, i8* %base.p, i64 %e_lfanew.i64
  %sig.p = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sig.p, align 1
  %is.pe = icmp eq i32 %sig, 17744
  br i1 %is.pe, label %check_magic, label %ret0

check_magic:
  %magic.ptr8 = getelementptr inbounds i8, i8* %nthdr, i64 24
  %magic.p = bitcast i8* %magic.ptr8 to i16*
  %magic = load i16, i16* %magic.p, align 1
  %is.pe64 = icmp eq i16 %magic, 523
  br i1 %is.pe64, label %get_numsec, label %ret0

get_numsec:
  %numsec.ptr8 = getelementptr inbounds i8, i8* %nthdr, i64 6
  %numsec.p = bitcast i8* %numsec.ptr8 to i16*
  %numsec = load i16, i16* %numsec.p, align 1
  %numsec.zero = icmp eq i16 %numsec, 0
  br i1 %numsec.zero, label %ret0, label %prepare

prepare:
  %rcx.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.p to i64
  %rva = sub i64 %rcx.int, %base.int
  %soh.ptr8 = getelementptr inbounds i8, i8* %nthdr, i64 20
  %soh.p = bitcast i8* %soh.ptr8 to i16*
  %soh16 = load i16, i16* %soh.p, align 1
  %soh32 = zext i16 %soh16 to i32
  %soh64 = zext i32 %soh32 to i64
  %add24 = add i64 %soh64, 24
  %sec.start = getelementptr inbounds i8, i8* %nthdr, i64 %add24
  %numsec32 = zext i16 %numsec to i32
  %numsec.m1 = add i32 %numsec32, 4294967295
  %mul5 = mul i32 %numsec.m1, 5
  %mul5.i64 = zext i32 %mul5 to i64
  %times8 = shl i64 %mul5.i64, 3
  %plus40 = add i64 %times8, 40
  %sec.end = getelementptr inbounds i8, i8* %sec.start, i64 %plus40
  br label %loop

loop:
  %cur = phi i8* [ %sec.start, %prepare ], [ %next, %advance ]
  %va.ptr8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va.p = bitcast i8* %va.ptr8 to i32*
  %va32 = load i32, i32* %va.p, align 1
  %va64 = zext i32 %va32 to i64
  %cmp1 = icmp ult i64 %rva, %va64
  br i1 %cmp1, label %advance, label %check_in

check_in:
  %vs.ptr8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vs.p = bitcast i8* %vs.ptr8 to i32*
  %vs32 = load i32, i32* %vs.p, align 1
  %sum32 = add i32 %va32, %vs32
  %sum64 = zext i32 %sum32 to i64
  %cmp2 = icmp ult i64 %rva, %sum64
  br i1 %cmp2, label %ret0, label %advance

advance:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %sec.end
  br i1 %done, label %final, label %loop

final:
  br label %ret0

ret0:
  ret i32 0
}