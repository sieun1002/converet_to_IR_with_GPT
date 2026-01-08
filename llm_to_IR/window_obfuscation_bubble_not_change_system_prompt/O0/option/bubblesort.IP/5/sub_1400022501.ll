; ModuleID = 'pe_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*

define dso_local i32 @sub_140002250(i8* %rcx.param) local_unnamed_addr {
entry:
  %base.ptr.load = load i8*, i8** @off_1400043C0, align 8
  %mz.ptr = bitcast i8* %base.ptr.load to i16*
  %mz.val = load i16, i16* %mz.ptr, align 1
  %mz.ok = icmp eq i16 %mz.val, 23117
  br i1 %mz.ok, label %check_pe, label %ret0

check_pe:
  %e_lfanew.addr = getelementptr i8, i8* %base.ptr.load, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.addr to i32*
  %e_lfanew.val = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.sext = sext i32 %e_lfanew.val to i64
  %nt.ptr = getelementptr i8, i8* %base.ptr.load, i64 %e_lfanew.sext
  %pe.ptr = bitcast i8* %nt.ptr to i32*
  %pe.sig = load i32, i32* %pe.ptr, align 1
  %pe.ok = icmp eq i32 %pe.sig, 17744
  br i1 %pe.ok, label %check_magic, label %ret0

check_magic:
  %opt.magic.addr = getelementptr i8, i8* %nt.ptr, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.addr to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 1
  %is.pe32plus = icmp eq i16 %opt.magic, 523
  br i1 %is.pe32plus, label %load_sections, label %ret0

load_sections:
  %num.sections.addr = getelementptr i8, i8* %nt.ptr, i64 6
  %num.sections.ptr = bitcast i8* %num.sections.addr to i16*
  %num.sections16 = load i16, i16* %num.sections.ptr, align 1
  %has.sections = icmp ne i16 %num.sections16, 0
  br i1 %has.sections, label %cont, label %ret0

cont:
  %opt.size.addr = getelementptr i8, i8* %nt.ptr, i64 20
  %opt.size.ptr = bitcast i8* %opt.size.addr to i16*
  %opt.size16 = load i16, i16* %opt.size.ptr, align 1
  %opt.size64 = zext i16 %opt.size16 to i64
  %rcx.int = ptrtoint i8* %rcx.param to i64
  %base.int = ptrtoint i8* %base.ptr.load to i64
  %rva = sub i64 %rcx.int, %base.int
  %first.sect.off = add i64 %opt.size64, 24
  %first.sect.ptr = getelementptr i8, i8* %nt.ptr, i64 %first.sect.off
  %num.sections32 = zext i16 %num.sections16 to i32
  %nminus1 = add i32 %num.sections32, -1
  %nminus1.i64 = sext i32 %nminus1 to i64
  %times5 = mul i64 %nminus1.i64, 5
  %times5x8 = mul i64 %times5, 8
  %end.off = add i64 %times5x8, 40
  %end.ptr = getelementptr i8, i8* %first.sect.ptr, i64 %end.off
  br label %loop

loop:
  %sect.cur = phi i8* [ %first.sect.ptr, %cont ], [ %sect.next, %loopcont ]
  %at.end = icmp eq i8* %sect.cur, %end.ptr
  br i1 %at.end, label %ret0, label %process

process:
  %va.addr = getelementptr i8, i8* %sect.cur, i64 12
  %va.ptr = bitcast i8* %va.addr to i32*
  %va.val = load i32, i32* %va.ptr, align 1
  %va.zext = zext i32 %va.val to i64
  %cmp.rva.va = icmp ult i64 %rva, %va.zext
  br i1 %cmp.rva.va, label %loopcont, label %checkend

checkend:
  %vs.addr = getelementptr i8, i8* %sect.cur, i64 8
  %vs.ptr = bitcast i8* %vs.addr to i32*
  %vs.val = load i32, i32* %vs.ptr, align 1
  %va.plus.vs32 = add i32 %va.val, %vs.val
  %va.plus.vs64 = zext i32 %va.plus.vs32 to i64
  %in.range = icmp ult i64 %rva, %va.plus.vs64
  br i1 %in.range, label %ret0, label %loopcont

loopcont:
  %sect.next = getelementptr i8, i8* %sect.cur, i64 40
  br label %loop

ret0:
  ret i32 0
}