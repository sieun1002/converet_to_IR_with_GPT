; ModuleID = 'sub_1400023D0'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i32 @sub_1400023D0(i8* %arg) local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0, align 8
  %magic.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 0
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 2
  %is.mz = icmp eq i16 %magic, 23117
  br i1 %is.mz, label %mz_ok, label %ret0

mz_ok:
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 4
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt.ptr = getelementptr i8, i8* %base.ptr, i64 %e_lfanew.sext
  %nt.sig.ptr = bitcast i8* %nt.ptr to i32*
  %nt.sig = load i32, i32* %nt.sig.ptr, align 4
  %is.pe = icmp eq i32 %nt.sig, 17744
  br i1 %is.pe, label %pe_ok, label %ret0

pe_ok:
  %opt.magic.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 2
  %is.pe32p = icmp eq i16 %opt.magic, 523
  br i1 %is.pe32p, label %check_sections, label %ret0

check_sections:
  %numsec.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 2
  %numsec.zero = icmp eq i16 %numsec16, 0
  br i1 %numsec.zero, label %ret0, label %cont_sections

cont_sections:
  %soh.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 2
  %soh.zext = zext i16 %soh16 to i64
  %arg.i64 = ptrtoint i8* %arg to i64
  %base.i64 = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %arg.i64, %base.i64
  %numsec64 = zext i16 %numsec16 to i64
  %nminus1 = add i64 %numsec64, -1
  %mul5 = mul i64 %nminus1, 5
  %opt.start.off = add i64 %soh.zext, 24
  %first.sec.ptr = getelementptr i8, i8* %nt.ptr, i64 %opt.start.off
  %mul5x8 = shl i64 %mul5, 3
  %end.off.pre = add i64 %mul5x8, 40
  %end.ptr = getelementptr i8, i8* %first.sec.ptr, i64 %end.off.pre
  br label %loop

loop:
  %curr = phi i8* [ %first.sec.ptr, %cont_sections ], [ %curr.next, %inc ]
  %va.ptr.i8 = getelementptr i8, i8* %curr, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %sec.va32 = load i32, i32* %va.ptr, align 4
  %sec.va64 = zext i32 %sec.va32 to i64
  %rva.lt.va = icmp ult i64 %rva, %sec.va64
  br i1 %rva.lt.va, label %inc, label %check_high

check_high:
  %vs.ptr.i8 = getelementptr i8, i8* %curr, i64 8
  %vs.ptr = bitcast i8* %vs.ptr.i8 to i32*
  %sec.vs32 = load i32, i32* %vs.ptr, align 4
  %limit32 = add i32 %sec.va32, %sec.vs32
  %limit64 = zext i32 %limit32 to i64
  %rva.lt.limit = icmp ult i64 %rva, %limit64
  br i1 %rva.lt.limit, label %found, label %inc

inc:
  %curr.next = getelementptr i8, i8* %curr, i64 40
  %at.end = icmp eq i8* %end.ptr, %curr.next
  br i1 %at.end, label %ret0, label %loop

found:
  %chars.ptr.i8 = getelementptr i8, i8* %curr, i64 36
  %chars.ptr = bitcast i8* %chars.ptr.i8 to i32*
  %chars = load i32, i32* %chars.ptr, align 4
  %not.chars = xor i32 %chars, -1
  %shr = lshr i32 %not.chars, 31
  ret i32 %shr

ret0:
  ret i32 0
}