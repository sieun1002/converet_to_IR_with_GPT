; ModuleID = 'pe_check'
source_filename = "pe_check.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002610(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %base.i16ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %base.i16ptr, align 1
  %isMZ = icmp eq i16 %mz, 23117
  br i1 %isMZ, label %check_pe, label %ret0

check_pe:                                         ; preds = %entry
  %peoff.ptr = getelementptr i8, i8* %base.ptr, i64 60
  %peoff.i32ptr = bitcast i8* %peoff.ptr to i32*
  %ntoff = load i32, i32* %peoff.i32ptr, align 1
  %ntoff64 = zext i32 %ntoff to i64
  %ntptr = getelementptr i8, i8* %base.ptr, i64 %ntoff64
  %pesig.ptr = bitcast i8* %ntptr to i32*
  %pesig = load i32, i32* %pesig.ptr, align 1
  %isPE = icmp eq i32 %pesig, 17744
  br i1 %isPE, label %check_opt, label %ret0

check_opt:                                        ; preds = %check_pe
  %optmagic.ptr8 = getelementptr i8, i8* %ntptr, i64 24
  %optmagic.ptr16 = bitcast i8* %optmagic.ptr8 to i16*
  %magic = load i16, i16* %optmagic.ptr16, align 1
  %isPE32p = icmp eq i16 %magic, 523
  br i1 %isPE32p, label %cont1, label %ret0

cont1:                                            ; preds = %check_opt
  %numsec.ptr8 = getelementptr i8, i8* %ntptr, i64 6
  %numsec.ptr16 = bitcast i8* %numsec.ptr8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr16, align 1
  %hasSections = icmp ne i16 %numsec16, 0
  br i1 %hasSections, label %cont2, label %ret0

cont2:                                            ; preds = %cont1
  %soh.ptr8 = getelementptr i8, i8* %ntptr, i64 20
  %soh.ptr16 = bitcast i8* %soh.ptr8 to i16*
  %soh16 = load i16, i16* %soh.ptr16, align 1
  %soh64 = zext i16 %soh16 to i64
  %rcx.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %rcx.int, %base.int
  %nt.plus.24 = getelementptr i8, i8* %ntptr, i64 24
  %startSec = getelementptr i8, i8* %nt.plus.24, i64 %soh64
  %numsec32 = zext i16 %numsec16 to i32
  %numsec64 = zext i32 %numsec32 to i64
  %nbytes = mul i64 %numsec64, 40
  %endPtr = getelementptr i8, i8* %startSec, i64 %nbytes
  br label %loop

loop:                                             ; preds = %loop.continue, %cont2
  %cur = phi i8* [ %startSec, %cont2 ], [ %next, %loop.continue ]
  %done = icmp eq i8* %cur, %endPtr
  br i1 %done, label %after, label %inloop

inloop:                                           ; preds = %loop
  %va.ptr8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr32 = bitcast i8* %va.ptr8 to i32*
  %va32 = load i32, i32* %va.ptr32, align 1
  %va64 = zext i32 %va32 to i64
  %rva.lt.va = icmp ult i64 %rva, %va64
  br i1 %rva.lt.va, label %loop.continue, label %check_end

check_end:                                        ; preds = %inloop
  %vs.ptr8 = getelementptr i8, i8* %cur, i64 8
  %vs.ptr32 = bitcast i8* %vs.ptr8 to i32*
  %vs32 = load i32, i32* %vs.ptr32, align 1
  %vs64 = zext i32 %vs32 to i64
  %end = add i64 %va64, %vs64
  %rva.lt.end = icmp ult i64 %rva, %end
  br i1 %rva.lt.end, label %ret0, label %loop.continue

loop.continue:                                    ; preds = %check_end, %inloop
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

after:                                            ; preds = %loop
  br label %ret0

ret0:                                             ; preds = %after, %check_end, %cont1, %check_opt, %check_pe, %entry
  ret i32 0
}