; ModuleID = 'pe_section_check'
source_filename = "pe_section_check.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002610(i8* %addr) local_unnamed_addr {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew.ptr8 = getelementptr i8, i8* %base, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.zext = zext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base, i64 %e_lfanew.zext
  %sig.ptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %after_pe, label %ret0

after_pe:
  %opt.magic.ptr8 = getelementptr i8, i8* %nt, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 1
  %is_pe32plus = icmp eq i16 %opt.magic, 523
  br i1 %is_pe32plus, label %cont1, label %ret0

cont1:
  %numsec.ptr8 = getelementptr i8, i8* %nt, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr8 to i16*
  %numsec = load i16, i16* %numsec.ptr, align 1
  %has_sec = icmp ne i16 %numsec, 0
  br i1 %has_sec, label %cont2, label %ret0

cont2:
  %soh.ptr8 = getelementptr i8, i8* %nt, i64 20
  %soh.ptr = bitcast i8* %soh.ptr8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 1
  %soh32 = zext i16 %soh16 to i32
  %soh64 = zext i32 %soh32 to i64
  %addr.i = ptrtoint i8* %addr to i64
  %base.i = ptrtoint i8* %base to i64
  %rva = sub i64 %addr.i, %base.i
  %nsec32 = zext i16 %numsec to i32
  %nsec64 = zext i32 %nsec32 to i64
  %sect0.off = add i64 24, %soh64
  %sect0 = getelementptr i8, i8* %nt, i64 %sect0.off
  %total.bytes = mul i64 %nsec64, 40
  %sect.end = getelementptr i8, i8* %sect0, i64 %total.bytes
  br label %loop

loop:
  %cur = phi i8* [ %sect0, %cont2 ], [ %next, %loop.cont ]
  %at.end = icmp eq i8* %cur, %sect.end
  br i1 %at.end, label %exit0, label %loop.body

loop.body:
  %va.ptr8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %before.va = icmp ult i64 %rva, %va64
  br i1 %before.va, label %loop.cont, label %check2

check2:
  %vsize.ptr8 = getelementptr i8, i8* %cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr8 to i32*
  %vsize32 = load i32, i32* %vsize.ptr, align 1
  %vsize64 = zext i32 %vsize32 to i64
  %end.rva = add i64 %va64, %vsize64
  %in.range = icmp ult i64 %rva, %end.rva
  br i1 %in.range, label %ret0, label %loop.cont

loop.cont:
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

exit0:
  br label %ret0

ret0:
  ret i32 0
}