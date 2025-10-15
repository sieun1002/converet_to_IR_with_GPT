; ModuleID: 'module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define void @sub_140002610(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %mz.ok = icmp eq i16 %mz, 23117
  br i1 %mz.ok, label %check_pe, label %ret

check_pe:
  %e_lfanew.byteptr = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.byteptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt.ptr = getelementptr i8, i8* %base.ptr, i64 %e_lfanew.sext
  %sig.ptr = bitcast i8* %nt.ptr to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %sig.ok = icmp eq i32 %sig, 17744
  br i1 %sig.ok, label %check_opt, label %ret

check_opt:
  %opt.magic.byteptr = getelementptr i8, i8* %nt.ptr, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.byteptr to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 1
  %is.pe32plus = icmp eq i16 %opt.magic, 523
  br i1 %is.pe32plus, label %load_sections, label %ret

load_sections:
  %numsec.byteptr = getelementptr i8, i8* %nt.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.byteptr to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec.zero = icmp eq i16 %numsec16, 0
  br i1 %numsec.zero, label %ret, label %compute_start

compute_start:
  %sizeopt.byteptr = getelementptr i8, i8* %nt.ptr, i64 20
  %sizeopt.ptr = bitcast i8* %sizeopt.byteptr to i16*
  %sizeopt16 = load i16, i16* %sizeopt.ptr, align 1
  %rcx.int = ptrtoint i8* %rcx to i64
  %base.int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %rcx.int, %base.int
  %sizeopt64 = zext i16 %sizeopt16 to i64
  %first.off = add i64 %sizeopt64, 24
  %first.sec = getelementptr i8, i8* %nt.ptr, i64 %first.off
  %numsec32 = zext i16 %numsec16 to i32
  %nminus1 = add i32 %numsec32, -1
  %mul5 = mul i32 %nminus1, 5
  %mul5.64 = zext i32 %mul5 to i64
  %times8 = shl i64 %mul5.64, 3
  %end.off = add i64 %times8, 40
  %end.ptr = getelementptr i8, i8* %first.sec, i64 %end.off
  br label %loop

loop:
  %cur = phi i8* [ %first.sec, %compute_start ], [ %cur.next, %inc ]
  %va.byteptr = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.byteptr to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %before.va = icmp ult i64 %rva, %va64
  br i1 %before.va, label %inc, label %check_in

check_in:
  %vsize.byteptr = getelementptr i8, i8* %cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.byteptr to i32*
  %vsize32 = load i32, i32* %vsize.ptr, align 1
  %sum32 = add i32 %va32, %vsize32
  %sum64 = zext i32 %sum32 to i64
  %inrange = icmp ult i64 %rva, %sum64
  br i1 %inrange, label %ret, label %inc

inc:
  %cur.next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %cur.next, %end.ptr
  br i1 %done, label %notfound, label %loop

notfound:
  br label %ret

ret:
  ret void
}