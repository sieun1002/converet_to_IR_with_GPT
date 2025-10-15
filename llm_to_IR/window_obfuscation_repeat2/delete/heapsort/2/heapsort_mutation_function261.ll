; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

define dso_local i8* @sub_140002520(i8* %rcx, i64 %rdx) local_unnamed_addr {
entry:
  %e_lfanew.ptr = getelementptr i8, i8* %rcx, i64 60
  %e_lfanew.p32 = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew.p32, align 4
  %e_lfanew64 = sext i32 %e_lfanew to i64
  %nt.ptr = getelementptr i8, i8* %rcx, i64 %e_lfanew64
  %numsec.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 2
  %numsec32 = zext i16 %numsec16 to i32
  %iszero = icmp eq i32 %numsec32, 0
  br i1 %iszero, label %ret.zero, label %nonzero

nonzero:                                          ; preds = %entry
  %sizeopt.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 20
  %sizeopt.ptr = bitcast i8* %sizeopt.ptr.i8 to i16*
  %sizeopt16 = load i16, i16* %sizeopt.ptr, align 2
  %sizeopt32 = zext i16 %sizeopt16 to i32
  %numsec.minus1 = add i32 %numsec32, -1
  %mul5 = mul i32 %numsec.minus1, 5
  %mul5.zext64 = zext i32 %mul5 to i64
  %opt.off64 = zext i32 %sizeopt32 to i64
  %base.plus24 = getelementptr i8, i8* %nt.ptr, i64 24
  %first.sec = getelementptr i8, i8* %base.plus24, i64 %opt.off64
  %mul5.x8 = shl i64 %mul5.zext64, 3
  %end.off = add i64 %mul5.x8, 40
  %end.ptr = getelementptr i8, i8* %first.sec, i64 %end.off
  br label %loop

loop:                                             ; preds = %inc, %nonzero
  %cur = phi i8* [ %first.sec, %nonzero ], [ %next, %inc ]
  %va.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 4
  %va64 = zext i32 %va32 to i64
  %cmp.rva.va = icmp ult i64 %rdx, %va64
  br i1 %cmp.rva.va, label %inc, label %ge.va

ge.va:                                            ; preds = %loop
  %vsize.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize32 = load i32, i32* %vsize.ptr, align 4
  %vsize64 = zext i32 %vsize32 to i64
  %endva = add i64 %va64, %vsize64
  %cmp.rva.end = icmp ult i64 %rdx, %endva
  br i1 %cmp.rva.end, label %ret.found, label %inc

inc:                                              ; preds = %ge.va, %loop
  %next = getelementptr i8, i8* %cur, i64 40
  %cmp.end = icmp ne i8* %next, %end.ptr
  br i1 %cmp.end, label %loop, label %ret.zero

ret.zero:                                         ; preds = %inc, %entry
  ret i8* null

ret.found:                                        ; preds = %ge.va
  ret i8* %cur
}