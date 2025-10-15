; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i32 @sub_140002870(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0
  %magic.ptr = bitcast i8* %base.ptr to i16*
  %magic = load i16, i16* %magic.ptr
  %is_mz = icmp eq i16 %magic, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:                                         ; preds = %entry
  %lfanew.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %lfanew.p32 = bitcast i8* %lfanew.ptr to i32*
  %lfanew32 = load i32, i32* %lfanew.p32
  %lfanew64 = sext i32 %lfanew32 to i64
  %nt.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 %lfanew64
  %sig.p32 = bitcast i8* %nt.ptr to i32*
  %sig = load i32, i32* %sig.p32
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %after_signature, label %ret0

after_signature:                                  ; preds = %check_pe
  %optmagic.ptr = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %optmagic.p16 = bitcast i8* %optmagic.ptr to i16*
  %optmagic = load i16, i16* %optmagic.p16
  %is_pe32plus = icmp eq i16 %optmagic, 523
  br i1 %is_pe32plus, label %cont, label %ret0

cont:                                             ; preds = %after_signature
  %numsec.ptr = getelementptr inbounds i8, i8* %nt.ptr, i64 6
  %numsec.p16 = bitcast i8* %numsec.ptr to i16*
  %numsec16 = load i16, i16* %numsec.p16
  %numsec32 = zext i16 %numsec16 to i32
  %numsec_zero = icmp eq i32 %numsec32, 0
  br i1 %numsec_zero, label %ret0, label %after_numsec

after_numsec:                                     ; preds = %cont
  %sizeopt.ptr = getelementptr inbounds i8, i8* %nt.ptr, i64 20
  %sizeopt.p16 = bitcast i8* %sizeopt.ptr to i16*
  %sizeopt16 = load i16, i16* %sizeopt.p16
  %sizeopt32 = zext i16 %sizeopt16 to i32
  %rcx.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %delta = sub i64 %rcx.int, %base.int
  %numsec_m1 = add i32 %numsec32, -1
  %m1_times5 = mul i32 %numsec_m1, 5
  %sizeopt64 = zext i32 %sizeopt32 to i64
  %sect_start_off = add i64 %sizeopt64, 24
  %sect.start = getelementptr inbounds i8, i8* %nt.ptr, i64 %sect_start_off
  %m1_times5_64 = zext i32 %m1_times5 to i64
  %end_off_mul = mul i64 %m1_times5_64, 8
  %end_off = add i64 %end_off_mul, 40
  %sect.end = getelementptr inbounds i8, i8* %sect.start, i64 %end_off
  br label %loop

loop:                                             ; preds = %next_loop, %after_numsec
  %cur = phi i8* [ %sect.start, %after_numsec ], [ %nextcur, %next_loop ]
  %va.ptr = getelementptr inbounds i8, i8* %cur, i64 12
  %va.p32 = bitcast i8* %va.ptr to i32*
  %va32 = load i32, i32* %va.p32
  %va64 = zext i32 %va32 to i64
  %delta_lt_va = icmp ult i64 %delta, %va64
  br i1 %delta_lt_va, label %next, label %check_upper

check_upper:                                      ; preds = %loop
  %vsize.ptr = getelementptr inbounds i8, i8* %cur, i64 8
  %vsize.p32 = bitcast i8* %vsize.ptr to i32*
  %vsize32 = load i32, i32* %vsize.p32
  %sum32 = add i32 %va32, %vsize32
  %sum64 = zext i32 %sum32 to i64
  %inrange = icmp ult i64 %delta, %sum64
  br i1 %inrange, label %inside, label %next

inside:                                           ; preds = %check_upper
  %chars.ptr = getelementptr inbounds i8, i8* %cur, i64 36
  %chars.p32 = bitcast i8* %chars.ptr to i32*
  %chars = load i32, i32* %chars.p32
  %notchars = xor i32 %chars, -1
  %ret = lshr i32 %notchars, 31
  ret i32 %ret

next:                                             ; preds = %check_upper, %loop
  %nextcur = getelementptr inbounds i8, i8* %cur, i64 40
  %atend = icmp eq i8* %nextcur, %sect.end
  br i1 %atend, label %ret0, label %next_loop

next_loop:                                        ; preds = %next
  br label %loop

ret0:                                             ; preds = %next, %after_signature, %check_pe, %cont, %entry
  ret i32 0
}