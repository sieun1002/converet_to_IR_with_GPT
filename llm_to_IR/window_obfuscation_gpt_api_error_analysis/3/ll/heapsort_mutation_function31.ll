target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i8* @sub_140002750() local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_null

ret_null:
  ret i8* null

check_pe:
  %eoff.byteptr = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %eoff.ptr = bitcast i8* %eoff.byteptr to i32*
  %eoff = load i32, i32* %eoff.ptr, align 4
  %eoff.sext = sext i32 %eoff to i64
  %nthdr = getelementptr inbounds i8, i8* %base.ptr, i64 %eoff.sext
  %sig.ptr = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sig.ptr, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_null

check_magic:
  %magic.byteptr = getelementptr inbounds i8, i8* %nthdr, i64 24
  %magic.ptr = bitcast i8* %magic.byteptr to i16*
  %magic = load i16, i16* %magic.ptr, align 2
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %ret_base, label %ret_null

ret_base:
  ret i8* %base.ptr
}