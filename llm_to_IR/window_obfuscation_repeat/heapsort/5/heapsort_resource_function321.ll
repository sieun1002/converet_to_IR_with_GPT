; ModuleID = 'module'
source_filename = "module.ll"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_1400026D0(i64 %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz.val = load i16, i16* %mz.ptr, align 1
  %is.mz = icmp eq i16 %mz.val, 23117
  br i1 %is.mz, label %mz_ok, label %ret0

mz_ok:
  %lfanew.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %lfanew.ptr = bitcast i8* %lfanew.i8 to i32*
  %lfanew.val = load i32, i32* %lfanew.ptr, align 1
  %lfanew.sext = sext i32 %lfanew.val to i64
  %pe.ptr = getelementptr i8, i8* %base.ptr, i64 %lfanew.sext
  %sig.ptr = bitcast i8* %pe.ptr to i32*
  %sig.val = load i32, i32* %sig.ptr, align 1
  %is.pe = icmp eq i32 %sig.val, 17744
  br i1 %is.pe, label %pe_ok, label %ret0

pe_ok:
  %opt.magic.i8 = getelementptr i8, i8* %pe.ptr, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 1
  %is.pep = icmp eq i16 %opt.magic, 523
  br i1 %is.pep, label %magic_ok, label %ret0

magic_ok:
  %numsec.i8 = getelementptr i8, i8* %pe.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec.zero = icmp eq i16 %numsec16, 0
  br i1 %numsec.zero, label %ret0, label %have_sections

have_sections:
  %optsz.i8 = getelementptr i8, i8* %pe.ptr, i64 20
  %optsz.ptr = bitcast i8* %optsz.i8 to i16*
  %optsz16 = load i16, i16* %optsz.ptr, align 1
  %optsz64 = zext i16 %optsz16 to i64
  %first.sec.base = getelementptr i8, i8* %pe.ptr, i64 24
  %first.sec = getelementptr i8, i8* %first.sec.base, i64 %optsz64
  %numsec64 = zext i16 %numsec16 to i64
  %totalsz = mul i64 %numsec64, 40
  %end.ptr = getelementptr i8, i8* %first.sec, i64 %totalsz
  br label %loop

loop:
  %curr = phi i8* [ %first.sec, %have_sections ], [ %next, %loop_cont ]
  %cnt = phi i64 [ %rcx, %have_sections ], [ %cnt.next, %loop_cont ]
  %flag.byte.ptr = getelementptr i8, i8* %curr, i64 39
  %flag.byte = load i8, i8* %flag.byte.ptr, align 1
  %flag.mask = and i8 %flag.byte, 32
  %flag.set = icmp ne i8 %flag.mask, 0
  br i1 %flag.set, label %if_set, label %loop_cont_pre

if_set:
  %cnt.zero = icmp eq i64 %cnt, 0
  br i1 %cnt.zero, label %ret0, label %decrement

decrement:
  %cnt.dec = add i64 %cnt, -1
  br label %loop_cont

loop_cont_pre:
  br label %loop_cont

loop_cont:
  %cnt.next = phi i64 [ %cnt.dec, %decrement ], [ %cnt, %loop_cont_pre ]
  %next = getelementptr i8, i8* %curr, i64 40
  %more = icmp ne i8* %end.ptr, %next
  br i1 %more, label %loop, label %ret0

ret0:
  ret i32 0
}