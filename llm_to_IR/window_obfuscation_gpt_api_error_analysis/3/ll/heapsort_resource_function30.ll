; ModuleID = 'pe_section_check'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*

define dso_local i32 @sub_140002610(i8* %p) local_unnamed_addr nounwind {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 2
  %is.mz = icmp eq i16 %mz, 23117
  br i1 %is.mz, label %after.mz, label %ret0

after.mz:
  %e_lfanew.ptr.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew.ptr, align 4
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %pehdr = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew64
  %pesig.ptr = bitcast i8* %pehdr to i32*
  %pesig = load i32, i32* %pesig.ptr, align 4
  %is.pe = icmp eq i32 %pesig, 17744
  br i1 %is.pe, label %after.pe, label %ret0

after.pe:
  %magic.ptr.i8 = getelementptr inbounds i8, i8* %pehdr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 2
  %is.pe32plus = icmp eq i16 %magic, 523
  br i1 %is.pe32plus, label %have.magic, label %ret0

have.magic:
  %nos.ptr.i8 = getelementptr inbounds i8, i8* %pehdr, i64 6
  %nos.ptr = bitcast i8* %nos.ptr.i8 to i16*
  %nos16 = load i16, i16* %nos.ptr, align 2
  %nos.nonzero = icmp ne i16 %nos16, 0
  br i1 %nos.nonzero, label %cont1, label %ret0

cont1:
  %soh.ptr.i8 = getelementptr inbounds i8, i8* %pehdr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 2
  %soh32 = zext i16 %soh16 to i32
  %p.int = ptrtoint i8* %p to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %p.int, %base.int
  %nos32 = zext i16 %nos16 to i32
  %nos.minus1 = add i32 %nos32, 4294967295
  %mul5 = mul i32 %nos.minus1, 5
  %opt.start = getelementptr inbounds i8, i8* %pehdr, i64 24
  %soh64 = zext i16 %soh16 to i64
  %sect.start = getelementptr inbounds i8, i8* %opt.start, i64 %soh64
  %mul5.zext64 = zext i32 %mul5 to i64
  %offs40 = shl nuw i64 %mul5.zext64, 3
  %end.ptr.tmp = getelementptr inbounds i8, i8* %sect.start, i64 %offs40
  %sect.end = getelementptr inbounds i8, i8* %end.ptr.tmp, i64 40
  br label %loop

loop:
  %cur = phi i8* [ %sect.start, %cont1 ], [ %next, %advance ]
  %va.ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va = load i32, i32* %va.ptr, align 4
  %va64 = zext i32 %va to i64
  %rva.lt.va = icmp ult i64 %rva, %va64
  br i1 %rva.lt.va, label %advance, label %check.in

check.in:
  %vs.ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vs.ptr = bitcast i8* %vs.ptr.i8 to i32*
  %vs = load i32, i32* %vs.ptr, align 4
  %end32 = add i32 %va, %vs
  %end64 = zext i32 %end32 to i64
  %inrange = icmp ult i64 %rva, %end64
  br i1 %inrange, label %ret.soh, label %advance

advance:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %sect.end
  br i1 %done, label %ret0, label %loop

ret.soh:
  ret i32 %soh32

ret0:
  ret i32 0
}