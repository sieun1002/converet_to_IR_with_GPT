; ModuleID = 'pe_check'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002790(i8* %addr) {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %is.mz = icmp eq i16 %mz, 23117
  br i1 %is.mz, label %ntcheck, label %ret0

ret0:
  ret i32 0

ntcheck:
  %lfanew.byteptr = getelementptr i8, i8* %base.ptr, i64 60
  %lfanew.ptr = bitcast i8* %lfanew.byteptr to i32*
  %lfanew = load i32, i32* %lfanew.ptr, align 1
  %lfanew.sext = sext i32 %lfanew to i64
  %nt.ptr = getelementptr i8, i8* %base.ptr, i64 %lfanew.sext
  %sig.ptr = bitcast i8* %nt.ptr to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %is.pe = icmp eq i32 %sig, 17744
  br i1 %is.pe, label %optcheck, label %ret0

optcheck:
  %magic.byteptr = getelementptr i8, i8* %nt.ptr, i64 24
  %magic.ptr = bitcast i8* %magic.byteptr to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is.pe32plus = icmp eq i16 %magic, 523
  br i1 %is.pe32plus, label %sectprep, label %ret0

sectprep:
  %numsec.byteptr = getelementptr i8, i8* %nt.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.byteptr to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec32 = zext i16 %numsec16 to i32
  %hassecs = icmp ne i32 %numsec32, 0
  br i1 %hassecs, label %contprep, label %ret0

contprep:
  %soh.byteptr = getelementptr i8, i8* %nt.ptr, i64 20
  %soh.ptr = bitcast i8* %soh.byteptr to i16*
  %soh16 = load i16, i16* %soh.ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %firstsec.pre = getelementptr i8, i8* %nt.ptr, i64 24
  %firstsec = getelementptr i8, i8* %firstsec.pre, i64 %soh64
  %numsec64 = zext i32 %numsec32 to i64
  %secbytes = mul nuw nsw i64 %numsec64, 40
  %endsec = getelementptr i8, i8* %firstsec, i64 %secbytes
  %addr.int = ptrtoint i8* %addr to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %addr.int, %base.int
  br label %loop

loop:
  %p = phi i8* [ %firstsec, %contprep ], [ %next, %loop.next ]
  %done = icmp eq i8* %p, %endsec
  br i1 %done, label %ret0, label %loop.body

loop.body:
  %va.byteptr = getelementptr i8, i8* %p, i64 12
  %va.ptr = bitcast i8* %va.byteptr to i32*
  %va = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va to i64
  %rva.lt.va = icmp ult i64 %rva, %va64
  br i1 %rva.lt.va, label %loop.next, label %checkend

loop.next:
  %next = getelementptr i8, i8* %p, i64 40
  br label %loop

checkend:
  %vsize.byteptr = getelementptr i8, i8* %p, i64 8
  %vsize.ptr = bitcast i8* %vsize.byteptr to i32*
  %vsize = load i32, i32* %vsize.ptr, align 1
  %sum32 = add i32 %va, %vsize
  %end64 = zext i32 %sum32 to i64
  %rva.lt.end = icmp ult i64 %rva, %end64
  br i1 %rva.lt.end, label %found, label %loop.next

found:
  %ch.byteptr = getelementptr i8, i8* %p, i64 36
  %ch.ptr = bitcast i8* %ch.byteptr to i32*
  %ch = load i32, i32* %ch.ptr, align 1
  %notch = xor i32 %ch, -1
  %res = lshr i32 %notch, 31
  ret i32 %res
}