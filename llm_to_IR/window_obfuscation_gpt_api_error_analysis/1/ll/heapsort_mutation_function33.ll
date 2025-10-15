; ModuleID = 'sub_140002820.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i8* @sub_140002820(i64 %rva, i32 %index) local_unnamed_addr nounwind {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz.val = load i16, i16* %mz.ptr
  %is.mz = icmp eq i16 %mz.val, 23117
  br i1 %is.mz, label %after.mz, label %ret.null

ret.null:
  ret i8* null

after.mz:
  %lfanew.p = getelementptr i8, i8* %base.ptr, i64 60
  %lfanew.i32p = bitcast i8* %lfanew.p to i32*
  %lfanew32 = load i32, i32* %lfanew.i32p
  %lfanew64 = zext i32 %lfanew32 to i64
  %nt.ptr = getelementptr i8, i8* %base.ptr, i64 %lfanew64
  %sig.i32p = bitcast i8* %nt.ptr to i32*
  %sig.val = load i32, i32* %sig.i32p
  %is.pe = icmp eq i32 %sig.val, 17744
  br i1 %is.pe, label %after.pe, label %ret.null

after.pe:
  %magic.p = getelementptr i8, i8* %nt.ptr, i64 24
  %magic.i16p = bitcast i8* %magic.p to i16*
  %magic.val = load i16, i16* %magic.i16p
  %is.pe32p = icmp eq i16 %magic.val, 523
  br i1 %is.pe32p, label %after.magic, label %ret.null

after.magic:
  %imp.p = getelementptr i8, i8* %nt.ptr, i64 144
  %imp.i32p = bitcast i8* %imp.p to i32*
  %imp.rva = load i32, i32* %imp.i32p
  %has.imp = icmp ne i32 %imp.rva, 0
  br i1 %has.imp, label %after.impcheck, label %ret.null

after.impcheck:
  %nsec.p = getelementptr i8, i8* %nt.ptr, i64 6
  %nsec.i16p = bitcast i8* %nsec.p to i16*
  %nsec16 = load i16, i16* %nsec.i16p
  %nsec32 = zext i16 %nsec16 to i32
  %has.sec = icmp ne i32 %nsec32, 0
  br i1 %has.sec, label %have.sec, label %ret.null

have.sec:
  %soh.p = getelementptr i8, i8* %nt.ptr, i64 20
  %soh.i16p = bitcast i8* %soh.p to i16*
  %soh16 = load i16, i16* %soh.i16p
  %soh64 = zext i16 %soh16 to i64
  %secbase.off = add i64 %soh64, 24
  %secbase = getelementptr i8, i8* %nt.ptr, i64 %secbase.off
  %nsec64 = zext i32 %nsec32 to i64
  %secs.bytes = mul i64 %nsec64, 40
  %secend = getelementptr i8, i8* %secbase, i64 %secs.bytes
  br label %sec.loop

sec.loop:
  %cur = phi i8* [ %secbase, %have.sec ], [ %cur.next, %sec.loop.next ]
  %lt.end = icmp ult i8* %cur, %secend
  br i1 %lt.end, label %check.section, label %not.found

check.section:
  %va.p = getelementptr i8, i8* %cur, i64 12
  %va.i32p = bitcast i8* %va.p to i32*
  %va32 = load i32, i32* %va.i32p
  %vs.p = getelementptr i8, i8* %cur, i64 8
  %vs.i32p = bitcast i8* %vs.p to i32*
  %vs32 = load i32, i32* %vs.i32p
  %va64 = zext i32 %va32 to i64
  %vs64 = zext i32 %vs32 to i64
  %rva.ge = icmp uge i64 %rva, %va64
  %va.plus.vs = add i64 %va64, %vs64
  %rva.lt = icmp ult i64 %rva, %va.plus.vs
  %in.range = and i1 %rva.ge, %rva.lt
  br i1 %in.range, label %section.found, label %sec.loop.next

sec.loop.next:
  %cur.next = getelementptr i8, i8* %cur, i64 40
  br label %sec.loop

not.found:
  ret i8* null

section.found:
  %ptr.in.img = getelementptr i8, i8* %base.ptr, i64 %rva
  br label %desc.loop

desc.loop:
  %desc.cur = phi i8* [ %ptr.in.img, %section.found ], [ %desc.next, %desc.iter ]
  %idx.cur = phi i32 [ %index, %section.found ], [ %idx.next, %desc.iter ]
  %tds.p = getelementptr i8, i8* %desc.cur, i64 4
  %tds.i32p = bitcast i8* %tds.p to i32*
  %tds.val = load i32, i32* %tds.i32p
  %tds.zero = icmp eq i32 %tds.val, 0
  br i1 %tds.zero, label %check.name.zero, label %after.check.zero

check.name.zero:
  %name0.p = getelementptr i8, i8* %desc.cur, i64 12
  %name0.i32p = bitcast i8* %name0.p to i32*
  %name0.val = load i32, i32* %name0.i32p
  %name0.iszero = icmp eq i32 %name0.val, 0
  br i1 %name0.iszero, label %ret.null, label %after.check.zero

after.check.zero:
  %idx.pos = icmp sgt i32 %idx.cur, 0
  br i1 %idx.pos, label %desc.iter, label %desc.return

desc.iter:
  %idx.next = add i32 %idx.cur, -1
  %desc.next = getelementptr i8, i8* %desc.cur, i64 20
  br label %desc.loop

desc.return:
  %name.p = getelementptr i8, i8* %desc.cur, i64 12
  %name.i32p = bitcast i8* %name.p to i32*
  %name.rva = load i32, i32* %name.i32p
  %name.rva64 = zext i32 %name.rva to i64
  %name.ptr = getelementptr i8, i8* %base.ptr, i64 %name.rva64
  ret i8* %name.ptr
}