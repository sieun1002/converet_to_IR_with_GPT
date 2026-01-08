; ModuleID = 'sub_1400021B0'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external dso_local global i8*

declare dso_local i64 @strlen(i8* noundef)
declare dso_local i32 @strncmp(i8* noundef, i8* noundef, i64 noundef)

define dso_local i8* @sub_1400021B0(i8* noundef %arg) {
entry:
  %len = call i64 @strlen(i8* noundef %arg)
  %cmp_len = icmp ugt i64 %len, 8
  br i1 %cmp_len, label %fail, label %check_mz

check_mz:                                            ; preds = %entry
  %base = load i8*, i8** @off_1400043C0, align 8
  %mz.ptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %nt_init, label %fail

nt_init:                                             ; preds = %check_mz
  %e_lfanew.ptr.i8 = getelementptr inbounds i8, i8* %base, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew = sext i32 %e_lfanew32 to i64
  %nt = getelementptr inbounds i8, i8* %base, i64 %e_lfanew
  %pe.ptr = bitcast i8* %nt to i32*
  %pe = load i32, i32* %pe.ptr, align 1
  %is_pe = icmp eq i32 %pe, 17744
  br i1 %is_pe, label %check_magic, label %fail

check_magic:                                         ; preds = %nt_init
  %opt.magic.ptr.i8 = getelementptr inbounds i8, i8* %nt, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 1
  %is_pe32plus = icmp eq i16 %opt.magic, 523
  br i1 %is_pe32plus, label %check_numsects, label %fail

check_numsects:                                      ; preds = %check_magic
  %numsects.ptr.i8 = getelementptr inbounds i8, i8* %nt, i64 6
  %numsects.ptr = bitcast i8* %numsects.ptr.i8 to i16*
  %numsects = load i16, i16* %numsects.ptr, align 1
  %numsects_is_zero = icmp eq i16 %numsects, 0
  br i1 %numsects_is_zero, label %fail, label %init_loop

init_loop:                                           ; preds = %check_numsects
  %opt.size.ptr.i8 = getelementptr inbounds i8, i8* %nt, i64 20
  %opt.size.ptr = bitcast i8* %opt.size.ptr.i8 to i16*
  %opt.size16 = load i16, i16* %opt.size.ptr, align 1
  %opt.size = zext i16 %opt.size16 to i64
  %sec0.off = add i64 %opt.size, 24
  %secptr0 = getelementptr inbounds i8, i8* %nt, i64 %sec0.off
  br label %loop

loop:                                                ; preds = %loop_continue, %init_loop
  %secptr = phi i8* [ %secptr0, %init_loop ], [ %secptr.next, %loop_continue ]
  %i = phi i32 [ 0, %init_loop ], [ %i.next, %loop_continue ]
  %cmpres = call i32 @strncmp(i8* noundef %secptr, i8* noundef %arg, i64 noundef 8)
  %eq = icmp eq i32 %cmpres, 0
  br i1 %eq, label %found, label %loop_continue

loop_continue:                                       ; preds = %loop
  %numsects2.ptr.i8 = getelementptr inbounds i8, i8* %nt, i64 6
  %numsects2.ptr = bitcast i8* %numsects2.ptr.i8 to i16*
  %numsects2 = load i16, i16* %numsects2.ptr, align 1
  %i.next = add i32 %i, 1
  %secptr.next = getelementptr inbounds i8, i8* %secptr, i64 40
  %numsects2.i32 = zext i16 %numsects2 to i32
  %cont = icmp ult i32 %i.next, %numsects2.i32
  br i1 %cont, label %loop, label %fail

found:                                               ; preds = %loop
  ret i8* %secptr

fail:                                                ; preds = %loop_continue, %check_numsects, %check_magic, %nt_init, %check_mz, %entry
  ret i8* null
}