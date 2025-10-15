; ModuleID = 'module'
source_filename = "module"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i8* @sub_1400026D0(i64 %rcx) {
entry:
  %baseptr.addr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %baseptr.addr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %check_pe, label %ret_null

check_pe:                                         ; preds = %entry
  %e_lfanew.ptr.i8 = getelementptr inbounds i8, i8* %baseptr.addr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %pehdr.ptr = getelementptr inbounds i8, i8* %baseptr.addr, i64 %e_lfanew.sext
  %pe.sig.ptr = bitcast i8* %pehdr.ptr to i32*
  %pe.sig = load i32, i32* %pe.sig.ptr, align 1
  %cmp_pe = icmp eq i32 %pe.sig, 17744
  br i1 %cmp_pe, label %check_magic, label %ret_null

check_magic:                                      ; preds = %check_pe
  %magic.ptr.i8 = getelementptr inbounds i8, i8* %pehdr.ptr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %get_numsec, label %ret_null

get_numsec:                                       ; preds = %check_magic
  %numsec.ptr.i8 = getelementptr inbounds i8, i8* %pehdr.ptr, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec.zext = zext i16 %numsec16 to i64
  %numsec.iszero = icmp eq i64 %numsec.zext, 0
  br i1 %numsec.iszero, label %ret_null, label %compute_first

compute_first:                                    ; preds = %get_numsec
  %sizeofopt.ptr.i8 = getelementptr inbounds i8, i8* %pehdr.ptr, i64 20
  %sizeofopt.ptr = bitcast i8* %sizeofopt.ptr.i8 to i16*
  %sizeofopt16 = load i16, i16* %sizeofopt.ptr, align 1
  %sizeofopt.zext = zext i16 %sizeofopt16 to i64
  %opt_end = getelementptr inbounds i8, i8* %pehdr.ptr, i64 24
  %first_sect = getelementptr inbounds i8, i8* %opt_end, i64 %sizeofopt.zext
  %n.mul40 = mul nuw i64 %numsec.zext, 40
  %end_ptr = getelementptr inbounds i8, i8* %first_sect, i64 %n.mul40
  br label %loop

loop:                                             ; preds = %after_exec, %compute_first
  %curr = phi i8* [ %first_sect, %compute_first ], [ %next, %after_exec ]
  %rcx.cur = phi i64 [ %rcx, %compute_first ], [ %rcx.next, %after_exec ]
  %char.byte.ptr = getelementptr inbounds i8, i8* %curr, i64 39
  %char.byte = load i8, i8* %char.byte.ptr, align 1
  %mask = and i8 %char.byte, 32
  %is_exec = icmp ne i8 %mask, 0
  br i1 %is_exec, label %if_exec, label %skip_dec

if_exec:                                          ; preds = %loop
  %is_zero = icmp eq i64 %rcx.cur, 0
  br i1 %is_zero, label %ret_curr, label %dec

dec:                                              ; preds = %if_exec
  %rcx.dec = add i64 %rcx.cur, -1
  br label %after_exec

skip_dec:                                         ; preds = %loop
  br label %after_exec

after_exec:                                       ; preds = %skip_dec, %dec
  %rcx.next = phi i64 [ %rcx.dec, %dec ], [ %rcx.cur, %skip_dec ]
  %next = getelementptr inbounds i8, i8* %curr, i64 40
  %cmp_end = icmp ne i8* %next, %end_ptr
  br i1 %cmp_end, label %loop, label %ret_null

ret_curr:                                         ; preds = %if_exec
  ret i8* %curr

ret_null:                                         ; preds = %after_exec, %get_numsec, %check_magic, %check_pe, %entry
  ret i8* null
}