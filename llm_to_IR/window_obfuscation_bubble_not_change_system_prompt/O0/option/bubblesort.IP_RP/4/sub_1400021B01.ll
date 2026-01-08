; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*, align 8

declare i64 @sub_140002700(i8* noundef)
declare i32 @loc_140002705(i8*, i8*, i64)

define i8* @sub_1400021B0(i8* %rcx) {
entry:
  %call.len = call i64 @sub_140002700(i8* %rcx)
  %cmp.len = icmp ugt i64 %call.len, 8
  br i1 %cmp.len, label %ret.null, label %after.len

after.len:
  %imgbase = load i8*, i8** @off_1400043C0, align 8
  %imgbase.i16p = bitcast i8* %imgbase to i16*
  %mz = load i16, i16* %imgbase.i16p, align 1
  %is.mz = icmp eq i16 %mz, 23117
  br i1 %is.mz, label %chk.pe, label %ret.null

chk.pe:
  %dos.e_lfanew.p.i8 = getelementptr inbounds i8, i8* %imgbase, i64 60
  %dos.e_lfanew.p = bitcast i8* %dos.e_lfanew.p.i8 to i32*
  %e_lfanew = load i32, i32* %dos.e_lfanew.p, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt.i8 = getelementptr inbounds i8, i8* %imgbase, i64 %e_lfanew.sext
  %nt.sig.p = bitcast i8* %nt.i8 to i32*
  %pe.sig = load i32, i32* %nt.sig.p, align 1
  %is.pe = icmp eq i32 %pe.sig, 17744
  br i1 %is.pe, label %chk.magic, label %ret.null

chk.magic:
  %opt.magic.p.i8 = getelementptr inbounds i8, i8* %nt.i8, i64 24
  %opt.magic.p = bitcast i8* %opt.magic.p.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.p, align 1
  %is.20b = icmp eq i16 %opt.magic, 523
  br i1 %is.20b, label %chk.numsec, label %ret.null

chk.numsec:
  %numsec.p.i8 = getelementptr inbounds i8, i8* %nt.i8, i64 6
  %numsec.p = bitcast i8* %numsec.p.i8 to i16*
  %numsec16 = load i16, i16* %numsec.p, align 1
  %has.sec = icmp ne i16 %numsec16, 0
  br i1 %has.sec, label %prep.loop, label %ret.null

prep.loop:
  %soh.p.i8 = getelementptr inbounds i8, i8* %nt.i8, i64 20
  %soh.p = bitcast i8* %soh.p.i8 to i16*
  %soh16 = load i16, i16* %soh.p, align 1
  %soh = zext i16 %soh16 to i64
  %first.sec.base0 = getelementptr inbounds i8, i8* %nt.i8, i64 24
  %first.sec = getelementptr inbounds i8, i8* %first.sec.base0, i64 %soh
  %numsec32 = zext i16 %numsec16 to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %prep.loop ], [ %i.next, %cont ]
  %sec.ptr = phi i8* [ %first.sec, %prep.loop ], [ %sec.next, %cont ]
  %loc.ptr.int = ptrtoint i32 (i8*, i8*, i64)* @loc_140002705 to i64
  %loc.plus3 = add i64 %loc.ptr.int, 3
  %callee = inttoptr i64 %loc.plus3 to i32 (i8*, i8*, i64)*
  %cmp.call = call i32 %callee(i8* %sec.ptr, i8* %rcx, i64 8)
  %is.zero = icmp eq i32 %cmp.call, 0
  br i1 %is.zero, label %found, label %cont

found:
  ret i8* %sec.ptr

cont:
  %i.next = add i32 %i, 1
  %sec.next = getelementptr inbounds i8, i8* %sec.ptr, i64 40
  %more = icmp ult i32 %i.next, %numsec32
  br i1 %more, label %loop, label %ret.null

ret.null:
  ret i8* null
}