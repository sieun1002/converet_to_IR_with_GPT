; ModuleID = 'pe_helper'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i8* @sub_140002820(i64 %rva, i32 %count) local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_null

ret_null:
  ret i8* null

check_pe:
  %e_lfanew_ptr.i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr.i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_ptr, align 4
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %pehdr = getelementptr i8, i8* %baseptr, i64 %e_lfanew64
  %pesig.ptr = bitcast i8* %pehdr to i32*
  %pesig = load i32, i32* %pesig.ptr, align 4
  %is_pe = icmp eq i32 %pesig, 17744
  br i1 %is_pe, label %check_optmagic, label %ret_null

check_optmagic:
  %optmagic.ptr.i8 = getelementptr i8, i8* %pehdr, i64 24
  %optmagic.ptr = bitcast i8* %optmagic.ptr.i8 to i16*
  %optmagic = load i16, i16* %optmagic.ptr, align 2
  %is_64 = icmp eq i16 %optmagic, 523
  br i1 %is_64, label %check_dd, label %ret_null

check_dd:
  %dd.ptr.i8 = getelementptr i8, i8* %pehdr, i64 144
  %dd.ptr = bitcast i8* %dd.ptr.i8 to i32*
  %dd.val = load i32, i32* %dd.ptr, align 4
  %dd.nonzero = icmp ne i32 %dd.val, 0
  br i1 %dd.nonzero, label %check_numsects, label %ret_null

check_numsects:
  %numsects.ptr.i8 = getelementptr i8, i8* %pehdr, i64 6
  %numsects.ptr = bitcast i8* %numsects.ptr.i8 to i16*
  %numsects16 = load i16, i16* %numsects.ptr, align 2
  %hassects = icmp ne i16 %numsects16, 0
  br i1 %hassects, label %calc_secttbl, label %ret_null

calc_secttbl:
  %soh.ptr.i8 = getelementptr i8, i8* %pehdr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 2
  %soh32 = zext i16 %soh16 to i32
  %soh64 = zext i32 %soh32 to i64
  %firstsect = getelementptr i8, i8* %pehdr, i64 24
  %sectbase = getelementptr i8, i8* %firstsect, i64 %soh64
  %numsects32 = zext i16 %numsects16 to i32
  %num.minus1 = add i32 %numsects32, 4294967295
  %times5 = mul i32 %num.minus1, 5
  %times5.64 = zext i32 %times5 to i64
  %mul8 = shl i64 %times5.64, 3
  %end.off = add i64 %mul8, 40
  %end.ptr = getelementptr i8, i8* %sectbase, i64 %end.off
  br label %sect_loop

sect_loop:
  %cur = phi i8* [ %sectbase, %calc_secttbl ], [ %next, %sect_advance ]
  %va.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 4
  %va64 = zext i32 %va32 to i64
  %rva.lt.va = icmp ult i64 %rva, %va64
  br i1 %rva.lt.va, label %sect_advance, label %check_endinrange

check_endinrange:
  %vsize.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vsize.ptr = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize32 = load i32, i32* %vsize.ptr, align 4
  %vsize64 = zext i32 %vsize32 to i64
  %va.end = add i64 %va64, %vsize64
  %inrange = icmp ult i64 %rva, %va.end
  br i1 %inrange, label %found_section, label %sect_advance

sect_advance:
  %next = getelementptr i8, i8* %cur, i64 40
  %cont = icmp ne i8* %end.ptr, %next
  br i1 %cont, label %sect_loop, label %return_null2

return_null2:
  ret i8* null

found_section:
  %rax.ptr = getelementptr i8, i8* %baseptr, i64 %rva
  br label %loop_header

loop_header:
  %curptr = phi i8* [ %rax.ptr, %found_section ], [ %curptr.next, %loop_body ]
  %cnt = phi i32 [ %count, %found_section ], [ %cnt.next, %loop_body ]
  %field4.ptr.i8 = getelementptr i8, i8* %curptr, i64 4
  %field4.ptr = bitcast i8* %field4.ptr.i8 to i32*
  %field4 = load i32, i32* %field4.ptr, align 4
  %f4.nz = icmp ne i32 %field4, 0
  br i1 %f4.nz, label %cnt_test, label %checkC2

checkC2:
  %fieldC.ptr.i8 = getelementptr i8, i8* %curptr, i64 12
  %fieldC.ptr = bitcast i8* %fieldC.ptr.i8 to i32*
  %fieldC = load i32, i32* %fieldC.ptr, align 4
  %fC.nz = icmp ne i32 %fieldC, 0
  br i1 %fC.nz, label %cnt_test, label %return_null3

return_null3:
  ret i8* null

cnt_test:
  %gt0 = icmp sgt i32 %cnt, 0
  br i1 %gt0, label %loop_body, label %finish

loop_body:
  %cnt.next = add i32 %cnt, -1
  %curptr.next = getelementptr i8, i8* %curptr, i64 20
  br label %loop_header

finish:
  %out.ptr.i8 = getelementptr i8, i8* %curptr, i64 12
  %out.ptr = bitcast i8* %out.ptr.i8 to i32*
  %out.rva32 = load i32, i32* %out.ptr, align 4
  %out.rva64 = zext i32 %out.rva32 to i64
  %retptr = getelementptr i8, i8* %baseptr, i64 %out.rva64
  ret i8* %retptr
}