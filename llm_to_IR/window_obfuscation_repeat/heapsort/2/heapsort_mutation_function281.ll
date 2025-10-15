; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002610(i8* %p) {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr.cast = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr.cast, align 1
  %isMZ = icmp eq i16 %mz, 23117
  br i1 %isMZ, label %after_mz, label %ret0

after_mz:
  %e_lfanew.ptr = getelementptr inbounds i8, i8* %baseptr, i64 60
  %e_lfanew.ptr.cast = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr.cast, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr inbounds i8, i8* %baseptr, i64 %e_lfanew.sext
  %pesig.ptr = bitcast i8* %pehdr to i32*
  %pesig = load i32, i32* %pesig.ptr, align 1
  %isPE = icmp eq i32 %pesig, 17744
  br i1 %isPE, label %after_pe, label %ret0

after_pe:
  %magic.ptr = getelementptr inbounds i8, i8* %pehdr, i64 24
  %magic.ptr.cast = bitcast i8* %magic.ptr to i16*
  %magic = load i16, i16* %magic.ptr.cast, align 1
  %isPE32plus = icmp eq i16 %magic, 523
  br i1 %isPE32plus, label %after_magic, label %ret0

after_magic:
  %numsec.ptr = getelementptr inbounds i8, i8* %pehdr, i64 6
  %numsec.ptr.cast = bitcast i8* %numsec.ptr to i16*
  %numsec16 = load i16, i16* %numsec.ptr.cast, align 1
  %numsec.zero = icmp eq i16 %numsec16, 0
  br i1 %numsec.zero, label %ret0, label %after_numsecs

after_numsecs:
  %sizeopt.ptr = getelementptr inbounds i8, i8* %pehdr, i64 20
  %sizeopt.ptr.cast = bitcast i8* %sizeopt.ptr to i16*
  %sizeopt16 = load i16, i16* %sizeopt.ptr.cast, align 1
  %sizeopt64 = zext i16 %sizeopt16 to i64
  %first.off = add i64 %sizeopt64, 24
  %firstsect = getelementptr inbounds i8, i8* %pehdr, i64 %first.off
  %numsec64 = zext i16 %numsec16 to i64
  %totbytes = mul i64 %numsec64, 40
  %endptr = getelementptr inbounds i8, i8* %firstsect, i64 %totbytes
  %p.int = ptrtoint i8* %p to i64
  %base.int = ptrtoint i8* %baseptr to i64
  %rva = sub i64 %p.int, %base.int
  br label %loop

loop:
  %cur = phi i8* [ %firstsect, %after_numsecs ], [ %next, %latch ]
  %done = icmp eq i8* %cur, %endptr
  br i1 %done, label %ret0, label %check_va

check_va:
  %va.ptr = getelementptr inbounds i8, i8* %cur, i64 12
  %va.ptr.cast = bitcast i8* %va.ptr to i32*
  %va32 = load i32, i32* %va.ptr.cast, align 1
  %va64 = zext i32 %va32 to i64
  %lt.va = icmp ult i64 %rva, %va64
  br i1 %lt.va, label %latch, label %check_inside

check_inside:
  %vsize.ptr = getelementptr inbounds i8, i8* %cur, i64 8
  %vsize.ptr.cast = bitcast i8* %vsize.ptr to i32*
  %vsize32 = load i32, i32* %vsize.ptr.cast, align 1
  %sum32 = add i32 %va32, %vsize32
  %sum64 = zext i32 %sum32 to i64
  %inrange = icmp ult i64 %rva, %sum64
  br i1 %inrange, label %ret0, label %latch

latch:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  br label %loop

ret0:
  ret i32 0
}