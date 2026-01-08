target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @sub_140002700(i8*)
declare i32 @"loc_140002705+3"(i8*, i8*, i32)

define i8* @sub_1400021B0(i8* %rcx) {
entry:
  %call.len = call i64 @sub_140002700(i8* %rcx)
  %cmp.len = icmp ugt i64 %call.len, 8
  br i1 %cmp.len, label %fail, label %check_off

check_off:
  %imgbase = load i8*, i8** @off_1400043C0, align 8
  %mz.ptr = bitcast i8* %imgbase to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %mz.ok = icmp eq i16 %mz, 23117
  br i1 %mz.ok, label %parse_nt, label %fail

parse_nt:
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %imgbase, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %imgbase, i64 %e_lfanew.sext
  %sig.ptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %sig.ok = icmp eq i32 %sig, 17744
  br i1 %sig.ok, label %check_opt, label %fail

check_opt:
  %opt.magic.ptr.i8 = getelementptr i8, i8* %nt, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 1
  %is.20b = icmp eq i16 %opt.magic, 523
  br i1 %is.20b, label %check_sections_nonzero, label %fail

check_sections_nonzero:
  %numsec.ptr.i8 = getelementptr i8, i8* %nt, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec = load i16, i16* %numsec.ptr, align 1
  %has.sections = icmp ne i16 %numsec, 0
  br i1 %has.sections, label %setup_loop, label %fail

setup_loop:
  %soh.ptr.i8 = getelementptr i8, i8* %nt, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh = load i16, i16* %soh.ptr, align 1
  %soh.z = zext i16 %soh to i64
  %first.sec.base = getelementptr i8, i8* %nt, i64 24
  %rbx0 = getelementptr i8, i8* %first.sec.base, i64 %soh.z
  br label %loop

loop:
  %i = phi i32 [ 0, %setup_loop ], [ %i.next, %cont ]
  %rbx.cur = phi i8* [ %rbx0, %setup_loop ], [ %rbx.next, %cont ]
  %call.cmp = call i32 @"loc_140002705+3"(i8* %rbx.cur, i8* %rcx, i32 8)
  %is.zero = icmp eq i32 %call.cmp, 0
  br i1 %is.zero, label %ret_rbx, label %cont

ret_rbx:
  ret i8* %rbx.cur

cont:
  %numsec2 = load i16, i16* %numsec.ptr, align 1
  %i.next = add i32 %i, 1
  %rbx.next = getelementptr i8, i8* %rbx.cur, i64 40
  %numsec2.z = zext i16 %numsec2 to i32
  %more = icmp ult i32 %i.next, %numsec2.z
  br i1 %more, label %loop, label %fail

fail:
  ret i8* null
}