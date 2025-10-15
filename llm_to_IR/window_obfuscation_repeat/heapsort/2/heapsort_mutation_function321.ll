; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002790(i8* %addr) local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr.i8 = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr.i8, align 1
  %mz.ok = icmp eq i16 %mz, 23117
  br i1 %mz.ok, label %check_pe, label %ret0

check_pe:                                        ; preds = %entry
  %e_lfanew.gep = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %e_lfanew.p = bitcast i8* %e_lfanew.gep to i32*
  %e_lfanew = load i32, i32* %e_lfanew.p, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew.sext
  %sig.p = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig.p, align 1
  %sig.ok = icmp eq i32 %sig, 1179403647
  br i1 %sig.ok, label %check_optmagic, label %ret0

check_optmagic:                                  ; preds = %check_pe
  %optmagic.gep = getelementptr inbounds i8, i8* %nt, i64 24
  %optmagic.p = bitcast i8* %optmagic.gep to i16*
  %optmagic = load i16, i16* %optmagic.p, align 1
  %is.pe32p = icmp eq i16 %optmagic, 523
  br i1 %is.pe32p, label %cont1, label %ret0

cont1:                                           ; preds = %check_optmagic
  %numsec.gep = getelementptr inbounds i8, i8* %nt, i64 6
  %numsec.p = bitcast i8* %numsec.gep to i16*
  %numsec16 = load i16, i16* %numsec.p, align 1
  %numsec = zext i16 %numsec16 to i32
  %hassec = icmp ne i32 %numsec, 0
  br i1 %hassec, label %prepare, label %ret0

prepare:                                         ; preds = %cont1
  %opthdrsz.gep = getelementptr inbounds i8, i8* %nt, i64 20
  %opthdrsz.p = bitcast i8* %opthdrsz.gep to i16*
  %opthdrsz16 = load i16, i16* %opthdrsz.p, align 1
  %opthdrsz = zext i16 %opthdrsz16 to i64
  %addr.i = ptrtoint i8* %addr to i64
  %base.i = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %addr.i, %base.i
  %sectab.start.off = add i64 %opthdrsz, 24
  %sectab.start = getelementptr inbounds i8, i8* %nt, i64 %sectab.start.off
  %numsec.i64 = zext i32 %numsec to i64
  %nbytes = mul i64 %numsec.i64, 40
  %sectab.end = getelementptr inbounds i8, i8* %sectab.start, i64 %nbytes
  br label %loop

loop:                                            ; preds = %loop_next, %prepare
  %cur = phi i8* [ %sectab.start, %prepare ], [ %next, %loop_next ]
  %done = icmp eq i8* %cur, %sectab.end
  br i1 %done, label %ret0, label %check_range

check_range:                                     ; preds = %loop
  %va.gep = getelementptr inbounds i8, i8* %cur, i64 12
  %va.p = bitcast i8* %va.gep to i32*
  %va = load i32, i32* %va.p, align 1
  %vsz.gep = getelementptr inbounds i8, i8* %cur, i64 8
  %vsz.p = bitcast i8* %vsz.gep to i32*
  %vsz = load i32, i32* %vsz.p, align 1
  %va64 = zext i32 %va to i64
  %below = icmp ult i64 %rva, %va64
  br i1 %below, label %loop_next, label %cmp_upper

cmp_upper:                                       ; preds = %check_range
  %vsz64 = zext i32 %vsz to i64
  %upper = add i64 %va64, %vsz64
  %inrange = icmp ult i64 %rva, %upper
  br i1 %inrange, label %found, label %loop_next

loop_next:                                       ; preds = %cmp_upper, %check_range
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  br label %loop

found:                                           ; preds = %cmp_upper
  %ch.gep = getelementptr inbounds i8, i8* %cur, i64 36
  %ch.p = bitcast i8* %ch.gep to i32*
  %ch = load i32, i32* %ch.p, align 1
  %notch = xor i32 %ch, -1
  %shifted = lshr i32 %notch, 31
  ret i32 %shifted

ret0:                                            ; preds = %loop, %cont1, %check_optmagic, %check_pe, %entry
  ret i32 0
}