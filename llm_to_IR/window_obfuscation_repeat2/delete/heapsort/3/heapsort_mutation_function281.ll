; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002610(i8* %rcx.param) local_unnamed_addr {
entry:
  %imgbase = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %imgbase to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %cmp.mz = icmp eq i16 %mz, 23117
  br i1 %cmp.mz, label %check.pe, label %ret0

check.pe:
  %e_lfanew.ptr.i8 = getelementptr inbounds i8, i8* %imgbase, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt.ptr = getelementptr inbounds i8, i8* %imgbase, i64 %e_lfanew.sext
  %pesig.ptr = bitcast i8* %nt.ptr to i32*
  %pesig = load i32, i32* %pesig.ptr, align 1
  %cmp.pe = icmp eq i32 %pesig, 17744
  br i1 %cmp.pe, label %check.magic, label %ret0

check.magic:
  %magic.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is.pe32p = icmp eq i16 %magic, 523
  br i1 %is.pe32p, label %load.counts, label %ret0

load.counts:
  %numsec.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec.zero = icmp eq i16 %numsec16, 0
  br i1 %numsec.zero, label %ret0, label %cont1

cont1:
  %soh.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 1
  %soh.zext = zext i16 %soh16 to i64
  %rcx.int = ptrtoint i8* %rcx.param to i64
  %imgbase.int = ptrtoint i8* %imgbase to i64
  %rva = sub i64 %rcx.int, %imgbase.int
  %sections.pre = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %sections.base = getelementptr inbounds i8, i8* %sections.pre, i64 %soh.zext
  %numsec64 = zext i16 %numsec16 to i64
  %nminus1 = add i64 %numsec64, -1
  %nminus1.times4 = mul i64 %nminus1, 4
  %times5 = add i64 %nminus1, %nminus1.times4
  %times5.bytes = mul i64 %times5, 8
  %offset.end = add i64 %times5.bytes, 40
  %end.ptr = getelementptr inbounds i8, i8* %sections.base, i64 %offset.end
  br label %loop

loop:
  %cur = phi i8* [ %sections.base, %cont1 ], [ %next, %loop.cont ]
  %va.ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va to i64
  %rva.lt.va = icmp ult i64 %rva, %va64
  br i1 %rva.lt.va, label %loop.cont, label %check.range

check.range:
  %vs.ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vs.ptr = bitcast i8* %vs.ptr.i8 to i32*
  %vs = load i32, i32* %vs.ptr, align 1
  %sum32 = add i32 %va, %vs
  %sum64 = zext i32 %sum32 to i64
  %inrange = icmp ult i64 %rva, %sum64
  br i1 %inrange, label %ret0, label %loop.cont

loop.cont:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end.ptr
  br i1 %done, label %ret.end, label %loop

ret.end:
  ret i32 0

ret0:
  ret i32 0
}