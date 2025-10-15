; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i32 @sub_140002790(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0
  %mz.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 0
  %mz.ptr = bitcast i8* %mz.ptr.i8 to i16*
  %mz = load i16, i16* %mz.ptr
  %is.mz = icmp eq i16 %mz, 23117
  br i1 %is.mz, label %check_pe, label %ret0

check_pe:
  %lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %lfanew.ptr = bitcast i8* %lfanew.ptr.i8 to i32*
  %lfanew = load i32, i32* %lfanew.ptr
  %lfanew.z = zext i32 %lfanew to i64
  %nthdr.i8 = getelementptr i8, i8* %base.ptr, i64 %lfanew.z
  %sig.ptr = bitcast i8* %nthdr.i8 to i32*
  %sig = load i32, i32* %sig.ptr
  %is.pe = icmp eq i32 %sig, 17744
  br i1 %is.pe, label %check_magic, label %ret0

check_magic:
  %magic.ptr.i8 = getelementptr i8, i8* %nthdr.i8, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr
  %is.pe32p = icmp eq i16 %magic, 523
  br i1 %is.pe32p, label %cont1, label %ret0

cont1:
  %numsec.ptr.i8 = getelementptr i8, i8* %nthdr.i8, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr
  %numsec.zero = icmp eq i16 %numsec16, 0
  br i1 %numsec.zero, label %ret0, label %cont2

cont2:
  %sizeopt.ptr.i8 = getelementptr i8, i8* %nthdr.i8, i64 20
  %sizeopt.ptr = bitcast i8* %sizeopt.ptr.i8 to i16*
  %sizeopt16 = load i16, i16* %sizeopt.ptr
  %sizeopt32 = zext i16 %sizeopt16 to i32
  %rcx.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva64 = sub i64 %rcx.int, %base.int
  %sizeopt64 = zext i32 %sizeopt32 to i64
  %sectab.after = getelementptr i8, i8* %nthdr.i8, i64 24
  %sectab.start = getelementptr i8, i8* %sectab.after, i64 %sizeopt64
  %numsec32 = zext i16 %numsec16 to i32
  %numsec64 = zext i32 %numsec32 to i64
  %nbytes = mul i64 %numsec64, 40
  %sectab.end = getelementptr i8, i8* %sectab.start, i64 %nbytes
  br label %loop

loop:
  %cur = phi i8* [ %sectab.start, %cont2 ], [ %next, %loop2 ]
  %at.end = icmp eq i8* %cur, %sectab.end
  br i1 %at.end, label %ret0, label %loop.body

loop.body:
  %va.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va = load i32, i32* %va.ptr
  %va64 = zext i32 %va to i64
  %cmp1 = icmp ult i64 %rva64, %va64
  br i1 %cmp1, label %loop2, label %chk.end

chk.end:
  %vsize.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize = load i32, i32* %vsize.ptr
  %endva32 = add i32 %va, %vsize
  %endva64 = zext i32 %endva32 to i64
  %cmp2 = icmp ult i64 %rva64, %endva64
  br i1 %cmp2, label %found, label %loop2

loop2:
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

found:
  %chars.ptr.i8 = getelementptr i8, i8* %cur, i64 36
  %chars.ptr = bitcast i8* %chars.ptr.i8 to i32*
  %chars = load i32, i32* %chars.ptr
  %notchars = xor i32 %chars, -1
  %shr = lshr i32 %notchars, 31
  ret i32 %shr

ret0:
  ret i32 0
}