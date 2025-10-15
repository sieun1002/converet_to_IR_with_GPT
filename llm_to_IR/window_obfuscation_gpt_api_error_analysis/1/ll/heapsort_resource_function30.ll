; ModuleID = 'sub_140002610.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i64 @sub_140002610(i8* %rcx) {
entry:
  %base.ptr.ptr = bitcast i8** @off_1400043A0 to i8**
  %base.ptr = load i8*, i8** %base.ptr.ptr, align 8
  %mzhdr.ptr = bitcast i8* %base.ptr to i16*
  %mzval = load i16, i16* %mzhdr.ptr, align 1
  %is_mz = icmp eq i16 %mzval, 23117
  br i1 %is_mz, label %check_pe, label %ret_zero

check_pe:
  %e_lfanew.ptr.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew.i32 = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.i64 = sext i32 %e_lfanew.i32 to i64
  %nthdr.ptr = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew.i64
  %sig.ptr = bitcast i8* %nthdr.ptr to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret_zero

check_opt:
  %magic.ptr.i8 = getelementptr inbounds i8, i8* %nthdr.ptr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %load_hdr_fields, label %ret_zero

load_hdr_fields:
  %numsec.ptr.i8 = getelementptr inbounds i8, i8* %nthdr.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec.i16 = load i16, i16* %numsec.ptr, align 1
  %numsec.i32 = zext i16 %numsec.i16 to i32
  %has_secs = icmp ne i32 %numsec.i32, 0
  br i1 %has_secs, label %compute_pointers, label %ret_zero

compute_pointers:
  %soh.ptr.i8 = getelementptr inbounds i8, i8* %nthdr.ptr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh.i16 = load i16, i16* %soh.ptr, align 1
  %soh.i32 = zext i16 %soh.i16 to i32
  %rcx.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %rcx.int, %base.int
  %soh.i64 = zext i32 %soh.i32 to i64
  %first.off = add i64 %soh.i64, 24
  %first.ptr = getelementptr inbounds i8, i8* %nthdr.ptr, i64 %first.off
  %numsec.i64 = zext i32 %numsec.i32 to i64
  %total.size = mul nuw nsw i64 %numsec.i64, 40
  %end.ptr = getelementptr inbounds i8, i8* %first.ptr, i64 %total.size
  br label %loop

loop:
  %cur.ptr = phi i8* [ %first.ptr, %compute_pointers ], [ %next.ptr, %cont ]
  %done = icmp eq i8* %cur.ptr, %end.ptr
  br i1 %done, label %ret_zero, label %check_section

check_section:
  %va.ptr.i8 = getelementptr inbounds i8, i8* %cur.ptr, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va.i32 = load i32, i32* %va.ptr, align 1
  %va.i64 = zext i32 %va.i32 to i64
  %less_than_va = icmp ult i64 %rva, %va.i64
  br i1 %less_than_va, label %cont, label %check_upper

check_upper:
  %vs.ptr.i8 = getelementptr inbounds i8, i8* %cur.ptr, i64 8
  %vs.ptr = bitcast i8* %vs.ptr.i8 to i32*
  %vs.i32 = load i32, i32* %vs.ptr, align 1
  %vaEnd.i32 = add i32 %va.i32, %vs.i32
  %vaEnd.i64 = zext i32 %vaEnd.i32 to i64
  %in_range = icmp ult i64 %rva, %vaEnd.i64
  br i1 %in_range, label %ret_true, label %cont

cont:
  %next.ptr = getelementptr inbounds i8, i8* %cur.ptr, i64 40
  br label %loop

ret_true:
  %soh.ret64 = zext i32 %soh.i32 to i64
  ret i64 %soh.ret64

ret_zero:
  ret i64 0
}