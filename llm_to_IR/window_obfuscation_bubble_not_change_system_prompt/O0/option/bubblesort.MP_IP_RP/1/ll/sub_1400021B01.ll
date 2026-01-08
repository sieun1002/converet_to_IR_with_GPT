; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @sub_140002700()
declare i32 @sub_140002708(i8*, i8*, i32)

define i8* @sub_1400021B0(i8* %0) {
entry:
  %call0 = call i64 @sub_140002700()
  %cmp0 = icmp ugt i64 %call0, 8
  br i1 %cmp0, label %ret_zero, label %cont1

cont1:                                            ; preds = %entry
  %base.ptr = load i8*, i8** @off_1400043C0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz.val = load i16, i16* %mz.ptr, align 1
  %is.mz = icmp eq i16 %mz.val, 23117
  br i1 %is.mz, label %loc_1E8, label %ret_zero

loc_1E8:                                          ; preds = %cont1
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt.ptr = getelementptr i8, i8* %base.ptr, i64 %e_lfanew.sext
  %pe.sig.ptr = bitcast i8* %nt.ptr to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr, align 1
  %is.pe = icmp eq i32 %pe.sig, 17744
  br i1 %is.pe, label %check.opt.magic, label %ret_zero

check.opt.magic:                                  ; preds = %loc_1E8
  %opt.magic.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 1
  %is.20B = icmp eq i16 %opt.magic, 523
  br i1 %is.20B, label %check.sections.nonzero, label %ret_zero

check.sections.nonzero:                           ; preds = %check.opt.magic
  %numsect.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 6
  %numsect.ptr = bitcast i8* %numsect.ptr.i8 to i16*
  %numsect.val = load i16, i16* %numsect.ptr, align 1
  %numsect.nz = icmp ne i16 %numsect.val, 0
  br i1 %numsect.nz, label %loop.prep, label %ret_zero

loop.prep:                                        ; preds = %check.sections.nonzero
  %soh.ptr.i8 = getelementptr i8, i8* %nt.ptr, i64 20
  %soh.ptr = bitcast i8* %soh.ptr.i8 to i16*
  %soh.val = load i16, i16* %soh.ptr, align 1
  %soh.zext64 = zext i16 %soh.val to i64
  %rbx.base = getelementptr i8, i8* %nt.ptr, i64 24
  %rbx.start = getelementptr i8, i8* %rbx.base, i64 %soh.zext64
  br label %loop

loop:                                             ; preds = %after.call, %loop.prep
  %rbx.phi = phi i8* [ %rbx.start, %loop.prep ], [ %rbx.next, %after.call ]
  %esi.phi = phi i32 [ 0, %loop.prep ], [ %esi.next, %after.call ]
  %call1 = call i32 @sub_140002708(i8* %rbx.phi, i8* %0, i32 8)
  %is.zero = icmp eq i32 %call1, 0
  br i1 %is.zero, label %success.ret, label %after.call

after.call:                                       ; preds = %loop
  %numsect.reload = load i16, i16* %numsect.ptr, align 1
  %numsect.reload.zext = zext i16 %numsect.reload to i32
  %esi.next = add i32 %esi.phi, 1
  %rbx.next = getelementptr i8, i8* %rbx.phi, i64 40
  %cont.cond = icmp ult i32 %esi.next, %numsect.reload.zext
  br i1 %cont.cond, label %loop, label %ret_zero

success.ret:                                      ; preds = %loop
  ret i8* %rbx.phi

ret_zero:                                         ; preds = %after.call, %check.sections.nonzero, %check.opt.magic, %loc_1E8, %cont1, %entry
  ret i8* null
}