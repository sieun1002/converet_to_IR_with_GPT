; ModuleID = 'pe_section_lookup'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define i8* @sub_140002520(i8* %rcx, i64 %rdx) {
entry:
  %e_lfanew.ptr.i8 = getelementptr inbounds i8, i8* %rcx, i64 60
  %e_lfanew.ptr.i32 = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew.i32 = load i32, i32* %e_lfanew.ptr.i32, align 4
  %e_lfanew.i64 = sext i32 %e_lfanew.i32 to i64
  %nt.ptr = getelementptr inbounds i8, i8* %rcx, i64 %e_lfanew.i64
  %numsec.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 6
  %numsec.ptr.i16 = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec.i16 = load i16, i16* %numsec.ptr.i16, align 2
  %numsec.iszero = icmp eq i16 %numsec.i16, 0
  br i1 %numsec.iszero, label %ret_zero, label %cont

cont:
  %opt.size.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr, i64 20
  %opt.size.ptr.i16 = bitcast i8* %opt.size.ptr.i8 to i16*
  %opt.size.i16 = load i16, i16* %opt.size.ptr.i16, align 2
  %opt.size.i32 = zext i16 %opt.size.i16 to i32
  %numsec.i32 = zext i16 %numsec.i16 to i32
  %n.minus1 = sub i32 %numsec.i32, 1
  %times5 = mul i32 %n.minus1, 5
  %nt.plus18 = getelementptr inbounds i8, i8* %nt.ptr, i64 24
  %opt.size.i64 = zext i32 %opt.size.i32 to i64
  %first.ptr = getelementptr inbounds i8, i8* %nt.plus18, i64 %opt.size.i64
  %times5.times8 = mul i32 %times5, 8
  %plus40 = add i32 %times5.times8, 40
  %plus40.i64 = zext i32 %plus40 to i64
  %end.ptr = getelementptr inbounds i8, i8* %first.ptr, i64 %plus40.i64
  br label %loop

loop:
  %cur = phi i8* [ %first.ptr, %cont ], [ %inc.ptr, %incblock ]
  %va.ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va.ptr.i32 = bitcast i8* %va.ptr.i8 to i32*
  %va.i32 = load i32, i32* %va.ptr.i32, align 4
  %va.i64 = zext i32 %va.i32 to i64
  %cmp1 = icmp ult i64 %rdx, %va.i64
  br i1 %cmp1, label %incblock, label %checkSecond

checkSecond:
  %vsize.ptr.i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vsize.ptr.i32 = bitcast i8* %vsize.ptr.i8 to i32*
  %vsize.i32 = load i32, i32* %vsize.ptr.i32, align 4
  %sum.i32 = add i32 %va.i32, %vsize.i32
  %sum.i64 = zext i32 %sum.i32 to i64
  %cmp2 = icmp ult i64 %rdx, %sum.i64
  br i1 %cmp2, label %ret_found, label %incblock

incblock:
  %cur.phi = phi i8* [ %cur, %loop ], [ %cur, %checkSecond ]
  %inc.ptr = getelementptr inbounds i8, i8* %cur.phi, i64 40
  %cont.loop = icmp ne i8* %inc.ptr, %end.ptr
  br i1 %cont.loop, label %loop, label %ret_zero

ret_zero:
  ret i8* null

ret_found:
  ret i8* %cur
}