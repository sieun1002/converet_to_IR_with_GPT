target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i32 @sub_140002250(i8* %rcx.arg) {
entry:
  %baseptr = load i8*, i8** @off_1400043C0
  %base16ptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %base16ptr
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew.ptr8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt.ptr = getelementptr i8, i8* %baseptr, i64 %e_lfanew.sext
  %sig.ptr = bitcast i8* %nt.ptr to i32*
  %sig = load i32, i32* %sig.ptr
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:
  %magic.ptr8 = getelementptr i8, i8* %nt.ptr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr8 to i16*
  %magic = load i16, i16* %magic.ptr
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %get_numsec, label %ret0

get_numsec:
  %numsec.ptr8 = getelementptr i8, i8* %nt.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr
  %numsec.zero = icmp eq i16 %numsec16, 0
  br i1 %numsec.zero, label %ret0, label %after_numsec

after_numsec:
  %soh.ptr8 = getelementptr i8, i8* %nt.ptr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr8 to i16*
  %soh16 = load i16, i16* %soh.ptr
  %rcx.int = ptrtoint i8* %rcx.arg to i64
  %base.int = ptrtoint i8* %baseptr to i64
  %offset = sub i64 %rcx.int, %base.int
  %numsec32 = zext i16 %numsec16 to i32
  %numsec.minus1 = sub i32 %numsec32, 1
  %mul4 = mul i32 %numsec.minus1, 4
  %sum5.i32 = add i32 %mul4, %numsec.minus1
  %soh64 = zext i16 %soh16 to i64
  %opt.ptr = getelementptr i8, i8* %nt.ptr, i64 24
  %first.sect = getelementptr i8, i8* %opt.ptr, i64 %soh64
  %sum5.i64 = zext i32 %sum5.i32 to i64
  %idx.mul8 = mul i64 %sum5.i64, 8
  %end.tmp = getelementptr i8, i8* %first.sect, i64 %idx.mul8
  %end.ptr = getelementptr i8, i8* %end.tmp, i64 40
  br label %loop

loop:
  %cur = phi i8* [ %first.sect, %after_numsec ], [ %next, %cont ]
  %va.ptr8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr8 to i32*
  %va32 = load i32, i32* %va.ptr
  %va64 = zext i32 %va32 to i64
  %cmp1 = icmp ult i64 %offset, %va64
  br i1 %cmp1, label %cont, label %check_in

check_in:
  %vs.ptr8 = getelementptr i8, i8* %cur, i64 8
  %vs.ptr = bitcast i8* %vs.ptr8 to i32*
  %vs32 = load i32, i32* %vs.ptr
  %sum32 = add i32 %va32, %vs32
  %sum64 = zext i32 %sum32 to i64
  %cmp2 = icmp ult i64 %offset, %sum64
  br i1 %cmp2, label %ret0, label %cont

cont:
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end.ptr
  br i1 %done, label %ret0, label %loop

ret0:
  ret i32 0
}