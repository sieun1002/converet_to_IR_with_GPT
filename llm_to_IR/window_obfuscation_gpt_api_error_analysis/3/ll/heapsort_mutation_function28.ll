; ModuleID = 'sub_140002610.ll'
source_filename = "sub_140002610.ll"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002610(i8* %arg_rcx) local_unnamed_addr nounwind {
entry:
  %rdx.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %rdx.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %is.mz = icmp eq i16 %mz, 23117
  br i1 %is.mz, label %after.mz, label %ret.zero

after.mz:
  %e_lfanew.i8 = getelementptr inbounds i8, i8* %rdx.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.64 = sext i32 %e_lfanew to i64
  %pehdr.i8 = getelementptr inbounds i8, i8* %rdx.ptr, i64 %e_lfanew.64
  %pe.sig.ptr = bitcast i8* %pehdr.i8 to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr, align 1
  %is.pe = icmp eq i32 %pe.sig, 17744
  br i1 %is.pe, label %check.magic, label %ret.zero

check.magic:
  %magic.i8 = getelementptr inbounds i8, i8* %pehdr.i8, i64 24
  %magic.ptr = bitcast i8* %magic.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is.pe32p = icmp eq i16 %magic, 523
  br i1 %is.pe32p, label %get.sections, label %ret.zero

get.sections:
  %numsec.i8 = getelementptr inbounds i8, i8* %pehdr.i8, i64 6
  %numsec.ptr = bitcast i8* %numsec.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec.zero = icmp eq i16 %numsec16, 0
  br i1 %numsec.zero, label %ret.zero, label %cont

cont:
  %soh.i8 = getelementptr inbounds i8, i8* %pehdr.i8, i64 20
  %soh.ptr = bitcast i8* %soh.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %rcx.int = ptrtoint i8* %arg_rcx to i64
  %rdx.int = ptrtoint i8* %rdx.ptr to i64
  %rva = sub i64 %rcx.int, %rdx.int
  %numsec64 = zext i16 %numsec16 to i64
  %n.minus1 = add i64 %numsec64, -1
  %mul5 = mul i64 %n.minus1, 5
  %off.sections = add i64 %soh64, 24
  %first.sec = getelementptr inbounds i8, i8* %pehdr.i8, i64 %off.sections
  %mul5x8 = mul i64 %mul5, 8
  %end.off = add i64 %mul5x8, 40
  %end.ptr = getelementptr inbounds i8, i8* %first.sec, i64 %end.off
  br label %loop

loop:
  %cur = phi i8* [ %first.sec, %cont ], [ %next, %inc ]
  %va.i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva.ult.va = icmp ult i64 %rva, %va64
  br i1 %rva.ult.va, label %inc, label %check.range

check.range:
  %vsize.i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.i8 to i32*
  %vsize32 = load i32, i32* %vsize.ptr, align 1
  %vsize64 = zext i32 %vsize32 to i64
  %end = add i64 %va64, %vsize64
  %rva.ult.end = icmp ult i64 %rva, %end
  br i1 %rva.ult.end, label %ret.zero, label %inc

inc:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %cmp.done = icmp ne i8* %next, %end.ptr
  br i1 %cmp.done, label %loop, label %exit

ret.zero:
  ret i32 0

exit:
  ret i32 0
}