target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*

define dso_local i32 @sub_140002250(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0, align 8
  %base.word.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %base.word.ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %peoff.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %peoff.ptr = bitcast i8* %peoff.ptr.i8 to i32*
  %peoff32 = load i32, i32* %peoff.ptr, align 1
  %peoff64 = sext i32 %peoff32 to i64
  %nt = getelementptr i8, i8* %base.ptr, i64 %peoff64
  %sig.ptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %is_sig = icmp eq i32 %sig, 17744
  br i1 %is_sig, label %check_magic, label %ret0

check_magic:
  %magic.ptr.i8 = getelementptr i8, i8* %nt, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %cont, label %ret0

cont:
  %numsec.ptr.i8 = getelementptr i8, i8* %nt, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec32 = zext i16 %numsec16 to i32
  %is_zero = icmp eq i32 %numsec32, 0
  br i1 %is_zero, label %ret0, label %after_numsec

after_numsec:
  %sosize.ptr.i8 = getelementptr i8, i8* %nt, i64 20
  %sosize.ptr = bitcast i8* %sosize.ptr.i8 to i16*
  %sosize16 = load i16, i16* %sosize.ptr, align 1
  %sosize64 = zext i16 %sosize16 to i64
  %rcx.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %rcx.int, %base.int
  %numsec.minus1 = add i32 %numsec32, -1
  %numsec.minus1.z = zext i32 %numsec.minus1 to i64
  %mul5 = mul nuw i64 %numsec.minus1.z, 5
  %nt.plus18 = getelementptr i8, i8* %nt, i64 24
  %first = getelementptr i8, i8* %nt.plus18, i64 %sosize64
  %mul5x8 = shl i64 %mul5, 3
  %end.off = add i64 %mul5x8, 40
  %end = getelementptr i8, i8* %first, i64 %end.off
  br label %loop

loop:
  %cur = phi i8* [ %first, %after_numsec ], [ %cur.next, %advance ]
  %va.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva.lt.va = icmp ult i64 %rva, %va64
  br i1 %rva.lt.va, label %advance, label %check_inside

check_inside:
  %vsize.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize32 = load i32, i32* %vsize.ptr, align 1
  %vsize64 = zext i32 %vsize32 to i64
  %va.end = add i64 %va64, %vsize64
  %in.range = icmp ult i64 %rva, %va.end
  br i1 %in.range, label %ret0, label %advance

advance:
  %cur.next = getelementptr i8, i8* %cur, i64 40
  %more = icmp ne i8* %cur.next, %end
  br i1 %more, label %loop, label %endloop

endloop:
  br label %ret0

ret0:
  ret i32 0
}