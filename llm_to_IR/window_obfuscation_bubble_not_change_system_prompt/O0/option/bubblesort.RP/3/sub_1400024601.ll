target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i8* @sub_140002460(i32 %ecx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0
  %mz.ptr.cast = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr.cast
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_null

check_pe:
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt.ptr = getelementptr i8, i8* %base.ptr, i64 %e_lfanew.sext
  %pe.sig.ptr = bitcast i8* %nt.ptr to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr
  %is_pe = icmp eq i32 %pe.sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_null

check_magic:
  %magic.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %check_import_rva, label %ret_null

check_import_rva:
  %import.rva.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 144
  %import.rva.ptr = bitcast i8* %import.rva.ptr.i8 to i32*
  %import.rva = load i32, i32* %import.rva.ptr
  %import.rva.zero = icmp eq i32 %import.rva, 0
  br i1 %import.rva.zero, label %ret_null, label %check_numsects

check_numsects:
  %numsects.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 6
  %numsects.ptr = bitcast i8* %numsects.ptr.i8 to i16*
  %numsects.16 = load i16, i16* %numsects.ptr
  %numsects.zero = icmp eq i16 %numsects.16, 0
  br i1 %numsects.zero, label %ret_null, label %calc_sectptrs

calc_sectptrs:
  %optsize.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 20
  %optsize.ptr = bitcast i8* %optsize.ptr.i8 to i16*
  %optsize.16 = load i16, i16* %optsize.ptr
  %optsize.zext = zext i16 %optsize.16 to i64
  %sect.base0 = getelementptr i8, i8* %nt.ptr, i64 24
  %sect.base = getelementptr i8, i8* %sect.base0, i64 %optsize.zext
  %numsects.zext32 = zext i16 %numsects.16 to i32
  %numsects.m1 = add i32 %numsects.zext32, -1
  %numsects.m1.zext64 = zext i32 %numsects.m1 to i64
  %mul5 = mul i64 %numsects.m1.zext64, 5
  %mul5x8 = mul i64 %mul5, 8
  %after.last = getelementptr i8, i8* %sect.base, i64 %mul5x8
  %sect.end = getelementptr i8, i8* %after.last, i64 40
  br label %section.loop

section.loop:
  %sec.cur = phi i8* [ %sect.base, %calc_sectptrs ], [ %sec.next, %section.advance ]
  %va.ptr.i8 = getelementptr i8, i8* %sec.cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %sec.va = load i32, i32* %va.ptr
  %rva.lt.va = icmp ult i32 %import.rva, %sec.va
  br i1 %rva.lt.va, label %section.advance, label %section.check.upper

section.check.upper:
  %vsize.ptr.i8 = getelementptr i8, i8* %sec.cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize = load i32, i32* %vsize.ptr
  %va.plus.size = add i32 %sec.va, %vsize
  %rva.in.range = icmp ult i32 %import.rva, %va.plus.size
  br i1 %rva.in.range, label %section.found, label %section.advance

section.advance:
  %sec.next = getelementptr i8, i8* %sec.cur, i64 40
  %not.end = icmp ne i8* %sec.next, %sect.end
  br i1 %not.end, label %section.loop, label %ret_null

section.found:
  %import.rva.zext = zext i32 %import.rva to i64
  %imp.dir.ptr = getelementptr i8, i8* %base.ptr, i64 %import.rva.zext
  br label %desc.loop

desc.loop:
  %desc.cur = phi i8* [ %imp.dir.ptr, %section.found ], [ %desc.next, %desc.iter ]
  %idx.cur = phi i32 [ %ecx, %section.found ], [ %idx.next, %desc.iter ]
  %ts.ptr.i8 = getelementptr i8, i8* %desc.cur, i64 4
  %ts.ptr = bitcast i8* %ts.ptr.i8 to i32*
  %ts.val = load i32, i32* %ts.ptr
  %ts.nonzero = icmp ne i32 %ts.val, 0
  br i1 %ts.nonzero, label %desc.check.idx, label %desc.check.end

desc.check.end:
  %name.rva.ptr.i8 = getelementptr i8, i8* %desc.cur, i64 12
  %name.rva.ptr = bitcast i8* %name.rva.ptr.i8 to i32*
  %name.rva.val = load i32, i32* %name.rva.ptr
  %name.zero = icmp eq i32 %name.rva.val, 0
  br i1 %name.zero, label %ret_null, label %desc.check.idx

desc.check.idx:
  %idx.positive = icmp sgt i32 %idx.cur, 0
  br i1 %idx.positive, label %desc.iter, label %desc.return

desc.iter:
  %idx.next = add i32 %idx.cur, -1
  %desc.next = getelementptr i8, i8* %desc.cur, i64 20
  br label %desc.loop

desc.return:
  %name.rva.ptr2.i8 = getelementptr i8, i8* %desc.cur, i64 12
  %name.rva.ptr2 = bitcast i8* %name.rva.ptr2.i8 to i32*
  %name.rva2 = load i32, i32* %name.rva.ptr2
  %name.rva2.zext = zext i32 %name.rva2 to i64
  %name.ptr = getelementptr i8, i8* %base.ptr, i64 %name.rva2.zext
  ret i8* %name.ptr

ret_null:
  ret i8* null
}