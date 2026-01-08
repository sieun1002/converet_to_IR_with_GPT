target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*, align 8

declare dso_local i64 @sub_140002700(i8*)
declare dso_local i32 @sub_140002708(i8*, i8*, i32)

define dso_local i8* @sub_1400021B0(i8* %arg) {
entry:
  %call = tail call i64 @sub_140002700(i8* %arg)
  %cmp = icmp ugt i64 %call, 8
  br i1 %cmp, label %ret_null, label %check_mz

ret_null:
  ret i8* null

check_mz:
  %base = load i8*, i8** @off_1400043C0, align 8
  %base16 = bitcast i8* %base to i16*
  %mz = load i16, i16* %base16, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %after_mz, label %ret_null

after_mz:
  %e_lfanew.p = getelementptr inbounds i8, i8* %base, i64 60
  %e_lfanew.p32 = bitcast i8* %e_lfanew.p to i32*
  %e_lfanew = load i32, i32* %e_lfanew.p32, align 4
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr inbounds i8, i8* %base, i64 %e_lfanew.sext
  %pe.sig.p32 = bitcast i8* %pehdr to i32*
  %pe.sig = load i32, i32* %pe.sig.p32, align 4
  %is_pe = icmp eq i32 %pe.sig, 17744
  br i1 %is_pe, label %check_optmagic, label %ret_null

check_optmagic:
  %opt.magic.p = getelementptr inbounds i8, i8* %pehdr, i64 24
  %opt.magic.p16 = bitcast i8* %opt.magic.p to i16*
  %opt.magic = load i16, i16* %opt.magic.p16, align 2
  %is_pep = icmp eq i16 %opt.magic, 523
  br i1 %is_pep, label %check_nsects, label %ret_null

check_nsects:
  %nsec.p = getelementptr inbounds i8, i8* %pehdr, i64 6
  %nsec.p16 = bitcast i8* %nsec.p to i16*
  %nsec = load i16, i16* %nsec.p16, align 2
  %has_sections = icmp ne i16 %nsec, 0
  br i1 %has_sections, label %prepare_loop, label %ret_null

prepare_loop:
  %szopt.p = getelementptr inbounds i8, i8* %pehdr, i64 20
  %szopt.p16 = bitcast i8* %szopt.p to i16*
  %szopt = load i16, i16* %szopt.p16, align 2
  %szopt.z = zext i16 %szopt to i64
  %sec0.tmp = getelementptr inbounds i8, i8* %pehdr, i64 %szopt.z
  %sec0 = getelementptr inbounds i8, i8* %sec0.tmp, i64 24
  br label %loop

loop:
  %rbx.cur = phi i8* [ %sec0, %prepare_loop ], [ %rbx.next, %loop.inc ]
  %i.cur = phi i32 [ 0, %prepare_loop ], [ %i.next, %loop.inc ]
  %call2 = tail call i32 @sub_140002708(i8* %rbx.cur, i8* %arg, i32 8)
  %is_zero = icmp eq i32 %call2, 0
  br i1 %is_zero, label %ret_found, label %loop.inc

loop.inc:
  %nsec.reload = load i16, i16* %nsec.p16, align 2
  %i.next = add i32 %i.cur, 1
  %rbx.next = getelementptr inbounds i8, i8* %rbx.cur, i64 40
  %nsec.reload.z = zext i16 %nsec.reload to i32
  %cont = icmp ult i32 %i.next, %nsec.reload.z
  br i1 %cont, label %loop, label %ret_null

ret_found:
  ret i8* %rbx.cur
}