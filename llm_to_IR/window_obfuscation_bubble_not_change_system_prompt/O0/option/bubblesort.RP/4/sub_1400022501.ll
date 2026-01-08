; ModuleID = 'sub_140002250'
source_filename = "sub_140002250"
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002250(i8* %p) local_unnamed_addr {
entry:
  %base.ptrptr = load i8*, i8** @off_1400043C0, align 8
  %mz.ptr = bitcast i8* %base.ptrptr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %is.mz = icmp eq i16 %mz, 23117
  br i1 %is.mz, label %check_pe, label %ret0

check_pe:                                         ; preds = %entry
  %lfa.ptr.i8 = getelementptr inbounds i8, i8* %base.ptrptr, i64 60
  %lfa.ptr = bitcast i8* %lfa.ptr.i8 to i32*
  %lfa = load i32, i32* %lfa.ptr, align 1
  %lfa.sext = sext i32 %lfa to i64
  %pe = getelementptr inbounds i8, i8* %base.ptrptr, i64 %lfa.sext
  %sig.ptr = bitcast i8* %pe to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %is.pe = icmp eq i32 %sig, 17744
  br i1 %is.pe, label %check_magic, label %ret0

check_magic:                                      ; preds = %check_pe
  %magic.ptr.i8 = getelementptr inbounds i8, i8* %pe, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is.pe32p = icmp eq i16 %magic, 523
  br i1 %is.pe32p, label %load_sections, label %ret0

load_sections:                                    ; preds = %check_magic
  %numsec.ptr.i8 = getelementptr inbounds i8, i8* %pe, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec.iszero = icmp eq i16 %numsec16, 0
  br i1 %numsec.iszero, label %ret0, label %prep_loop

prep_loop:                                        ; preds = %load_sections
  %soh.ptr.i8 = getelementptr inbounds i8, i8* %pe, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 1
  %soh.zext = zext i16 %soh16 to i64
  %p.i64 = ptrtoint i8* %p to i64
  %base.i64 = ptrtoint i8* %base.ptrptr to i64
  %rva = sub i64 %p.i64, %base.i64
  %after.oh = getelementptr inbounds i8, i8* %pe, i64 %soh.zext
  %first.sec = getelementptr inbounds i8, i8* %after.oh, i64 24
  %numsec32 = zext i16 %numsec16 to i32
  %nminus1 = add i32 %numsec32, -1
  %mul5 = mul i32 %nminus1, 5
  %mul5.zext = zext i32 %mul5 to i64
  %offs.bytes = mul i64 %mul5.zext, 8
  %end.pre = getelementptr inbounds i8, i8* %first.sec, i64 %offs.bytes
  %end = getelementptr inbounds i8, i8* %end.pre, i64 40
  br label %loop

loop:                                             ; preds = %advance, %prep_loop
  %cur = phi i8* [ %first.sec, %prep_loop ], [ %next, %advance ]
  %va.ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva.ult.va = icmp ult i64 %rva, %va64
  br i1 %rva.ult.va, label %advance, label %check_range

check_range:                                      ; preds = %loop
  %vsz.ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vsz.ptr = bitcast i8* %vsz.ptr.i8 to i32*
  %vsz32 = load i32, i32* %vsz.ptr, align 1
  %sum32 = add i32 %va32, %vsz32
  %sum64 = zext i32 %sum32 to i64
  %inrange = icmp ult i64 %rva, %sum64
  br i1 %inrange, label %ret0, label %advance

advance:                                          ; preds = %check_range, %loop
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %cont = icmp ne i8* %next, %end
  br i1 %cont, label %loop, label %exit

exit:                                             ; preds = %advance
  br label %ret0

ret0:                                             ; preds = %exit, %check_range, %load_sections, %check_magic, %check_pe, %entry
  ret i32 0
}