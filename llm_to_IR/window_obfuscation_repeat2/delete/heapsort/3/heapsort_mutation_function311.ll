target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*

define dso_local i8* @sub_140002750() local_unnamed_addr {
entry:
  %p = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %p to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_null

check_pe:
  %ptr3C = getelementptr inbounds i8, i8* %p, i64 60
  %off32ptr = bitcast i8* %ptr3C to i32*
  %off32 = load i32, i32* %off32ptr, align 1
  %off64 = sext i32 %off32 to i64
  %pehdr = getelementptr inbounds i8, i8* %p, i64 %off64
  %pehdr32 = bitcast i8* %pehdr to i32*
  %pe_sig = load i32, i32* %pehdr32, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_null

check_magic:
  %magicptr = getelementptr inbounds i8, i8* %pehdr, i64 24
  %magicptr16 = bitcast i8* %magicptr to i16*
  %magic = load i16, i16* %magicptr16, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  %res = select i1 %is_pe32plus, i8* %p, i8* null
  ret i8* %res

ret_null:
  ret i8* null
}