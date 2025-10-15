; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i32 @sub_1400026F0(i8* %arg) {
entry:
  %baseptr.addr = load i8*, i8** @off_1400043C0, align 8
  %mz.ptr.cast = bitcast i8* %baseptr.addr to i16*
  %mz = load i16, i16* %mz.ptr.cast, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew.gep = getelementptr i8, i8* %baseptr.addr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.gep to i32*
  %e_lfanew.val = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.sext = sext i32 %e_lfanew.val to i64
  %pe_hdr.ptr = getelementptr i8, i8* %baseptr.addr, i64 %e_lfanew.sext
  %pesig.ptr = bitcast i8* %pe_hdr.ptr to i32*
  %pesig = load i32, i32* %pesig.ptr, align 1
  %is_pe = icmp eq i32 %pesig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %optmagic.gep = getelementptr i8, i8* %pe_hdr.ptr, i64 24
  %optmagic.ptr = bitcast i8* %optmagic.gep to i16*
  %optmagic.val = load i16, i16* %optmagic.ptr, align 1
  %is_pe32p = icmp eq i16 %optmagic.val, 523
  br i1 %is_pe32p, label %cont, label %ret0

cont:
  %numsec.gep = getelementptr i8, i8* %pe_hdr.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.gep to i16*
  %numsec.val = load i16, i16* %numsec.ptr, align 1
  %numsec.zero = icmp eq i16 %numsec.val, 0
  br i1 %numsec.zero, label %ret0, label %cont2

cont2:
  %soh.gep = getelementptr i8, i8* %pe_hdr.ptr, i64 20
  %soh.ptr = bitcast i8* %soh.gep to i16*
  %soh.val = load i16, i16* %soh.ptr, align 1
  %soh.z = zext i16 %soh.val to i64
  %arg.int = ptrtoint i8* %arg to i64
  %base.int = ptrtoint i8* %baseptr.addr to i64
  %off = sub i64 %arg.int, %base.int
  %numsec.z = zext i16 %numsec.val to i64
  %numsec.m1 = add i64 %numsec.z, -1
  %tmp.shl4 = shl i64 %numsec.m1, 2
  %times5 = add i64 %numsec.m1, %tmp.shl4
  %secbase.tmp = getelementptr i8, i8* %pe_hdr.ptr, i64 24
  %secbase = getelementptr i8, i8* %secbase.tmp, i64 %soh.z
  %times8 = shl i64 %times5, 3
  %end.pre = getelementptr i8, i8* %secbase, i64 %times8
  %end = getelementptr i8, i8* %end.pre, i64 40
  br label %loop

loop:
  %iter = phi i8* [ %secbase, %cont2 ], [ %iter.next, %loop_inc ]
  %va.gep = getelementptr i8, i8* %iter, i64 12
  %va.ptr = bitcast i8* %va.gep to i32*
  %va.val = load i32, i32* %va.ptr, align 1
  %va.z = zext i32 %va.val to i64
  %off.lt.va = icmp ult i64 %off, %va.z
  br i1 %off.lt.va, label %loop_inc, label %check_upper

check_upper:
  %vsize.gep = getelementptr i8, i8* %iter, i64 8
  %vsize.ptr = bitcast i8* %vsize.gep to i32*
  %vsize.val = load i32, i32* %vsize.ptr, align 1
  %vsize.z = zext i32 %vsize.val to i64
  %upper = add i64 %va.z, %vsize.z
  %off.lt.upper = icmp ult i64 %off, %upper
  br i1 %off.lt.upper, label %ret0, label %loop_inc

loop_inc:
  %iter.next = getelementptr i8, i8* %iter, i64 40
  %cmp.end = icmp ne i8* %iter.next, %end
  br i1 %cmp.end, label %loop, label %done

done:
  ret i32 0

ret0:
  ret i32 0
}