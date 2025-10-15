; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002520(i8* %imageBase, i64 %rva) {
entry:
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %imageBase, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 4
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt.ptr = getelementptr i8, i8* %imageBase, i64 %e_lfanew.sext
  %numsec.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec = load i16, i16* %numsec.ptr, align 2
  %numsec.iszero = icmp eq i16 %numsec, 0
  br i1 %numsec.iszero, label %ret.zero, label %nonzero

nonzero:
  %soh.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh = load i16, i16* %soh.ptr, align 2
  %optional.start = getelementptr i8, i8* %nt.ptr, i64 24
  %soh.zext64 = zext i16 %soh to i64
  %first.sec = getelementptr i8, i8* %optional.start, i64 %soh.zext64
  %numsec.zext64 = zext i16 %numsec to i64
  %total.size = mul nuw i64 %numsec.zext64, 40
  %end.ptr = getelementptr i8, i8* %first.sec, i64 %total.size
  br label %loop

loop:
  %cur = phi i8* [ %first.sec, %nonzero ], [ %next, %advance ]
  %at.end = icmp eq i8* %cur, %end.ptr
  br i1 %at.end, label %ret.zero, label %check

check:
  %va.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va = load i32, i32* %va.ptr, align 4
  %va.zext64 = zext i32 %va to i64
  %rva.lt.va = icmp ult i64 %rva, %va.zext64
  br i1 %rva.lt.va, label %advance, label %ge.va

ge.va:
  %vs.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vs.ptr = bitcast i8* %vs.ptr.i8 to i32*
  %vs = load i32, i32* %vs.ptr, align 4
  %vs.zext64 = zext i32 %vs to i64
  %va.plus.vs = add i64 %va.zext64, %vs.zext64
  %rva.in.range = icmp ult i64 %rva, %va.plus.vs
  br i1 %rva.in.range, label %ret.found, label %advance

advance:
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

ret.found:
  ret i8* %cur

ret.zero:
  ret i8* null
}