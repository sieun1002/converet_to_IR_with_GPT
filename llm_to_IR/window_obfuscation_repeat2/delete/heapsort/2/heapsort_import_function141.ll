; ModuleID = 'pe_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002610(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:                                         ; preds = %entry
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %base.ptr, i64 %e_lfanew.sext
  %pesig.ptr = bitcast i8* %pehdr to i32*
  %pesig = load i32, i32* %pesig.ptr, align 1
  %is_pe = icmp eq i32 %pesig, 17744
  br i1 %is_pe, label %check_optmagic, label %ret0

check_optmagic:                                   ; preds = %check_pe
  %magic.ptr.i8 = getelementptr i8, i8* %pehdr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %load_nsects, label %ret0

load_nsects:                                      ; preds = %check_optmagic
  %nsec.ptr.i8 = getelementptr i8, i8* %pehdr, i64 6
  %nsec.ptr = bitcast i8* %nsec.ptr.i8 to i16*
  %nsec16 = load i16, i16* %nsec.ptr, align 1
  %nsec = zext i16 %nsec16 to i32
  %nsec_is_zero = icmp eq i32 %nsec, 0
  br i1 %nsec_is_zero, label %ret0, label %cont

cont:                                             ; preds = %load_nsects
  %soh.ptr.i8 = getelementptr i8, i8* %pehdr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 1
  %soh = zext i16 %soh16 to i64
  %arg.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %arg.int, %base.int
  %first.off = add i64 %soh, 24
  %first.sec = getelementptr i8, i8* %pehdr, i64 %first.off
  %nsec.z64 = zext i32 %nsec to i64
  %nsec.minus1 = add i32 %nsec, -1
  %nsec.minus1.z64 = zext i32 %nsec.minus1 to i64
  %tmp.mul5 = mul i64 %nsec.minus1.z64, 5
  %tmp.mul40 = mul i64 %tmp.mul5, 8
  %end.off = add i64 %tmp.mul40, 40
  %end.ptr = getelementptr i8, i8* %first.sec, i64 %end.off
  br label %loop

loop:                                             ; preds = %inc, %cont
  %cur = phi i8* [ %first.sec, %cont ], [ %next, %inc ]
  %done = icmp eq i8* %cur, %end.ptr
  br i1 %done, label %after_loop, label %check_section

check_section:                                    ; preds = %loop
  %vaddr.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %vaddr.ptr = bitcast i8* %vaddr.ptr.i8 to i32*
  %vaddr32 = load i32, i32* %vaddr.ptr, align 1
  %vaddr64 = zext i32 %vaddr32 to i64
  %lt_before = icmp ult i64 %rva, %vaddr64
  br i1 %lt_before, label %inc, label %check_inside

check_inside:                                     ; preds = %check_section
  %vsize.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize32 = load i32, i32* %vsize.ptr, align 1
  %vsize64 = zext i32 %vsize32 to i64
  %endrva = add i64 %vaddr64, %vsize64
  %inside = icmp ult i64 %rva, %endrva
  br i1 %inside, label %ret0, label %inc

inc:                                              ; preds = %check_inside, %check_section
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

after_loop:                                       ; preds = %loop
  ret i32 0

ret0:                                             ; preds = %check_inside, %check_section, %cont, %check_optmagic, %check_pe, %entry
  ret i32 0
}