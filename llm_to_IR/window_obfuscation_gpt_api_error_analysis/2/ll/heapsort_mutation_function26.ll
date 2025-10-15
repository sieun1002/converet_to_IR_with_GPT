target triple = "x86_64-pc-windows-msvc"

define i8* @sub_140002520(i8* %base, i64 %rva) {
entry:
  %gep.dos.e_lfanew = getelementptr i8, i8* %base, i64 60
  %cast.e_lfanew = bitcast i8* %gep.dos.e_lfanew to i32*
  %load.e_lfanew = load i32, i32* %cast.e_lfanew, align 1
  %zext.e_lfanew = zext i32 %load.e_lfanew to i64
  %gep.nt = getelementptr i8, i8* %base, i64 %zext.e_lfanew
  %gep.numsec = getelementptr i8, i8* %gep.nt, i64 6
  %cast.numsec = bitcast i8* %gep.numsec to i16*
  %load.numsec = load i16, i16* %cast.numsec, align 1
  %cmp.numsec.zero = icmp eq i16 %load.numsec, 0
  br i1 %cmp.numsec.zero, label %ret.zero, label %has.sections

has.sections:
  %gep.soh = getelementptr i8, i8* %gep.nt, i64 20
  %cast.soh = bitcast i8* %gep.soh to i16*
  %load.soh = load i16, i16* %cast.soh, align 1
  %zext.soh = zext i16 %load.soh to i64
  %gep.opt.base = getelementptr i8, i8* %gep.nt, i64 24
  %sec.first = getelementptr i8, i8* %gep.opt.base, i64 %zext.soh
  %zext.numsec = zext i16 %load.numsec to i64
  %mul.sections.size = mul i64 %zext.numsec, 40
  %sec.end = getelementptr i8, i8* %sec.first, i64 %mul.sections.size
  br label %loop

loop:
  %cur.phi = phi i8* [ %sec.first, %has.sections ], [ %next, %loop.continue ]
  %gep.va = getelementptr i8, i8* %cur.phi, i64 12
  %cast.va = bitcast i8* %gep.va to i32*
  %load.va = load i32, i32* %cast.va, align 1
  %zext.va = zext i32 %load.va to i64
  %cmp.rva.lt.va = icmp ult i64 %rva, %zext.va
  br i1 %cmp.rva.lt.va, label %loop.continue, label %check.upper

check.upper:
  %gep.vsize = getelementptr i8, i8* %cur.phi, i64 8
  %cast.vsize = bitcast i8* %gep.vsize to i32*
  %load.vsize = load i32, i32* %cast.vsize, align 1
  %add.upper32 = add i32 %load.va, %load.vsize
  %zext.upper64 = zext i32 %add.upper32 to i64
  %cmp.rva.inrange = icmp ult i64 %rva, %zext.upper64
  br i1 %cmp.rva.inrange, label %ret.found, label %loop.continue

loop.continue:
  %next = getelementptr i8, i8* %cur.phi, i64 40
  %cmp.next.end = icmp eq i8* %next, %sec.end
  br i1 %cmp.next.end, label %ret.zero, label %loop

ret.zero:
  ret i8* null

ret.found:
  ret i8* %cur.phi
}