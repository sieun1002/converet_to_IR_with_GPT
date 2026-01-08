target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i32 @sub_140002250(i8* %rcx) {
entry:
  %baseptr.load = load i8*, i8** @off_1400043C0
  %mz.ptr = bitcast i8* %baseptr.load to i16*
  %mz.val = load i16, i16* %mz.ptr
  %mz.ok = icmp eq i16 %mz.val, 23117
  br i1 %mz.ok, label %check_pe, label %ret0

check_pe:
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %baseptr.load, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew.val32 = load i32, i32* %e_lfanew.ptr
  %e_lfanew.val64 = sext i32 %e_lfanew.val32 to i64
  %pehdr = getelementptr i8, i8* %baseptr.load, i64 %e_lfanew.val64
  %sig.ptr = bitcast i8* %pehdr to i32*
  %sig.val = load i32, i32* %sig.ptr
  %sig.ok = icmp eq i32 %sig.val, 17744
  br i1 %sig.ok, label %check_magic, label %ret0

check_magic:
  %magic.ptr.i8 = getelementptr i8, i8* %pehdr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic.val = load i16, i16* %magic.ptr
  %magic.ok = icmp eq i16 %magic.val, 523
  br i1 %magic.ok, label %load_nsects, label %ret0

load_nsects:
  %nsects.ptr.i8 = getelementptr i8, i8* %pehdr, i64 6
  %nsects.ptr = bitcast i8* %nsects.ptr.i8 to i16*
  %nsects.val16 = load i16, i16* %nsects.ptr
  %nsects.zero = icmp eq i16 %nsects.val16, 0
  br i1 %nsects.zero, label %ret0, label %prepare

prepare:
  %optsz.ptr.i8 = getelementptr i8, i8* %pehdr, i64 20
  %optsz.ptr = bitcast i8* %optsz.ptr.i8 to i16*
  %optsz.val16 = load i16, i16* %optsz.ptr
  %optsz.val64 = zext i16 %optsz.val16 to i64
  %arg.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %baseptr.load to i64
  %rva = sub i64 %arg.int, %base.int
  %nsects.val32 = zext i16 %nsects.val16 to i32
  %nminus1 = add i32 %nsects.val32, -1
  %nminus1.shl2 = shl i32 %nminus1, 2
  %nminus1.times5 = add i32 %nminus1, %nminus1.shl2
  %nminus1.times5.64 = zext i32 %nminus1.times5 to i64
  %firstsec.off = add i64 %optsz.val64, 24
  %firstsec = getelementptr i8, i8* %pehdr, i64 %firstsec.off
  %mul8 = mul i64 %nminus1.times5.64, 8
  %endtmp = getelementptr i8, i8* %firstsec, i64 %mul8
  %endptr = getelementptr i8, i8* %endtmp, i64 40
  br label %loop

loop:
  %secptr = phi i8* [ %firstsec, %prepare ], [ %secnext, %loop.advance ]
  %va.ptr.i8 = getelementptr i8, i8* %secptr, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va.val32 = load i32, i32* %va.ptr
  %va.val64 = zext i32 %va.val32 to i64
  %cmp.rva.va = icmp ult i64 %rva, %va.val64
  br i1 %cmp.rva.va, label %loop.advance, label %checkwithin

checkwithin:
  %vsz.ptr.i8 = getelementptr i8, i8* %secptr, i64 8
  %vsz.ptr = bitcast i8* %vsz.ptr.i8 to i32*
  %vsz.val32 = load i32, i32* %vsz.ptr
  %vsz.val64 = zext i32 %vsz.val32 to i64
  %range.end = add i64 %va.val64, %vsz.val64
  %inrange = icmp ult i64 %rva, %range.end
  br i1 %inrange, label %ret0, label %loop.advance

loop.advance:
  %secnext = getelementptr i8, i8* %secptr, i64 40
  %cont = icmp ne i8* %secnext, %endptr
  br i1 %cont, label %loop, label %done

done:
  br label %ret0

ret0:
  ret i32 0
}