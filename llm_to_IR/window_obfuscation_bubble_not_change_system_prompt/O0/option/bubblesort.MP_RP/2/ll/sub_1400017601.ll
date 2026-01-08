; ModuleID = 'sub_140001760.ll'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_140001700(i8*, ...)

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@qword_140008298 = external global i64 (i8*, i8*, i64)*
@qword_140008290 = external global i32 (i8*, i64, i32, i32*)*
@qword_140008260 = external global i32 ()*

@aVirtualprotect = external constant [0 x i8]
@aVirtualqueryFa = external constant [0 x i8]
@aAddressPHasNoI = external constant [0 x i8]

define void @sub_140001760(i8* %arg.addr) {
entry:
  %meminfo = alloca [48 x i8], align 8
  %n0 = load i32, i32* @dword_1400070A4, align 4
  %cmp_gt0 = icmp sgt i32 %n0, 0
  br i1 %cmp_gt0, label %loop.setup, label %label_1890

loop.setup:                                       ; preds = %entry
  %base0.ptrptr = load i8*, i8** @qword_1400070A8, align 8
  br label %loop.header

loop.header:                                      ; preds = %loop.setup, %loop.inc
  %i.ph = phi i32 [ 0, %loop.setup ], [ %i.next, %loop.inc ]
  %addr_int = ptrtoint i8* %arg.addr to i64
  %idx.z = zext i32 %i.ph to i64
  %off.mul = mul i64 %idx.z, 40
  %entry.ptr = getelementptr i8, i8* %base0.ptrptr, i64 %off.mul
  %p.addr.field = getelementptr i8, i8* %entry.ptr, i64 24
  %p.addr.field.cast = bitcast i8* %p.addr.field to i8**
  %entry.addr.val = load i8*, i8** %p.addr.field.cast, align 8
  %entry.addr.int = ptrtoint i8* %entry.addr.val to i64
  %cmp_jb = icmp ult i64 %addr_int, %entry.addr.int
  br i1 %cmp_jb, label %loop.inc, label %after_jb

after_jb:                                         ; preds = %loop.header
  %p.struct.field = getelementptr i8, i8* %entry.ptr, i64 32
  %p.struct.field.cast = bitcast i8* %p.struct.field to i8**
  %struct.ptr = load i8*, i8** %p.struct.field.cast, align 8
  %size.ptr = getelementptr i8, i8* %struct.ptr, i64 8
  %size.ptr.cast = bitcast i8* %size.ptr to i32*
  %size32 = load i32, i32* %size.ptr.cast, align 4
  %size64 = zext i32 %size32 to i64
  %end.int = add i64 %entry.addr.int, %size64
  %cmp_in = icmp ult i64 %addr_int, %end.int
  br i1 %cmp_in, label %ret_epilogue, label %loop.inc

loop.inc:                                         ; preds = %after_jb, %loop.header
  %i.next = add i32 %i.ph, 1
  %cmp.cont = icmp slt i32 %i.next, %n0
  br i1 %cmp.cont, label %loop.header, label %call_new_entry

label_1890:                                       ; preds = %entry, %vp_fail
  br label %call_new_entry_setup0

call_new_entry_setup0:                            ; preds = %label_1890
  br label %call_new_entry

call_new_entry:                                   ; preds = %loop.inc, %call_new_entry_setup0
  %insert.count = phi i32 [ %n0, %loop.inc ], [ 0, %call_new_entry_setup0 ]
  %rdi.new = call i8* @sub_140002250(i8* %arg.addr)
  %isnull = icmp eq i8* %rdi.new, null
  br i1 %isnull, label %label_18b2, label %after_nonnull

after_nonnull:                                    ; preds = %call_new_entry
  %base1.ptr = load i8*, i8** @qword_1400070A8, align 8
  %cnt64 = sext i32 %insert.count to i64
  %off.mul2 = mul i64 %cnt64, 40
  %entry.ptr2 = getelementptr i8, i8* %base1.ptr, i64 %off.mul2
  %at20 = getelementptr i8, i8* %entry.ptr2, i64 32
  %at20.cast = bitcast i8* %at20 to i8**
  store i8* %rdi.new, i8** %at20.cast, align 8
  %at0.cast = bitcast i8* %entry.ptr2 to i32*
  store i32 0, i32* %at0.cast, align 4
  %base.ret = call i8* @sub_140002390()
  %rdi.plus.c = getelementptr i8, i8* %rdi.new, i64 12
  %rdi.plus.c.cast = bitcast i8* %rdi.plus.c to i32*
  %off.c = load i32, i32* %rdi.plus.c.cast, align 4
  %off.c.z = zext i32 %off.c to i64
  %addr.query = getelementptr i8, i8* %base.ret, i64 %off.c.z
  %at18 = getelementptr i8, i8* %entry.ptr2, i64 24
  %at18.cast = bitcast i8* %at18 to i8**
  store i8* %addr.query, i8** %at18.cast, align 8
  %fn.vq.ptr = load i64 (i8*, i8*, i64)*, i64 (i8*, i8*, i64)** @qword_140008298, align 8
  %mem.ptr.i8 = bitcast [48 x i8]* %meminfo to i8*
  %vq.ret = call i64 %fn.vq.ptr(i8* %addr.query, i8* %mem.ptr.i8, i64 48)
  %vq.zero = icmp eq i64 %vq.ret, 0
  br i1 %vq.zero, label %label_1897, label %after_vq_success

after_vq_success:                                 ; preds = %after_nonnull
  %prot.ptr.i8 = getelementptr i8, i8* %mem.ptr.i8, i64 36
  %prot.ptr = bitcast i8* %prot.ptr.i8 to i32*
  %prot.val = load i32, i32* %prot.ptr, align 4
  %t1 = sub i32 %prot.val, 4
  %t1a = and i32 %t1, 4294967291
  %cond1 = icmp eq i32 %t1a, 0
  br i1 %cond1, label %inc_and_ret, label %check2

check2:                                           ; preds = %after_vq_success
  %t2 = sub i32 %prot.val, 64
  %t2a = and i32 %t2, 4294967231
  %cond2 = icmp eq i32 %t2a, 0
  br i1 %cond2, label %inc_and_ret, label %label_1840

inc_and_ret:                                      ; preds = %check2, %after_vq_success, %vp_ok
  %oldn1 = load i32, i32* @dword_1400070A4, align 4
  %newn1 = add i32 %oldn1, 1
  store i32 %newn1, i32* @dword_1400070A4, align 4
  br label %ret_epilogue

label_1840:                                       ; preds = %check2
  %is.ro = icmp eq i32 %prot.val, 2
  %newProt.sel = select i1 %is.ro, i32 4, i32 64
  %baseaddr.ptr = bitcast i8* %mem.ptr.i8 to i8**
  %baseaddr = load i8*, i8** %baseaddr.ptr, align 8
  %regionsize.ptr.i8 = getelementptr i8, i8* %mem.ptr.i8, i64 24
  %regionsize.ptr = bitcast i8* %regionsize.ptr.i8 to i64*
  %regionsize = load i64, i64* %regionsize.ptr, align 8
  %entry.plus8 = getelementptr i8, i8* %entry.ptr2, i64 8
  %entry.plus8.cast = bitcast i8* %entry.plus8 to i8**
  store i8* %baseaddr, i8** %entry.plus8.cast, align 8
  %entry.plus10 = getelementptr i8, i8* %entry.ptr2, i64 16
  %entry.plus10.cast = bitcast i8* %entry.plus10 to i64*
  store i64 %regionsize, i64* %entry.plus10.cast, align 8
  %oldprot.ptr = bitcast i8* %entry.ptr2 to i32*
  %fn.vp.ptr = load i32 (i8*, i64, i32, i32*)*, i32 (i8*, i64, i32, i32*)** @qword_140008290, align 8
  %vp.res = call i32 %fn.vp.ptr(i8* %baseaddr, i64 %regionsize, i32 %newProt.sel, i32* %oldprot.ptr)
  %vp.ok = icmp ne i32 %vp.res, 0
  br i1 %vp.ok, label %inc_and_ret, label %vp_fail

vp_fail:                                          ; preds = %label_1840
  %fn.gle.ptr = load i32 ()*, i32 ()** @qword_140008260, align 8
  %gle.ret = call i32 %fn.gle.ptr()
  %fmt.vp = getelementptr [0 x i8], [0 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt.vp, i32 %gle.ret)
  br label %label_1890

label_1897:                                       ; preds = %after_nonnull
  %base3.ptr = load i8*, i8** @qword_1400070A8, align 8
  %rdi.plus8 = getelementptr i8, i8* %rdi.new, i64 8
  %rdi.plus8.cast = bitcast i8* %rdi.plus8 to i32*
  %bytes.val = load i32, i32* %rdi.plus8.cast, align 4
  %fmt.vq = getelementptr [0 x i8], [0 x i8]* @aVirtualqueryFa, i64 0, i64 0
  %entry.plus18.ldptr = getelementptr i8, i8* %entry.ptr2, i64 24
  %entry.plus18.ldptr.cast = bitcast i8* %entry.plus18.ldptr to i8**
  %addr.stored = load i8*, i8** %entry.plus18.ldptr.cast, align 8
  call void (i8*, ...) @sub_140001700(i8* %fmt.vq, i32 %bytes.val, i8* %addr.stored)
  %fmt.noimg = getelementptr [0 x i8], [0 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt.noimg, i8* %arg.addr)
  br label %ret_epilogue

label_18b2:                                       ; preds = %call_new_entry
  %fmt.noimg2 = getelementptr [0 x i8], [0 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt.noimg2, i8* %arg.addr)
  br label %ret_epilogue

ret_epilogue:                                     ; preds = %inc_and_ret, %after_jb, %label_1897, %label_18b2
  ret void
}