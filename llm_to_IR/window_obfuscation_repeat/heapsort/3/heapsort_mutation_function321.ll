; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external dso_local global i8*

define dso_local i32 @sub_140002790(i8* %addr) {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 0
  %mz.ptr.i16 = bitcast i8* %mz.ptr.i8 to i16*
  %mz.val = load i16, i16* %mz.ptr.i16, align 1
  %mz.ok = icmp eq i16 %mz.val, 23117
  br i1 %mz.ok, label %check_pe, label %ret0

check_pe:
  %peoff.ptr.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %peoff.ptr.i32 = bitcast i8* %peoff.ptr.i8 to i32*
  %peoff.i32 = load i32, i32* %peoff.ptr.i32, align 1
  %peoff.i64 = sext i32 %peoff.i32 to i64
  %nt.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 %peoff.i64
  %sig.ptr.i32 = bitcast i8* %nt.ptr to i32*
  %sig.val = load i32, i32* %sig.ptr.i32, align 1
  %sig.ok = icmp eq i32 %sig.val, 17744
  br i1 %sig.ok, label %check_opt_magic, label %ret0

check_opt_magic:
  %opt.magic.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %opt.magic.ptr.i16 = bitcast i8* %opt.magic.ptr.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr.i16, align 1
  %is.pe32plus = icmp eq i16 %opt.magic, 523
  br i1 %is.pe32plus, label %load_counts, label %ret0

load_counts:
  %numsec.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 6
  %numsec.ptr.i16 = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec.val = load i16, i16* %numsec.ptr.i16, align 1
  %numsec.zero = icmp eq i16 %numsec.val, 0
  br i1 %numsec.zero, label %ret0, label %prep_loop

prep_loop:
  %soh.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 20
  %soh.ptr.i16 = bitcast i8* %soh.ptr.i8 to i16*
  %soh.val = load i16, i16* %soh.ptr.i16, align 1
  %soh.zext64 = zext i16 %soh.val to i64
  %opt.start = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %first.sec = getelementptr inbounds i8, i8* %opt.start, i64 %soh.zext64
  %numsec.z64 = zext i16 %numsec.val to i64
  %secs.bytes = mul nuw nsw i64 %numsec.z64, 40
  %end.ptr = getelementptr inbounds i8, i8* %first.sec, i64 %secs.bytes
  %addr.int = ptrtoint i8* %addr to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %addr.int, %base.int
  br label %loop

loop:
  %cur.sec = phi i8* [ %first.sec, %prep_loop ], [ %next.sec, %loop_continue ]
  %at.end = icmp eq i8* %cur.sec, %end.ptr
  br i1 %at.end, label %not_found, label %check_section

check_section:
  %va.ptr.i8 = getelementptr inbounds i8, i8* %cur.sec, i64 12
  %va.ptr.i32 = bitcast i8* %va.ptr.i8 to i32*
  %va.val = load i32, i32* %va.ptr.i32, align 1
  %va.z64 = zext i32 %va.val to i64
  %below.start = icmp ult i64 %rva, %va.z64
  br i1 %below.start, label %loop_continue, label %check_upper

check_upper:
  %vsize.ptr.i8 = getelementptr inbounds i8, i8* %cur.sec, i64 8
  %vsize.ptr.i32 = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize.val = load i32, i32* %vsize.ptr.i32, align 1
  %vsize.z64 = zext i32 %vsize.val to i64
  %end.rva = add i64 %va.z64, %vsize.z64
  %in.range = icmp ult i64 %rva, %end.rva
  br i1 %in.range, label %found, label %loop_continue

loop_continue:
  %next.sec = getelementptr inbounds i8, i8* %cur.sec, i64 40
  br label %loop

not_found:
  ret i32 0

found:
  %chars.ptr.i8 = getelementptr inbounds i8, i8* %cur.sec, i64 36
  %chars.ptr.i32 = bitcast i8* %chars.ptr.i8 to i32*
  %chars.val = load i32, i32* %chars.ptr.i32, align 1
  %not.chars = xor i32 %chars.val, -1
  %res = lshr i32 %not.chars, 31
  ret i32 %res

ret0:
  ret i32 0
}