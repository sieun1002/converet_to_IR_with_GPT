; ModuleID = 'pecheck'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002790(i8* %p) local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %cmp.mz = icmp eq i16 %mz, 23117
  br i1 %cmp.mz, label %check_pe, label %ret.zero

check_pe:
  %lfanew.off = getelementptr i8, i8* %base.ptr, i64 60
  %lfanew.p = bitcast i8* %lfanew.off to i32*
  %lfanew = load i32, i32* %lfanew.p, align 1
  %lfanew.sext = sext i32 %lfanew to i64
  %pehdr = getelementptr i8, i8* %base.ptr, i64 %lfanew.sext
  %sig.p = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sig.p, align 1
  %ispe = icmp eq i32 %sig, 17744
  br i1 %ispe, label %after_pe, label %ret.zero

after_pe:
  %magic.off = getelementptr i8, i8* %pehdr, i64 24
  %magic.p = bitcast i8* %magic.off to i16*
  %magic = load i16, i16* %magic.p, align 1
  %is64 = icmp eq i16 %magic, 523
  br i1 %is64, label %cont1, label %ret.zero

cont1:
  %num.off = getelementptr i8, i8* %pehdr, i64 6
  %num.p = bitcast i8* %num.off to i16*
  %num = load i16, i16* %num.p, align 1
  %zerosec = icmp eq i16 %num, 0
  br i1 %zerosec, label %ret.zero, label %have_sections

have_sections:
  %soh.off = getelementptr i8, i8* %pehdr, i64 20
  %soh.p = bitcast i8* %soh.off to i16*
  %soh16 = load i16, i16* %soh.p, align 1
  %soh32 = zext i16 %soh16 to i32
  %soh64 = zext i32 %soh32 to i64
  %p.int = ptrtoint i8* %p to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %p.int, %base.int
  %num32 = zext i16 %num to i32
  %num64 = zext i32 %num32 to i64
  %sec1.base = getelementptr i8, i8* %pehdr, i64 24
  %sec.cur.init = getelementptr i8, i8* %sec1.base, i64 %soh64
  %total.bytes = mul i64 %num64, 40
  %sec.end = getelementptr i8, i8* %sec.cur.init, i64 %total.bytes
  br label %loop

loop:
  %sec.cur = phi i8* [ %sec.cur.init, %have_sections ], [ %sec.next, %advance ]
  %at.end = icmp eq i8* %sec.cur, %sec.end
  br i1 %at.end, label %not_found, label %check_section

check_section:
  %va.off = getelementptr i8, i8* %sec.cur, i64 12
  %va.p = bitcast i8* %va.off to i32*
  %va = load i32, i32* %va.p, align 1
  %va64 = zext i32 %va to i64
  %lt.va = icmp ult i64 %rva, %va64
  br i1 %lt.va, label %advance, label %check_within

check_within:
  %vsize.off = getelementptr i8, i8* %sec.cur, i64 8
  %vsize.p = bitcast i8* %vsize.off to i32*
  %vsize = load i32, i32* %vsize.p, align 1
  %vsize64 = zext i32 %vsize to i64
  %va.end = add i64 %va64, %vsize64
  %lt.end = icmp ult i64 %rva, %va.end
  br i1 %lt.end, label %found, label %advance

advance:
  %sec.next = getelementptr i8, i8* %sec.cur, i64 40
  br label %loop

found:
  %ch.off = getelementptr i8, i8* %sec.cur, i64 36
  %ch.p = bitcast i8* %ch.off to i32*
  %ch = load i32, i32* %ch.p, align 1
  %notch = xor i32 %ch, -1
  %shr = lshr i32 %notch, 31
  ret i32 %shr

not_found:
  ret i32 0

ret.zero:
  ret i32 0
}