; target: Windows x86-64 PE (MSVC)
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002790(i8* %addr) {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr.cast = bitcast i8* %base.ptr to i16*
  %mz.sig = load i16, i16* %mz.ptr.cast, align 1
  %mz.ok = icmp eq i16 %mz.sig, 23117
  br i1 %mz.ok, label %lfanew.load, label %ret.zero

ret.zero:
  ret i32 0

lfanew.load:
  %base.i64 = ptrtoint i8* %base.ptr to i64
  %addr.i64 = ptrtoint i8* %addr to i64
  %rva64 = sub i64 %addr.i64, %base.i64
  %lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %lfanew.ptr = bitcast i8* %lfanew.ptr.i8 to i32*
  %lfanew = load i32, i32* %lfanew.ptr, align 1
  %lfanew.sext = sext i32 %lfanew to i64
  %nthdr = getelementptr i8, i8* %base.ptr, i64 %lfanew.sext
  %pe.ptr = bitcast i8* %nthdr to i32*
  %pe.sig = load i32, i32* %pe.ptr, align 1
  %pe.ok = icmp eq i32 %pe.sig, 17744
  br i1 %pe.ok, label %check.magic, label %ret.zero

check.magic:
  %magic.ptr.i8 = getelementptr i8, i8* %nthdr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %magic.ok = icmp eq i16 %magic, 523
  br i1 %magic.ok, label %load.counts, label %ret.zero

load.counts:
  %numsec.ptr.i8 = getelementptr i8, i8* %nthdr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec.zero = icmp eq i16 %numsec16, 0
  br i1 %numsec.zero, label %ret.zero, label %cont.counts

cont.counts:
  %soh.ptr.i8 = getelementptr i8, i8* %nthdr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 1
  %soh.zext = zext i16 %soh16 to i64
  %first.sect.base = getelementptr i8, i8* %nthdr, i64 24
  %first.sect = getelementptr i8, i8* %first.sect.base, i64 %soh.zext
  %numsec.zext = zext i16 %numsec16 to i64
  %nbytes.sections = mul i64 %numsec.zext, 40
  %end.sect = getelementptr i8, i8* %first.sect, i64 %nbytes.sections
  br label %loop

loop:
  %cur = phi i8* [ %first.sect, %cont.counts ], [ %next, %next.iter ]
  %va.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva.lt.va = icmp ult i64 %rva64, %va64
  br i1 %rva.lt.va, label %next.iter, label %check.end

check.end:
  %vsize.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize32 = load i32, i32* %vsize.ptr, align 1
  %vsize64 = zext i32 %vsize32 to i64
  %va.plus.vsize = add i64 %va64, %vsize64
  %rva.lt.end = icmp ult i64 %rva64, %va.plus.vsize
  br i1 %rva.lt.end, label %inside, label %next.iter

next.iter:
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end.sect
  br i1 %done, label %ret.zero, label %loop

inside:
  %chars.ptr.i8 = getelementptr i8, i8* %cur, i64 36
  %chars.ptr = bitcast i8* %chars.ptr.i8 to i32*
  %chars = load i32, i32* %chars.ptr, align 1
  %not.chars = xor i32 %chars, -1
  %res = lshr i32 %not.chars, 31
  ret i32 %res
}