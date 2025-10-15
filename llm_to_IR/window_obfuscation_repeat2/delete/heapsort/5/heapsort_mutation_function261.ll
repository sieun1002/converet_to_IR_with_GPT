; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

define dso_local i8* @sub_140002520(i8* %base, i64 %rva) {
entry:
  %e_lfanew.ptr = getelementptr inbounds i8, i8* %base, i64 60
  %e_lfanew.i32ptr = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew.i32ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt.ptr = getelementptr inbounds i8, i8* %base, i64 %e_lfanew64
  %numsec.ptr8 = getelementptr inbounds i8, i8* %nt.ptr, i64 6
  %numsec.ptr16 = bitcast i8* %numsec.ptr8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr16, align 1
  %numsec.zero = icmp eq i16 %numsec16, 0
  br i1 %numsec.zero, label %ret.zero, label %cont

cont:
  %soh.ptr8 = getelementptr inbounds i8, i8* %nt.ptr, i64 20
  %soh.ptr16 = bitcast i8* %soh.ptr8 to i16*
  %soh16 = load i16, i16* %soh.ptr16, align 1
  %numsec32 = zext i16 %numsec16 to i32
  %nsec.minus1 = sub i32 %numsec32, 1
  %nsec.minus1.z = zext i32 %nsec.minus1 to i64
  %times5 = mul i64 %nsec.minus1.z, 5
  %soh32 = zext i16 %soh16 to i32
  %soh64 = zext i32 %soh32 to i64
  %opt.plus = add i64 %soh64, 24
  %first.sec = getelementptr inbounds i8, i8* %nt.ptr, i64 %opt.plus
  %times5.mul8 = shl i64 %times5, 3
  %end.off = add i64 %times5.mul8, 40
  %end.ptr = getelementptr inbounds i8, i8* %first.sec, i64 %end.off
  br label %loop

loop:
  %cur = phi i8* [ %first.sec, %cont ], [ %next, %inc ]
  %va.ptr8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va.ptr32 = bitcast i8* %va.ptr8 to i32*
  %va32 = load i32, i32* %va.ptr32, align 1
  %va64 = zext i32 %va32 to i64
  %cmp.lt.va = icmp ult i64 %rva, %va64
  br i1 %cmp.lt.va, label %inc, label %check

check:
  %srd.ptr8 = getelementptr inbounds i8, i8* %cur, i64 8
  %srd.ptr32 = bitcast i8* %srd.ptr8 to i32*
  %srd32 = load i32, i32* %srd.ptr32, align 1
  %sum32 = add i32 %va32, %srd32
  %sum64 = zext i32 %sum32 to i64
  %cmp.lt.sum = icmp ult i64 %rva, %sum64
  br i1 %cmp.lt.sum, label %found, label %inc

inc:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end.ptr
  br i1 %done, label %ret.zero, label %loop

found:
  ret i8* %cur

ret.zero:
  ret i8* null
}