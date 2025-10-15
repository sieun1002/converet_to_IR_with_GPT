; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

declare i64 @strlen(i8*)
declare i32 @strncmp(i8*, i8*, i64)

define i8* @sub_140002570(i8* %str) {
entry:
  %len = call i64 @strlen(i8* %str)
  %len_gt8 = icmp ugt i64 %len, 8
  br i1 %len_gt8, label %fail, label %check_mz

check_mz:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %after_mz_ok, label %fail

after_mz_ok:
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e64 = sext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base.ptr, i64 %e64
  %sig.ptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %fail

check_magic:
  %opt.magic.ptr.i8 = getelementptr i8, i8* %nt, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 1
  %magic_ok = icmp eq i16 %opt.magic, 523
  br i1 %magic_ok, label %check_numsec, label %fail

check_numsec:
  %numsec.ptr.i8 = getelementptr i8, i8* %nt, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %fail, label %prep_loop

prep_loop:
  %soh.ptr.i8 = getelementptr i8, i8* %nt, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh16 = load i16, i16* %soh.ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %sec.start = getelementptr i8, i8* %nt, i64 24
  %rbx0 = getelementptr i8, i8* %sec.start, i64 %soh64
  br label %loop

loop:
  %rbx.phi = phi i8* [ %rbx0, %prep_loop ], [ %rbx.next, %loop_continue ]
  %i.phi = phi i32 [ 0, %prep_loop ], [ %i.next, %loop_continue ]
  %cmpres = call i32 @strncmp(i8* %rbx.phi, i8* %str, i64 8)
  %is_zero = icmp eq i32 %cmpres, 0
  br i1 %is_zero, label %success, label %loop_continue

loop_continue:
  %numsec.reload16 = load i16, i16* %numsec.ptr, align 1
  %i.next = add i32 %i.phi, 1
  %numsec.i32 = zext i16 %numsec.reload16 to i32
  %cont = icmp ult i32 %i.next, %numsec.i32
  %rbx.next = getelementptr i8, i8* %rbx.phi, i64 40
  br i1 %cont, label %loop, label %fail

success:
  ret i8* %rbx.phi

fail:
  ret i8* null
}