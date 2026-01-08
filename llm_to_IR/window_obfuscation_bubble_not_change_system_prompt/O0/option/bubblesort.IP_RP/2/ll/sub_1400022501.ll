; Target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*

define dso_local i32 @sub_140002250(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0, align 8
  %magic.ptr = bitcast i8* %base.ptr to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %isMZ = icmp eq i16 %magic, 23117
  br i1 %isMZ, label %checkPE, label %ret0

checkPE:
  %lfanew.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %lfanew.iptr = bitcast i8* %lfanew.ptr to i32*
  %lfanew = load i32, i32* %lfanew.iptr, align 1
  %lfanew.z = zext i32 %lfanew to i64
  %pehdr.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 %lfanew.z
  %pesig.ptr = bitcast i8* %pehdr.ptr to i32*
  %pesig = load i32, i32* %pesig.ptr, align 1
  %isPE = icmp eq i32 %pesig, 17744
  br i1 %isPE, label %checkOpt, label %ret0

checkOpt:
  %optmagic.ptr0 = getelementptr inbounds i8, i8* %pehdr.ptr, i64 24
  %optmagic.ptr = bitcast i8* %optmagic.ptr0 to i16*
  %optmagic = load i16, i16* %optmagic.ptr, align 1
  %isPE32p = icmp eq i16 %optmagic, 523
  br i1 %isPE32p, label %getSections, label %ret0

getSections:
  %nsec.ptr0 = getelementptr inbounds i8, i8* %pehdr.ptr, i64 6
  %nsec.ptr = bitcast i8* %nsec.ptr0 to i16*
  %nsec = load i16, i16* %nsec.ptr, align 1
  %isZero = icmp eq i16 %nsec, 0
  br i1 %isZero, label %ret0, label %calc

calc:
  %soh.ptr0 = getelementptr inbounds i8, i8* %pehdr.ptr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr0 to i16*
  %soh = load i16, i16* %soh.ptr, align 1
  %rcx.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %rcx.int, %base.int
  %soh.z = zext i16 %soh to i64
  %first.off = add i64 %soh.z, 24
  %first.ptr = getelementptr inbounds i8, i8* %pehdr.ptr, i64 %first.off
  %nsec.z = zext i16 %nsec to i64
  %totSize = mul i64 %nsec.z, 40
  %end.ptr = getelementptr inbounds i8, i8* %first.ptr, i64 %totSize
  br label %loop

loop:
  %cur = phi i8* [ %first.ptr, %calc ], [ %next.ptr, %advance ]
  %va.ptr0 = getelementptr inbounds i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr0 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %lt.va = icmp ult i64 %rva, %va64
  br i1 %lt.va, label %advance, label %checkWithin

checkWithin:
  %vsize.ptr0 = getelementptr inbounds i8, i8* %cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr0 to i32*
  %vsize32 = load i32, i32* %vsize.ptr, align 1
  %end32 = add i32 %va32, %vsize32
  %end64 = zext i32 %end32 to i64
  %inRange = icmp ult i64 %rva, %end64
  br i1 %inRange, label %ret0, label %advance

advance:
  %next.ptr = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %next.ptr, %end.ptr
  br i1 %done, label %ret0, label %loop

ret0:
  ret i32 0
}