; ModuleID = 'pe_section_finder'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare i64 @sub_140002AC0()
declare i32 @sub_140002AC8(i8*, i8*, i32)

define i8* @sub_140002570(i8* %0) {
entry:
  %call.init = call i64 @sub_140002AC0()
  %cmp.init = icmp ugt i64 %call.init, 8
  br i1 %cmp.init, label %retnull, label %check_mz

check_mz:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.p = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.p, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %get_nt, label %retnull

get_nt:
  %e_lfanew.p.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.p = bitcast i8* %e_lfanew.p.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.p, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt.p.i8 = getelementptr i8, i8* %base.ptr, i64 %e_lfanew.sext
  %sig.p = bitcast i8* %nt.p.i8 to i32*
  %sig = load i32, i32* %sig.p, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %retnull

check_magic:
  %opt.magic.p.i8 = getelementptr i8, i8* %nt.p.i8, i64 24
  %opt.magic.p = bitcast i8* %opt.magic.p.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.p, align 1
  %is_pe64 = icmp eq i16 %opt.magic, 523
  br i1 %is_pe64, label %check_numsec, label %retnull

check_numsec:
  %numsec.p.i8 = getelementptr i8, i8* %nt.p.i8, i64 6
  %numsec.p = bitcast i8* %numsec.p.i8 to i16*
  %numsec16 = load i16, i16* %numsec.p, align 1
  %numsec.iszero = icmp eq i16 %numsec16, 0
  br i1 %numsec.iszero, label %retnull, label %setup_loop

setup_loop:
  %soh.p.i8 = getelementptr i8, i8* %nt.p.i8, i64 20
  %soh.p = bitcast i8* %soh.p.i8 to i16*
  %soh16 = load i16, i16* %soh.p, align 1
  %soh64 = zext i16 %soh16 to i64
  %sect.base.off = add i64 %soh64, 24
  %sect.base = getelementptr i8, i8* %nt.p.i8, i64 %sect.base.off
  %numsec32 = zext i16 %numsec16 to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %setup_loop ], [ %i.next, %cont ]
  %sect.cur = phi i8* [ %sect.base, %setup_loop ], [ %sect.next, %cont ]
  %call.chk = call i32 @sub_140002AC8(i8* %sect.cur, i8* %0, i32 8)
  %ok = icmp eq i32 %call.chk, 0
  br i1 %ok, label %retsect, label %cont

cont:
  %i.next = add i32 %i, 1
  %sect.next = getelementptr i8, i8* %sect.cur, i64 40
  %more = icmp ult i32 %i.next, %numsec32
  br i1 %more, label %loop, label %retnull

retsect:
  ret i8* %sect.cur

retnull:
  ret i8* null
}