; ModuleID = 'sub_140002250'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define i32 @sub_140002250(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_zero

ret_zero:
  ret i32 0

check_pe:
  %e_lfanew.ptr = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.i32.ptr = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew.i32 = load i32, i32* %e_lfanew.i32.ptr, align 4
  %e_lfanew.i64 = sext i32 %e_lfanew.i32 to i64
  %nt.ptr = getelementptr i8, i8* %base.ptr, i64 %e_lfanew.i64
  %pe.sig.ptr = bitcast i8* %nt.ptr to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr, align 4
  %is_pe = icmp eq i32 %pe.sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_zero

check_magic:
  %opt.magic.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 2
  %is_pe32plus = icmp eq i16 %opt.magic, 523
  br i1 %is_pe32plus, label %load_counts, label %ret_zero

load_counts:
  %numsec.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec = load i16, i16* %numsec.ptr, align 2
  %numsec_is_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_is_zero, label %ret_zero, label %prep_loop

prep_loop:
  %sizeopt.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 20
  %sizeopt.ptr = bitcast i8* %sizeopt.ptr.i8 to i16*
  %sizeopt.i16 = load i16, i16* %sizeopt.ptr, align 2
  %sizeopt.i32 = zext i16 %sizeopt.i16 to i32
  %base.int = ptrtoint i8* %base.ptr to i64
  %rcx.int = ptrtoint i8* %rcx to i64
  %rva = sub i64 %rcx.int, %base.int
  %numsec.i32 = zext i16 %numsec to i32
  %nminus1.i32 = add i32 %numsec.i32, -1
  %nminus1.i64 = zext i32 %nminus1.i32 to i64
  %tmp.mul4 = mul i64 %nminus1.i64, 4
  %times5 = add i64 %nminus1.i64, %tmp.mul4
  %times8 = shl i64 %times5, 3
  %sizeopt.i64 = zext i32 %sizeopt.i32 to i64
  %first.off = add i64 %sizeopt.i64, 24
  %first.sec = getelementptr i8, i8* %nt.ptr, i64 %first.off
  %add40 = add i64 %times8, 40
  %end.sec = getelementptr i8, i8* %first.sec, i64 %add40
  br label %loop

loop:
  %cur.sec = phi i8* [ %first.sec, %prep_loop ], [ %next.sec, %advance ]
  %not_end = icmp ne i8* %cur.sec, %end.sec
  br i1 %not_end, label %loop_body, label %after_loop

loop_body:
  %va.ptr.i8 = getelementptr i8, i8* %cur.sec, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va.i32 = load i32, i32* %va.ptr, align 4
  %va.i64 = zext i32 %va.i32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va.i64
  br i1 %rva_lt_va, label %advance, label %check_in

check_in:
  %vsz.ptr.i8 = getelementptr i8, i8* %cur.sec, i64 8
  %vsz.ptr = bitcast i8* %vsz.ptr.i8 to i32*
  %vsz.i32 = load i32, i32* %vsz.ptr, align 4
  %endva.i32 = add i32 %va.i32, %vsz.i32
  %endva.i64 = zext i32 %endva.i32 to i64
  %rva_lt_end = icmp ult i64 %rva, %endva.i64
  br i1 %rva_lt_end, label %ret_sizeopt, label %advance

ret_sizeopt:
  ret i32 %sizeopt.i32

advance:
  %next.sec = getelementptr i8, i8* %cur.sec, i64 40
  br label %loop

after_loop:
  ret i32 0
}