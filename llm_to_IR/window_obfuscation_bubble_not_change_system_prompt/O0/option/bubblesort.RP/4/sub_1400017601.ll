; ModuleID = 'sub_140001760'
target triple = "x86_64-pc-windows-msvc"

%struct.MEMORY_BASIC_INFORMATION = type { i8*, i8*, i32, i32, i64, i32, i32, i32 }
%fn.VirtualQuery = type i64 (i8*, %struct.MEMORY_BASIC_INFORMATION*, i64)
%fn.VirtualProtect = type i32 (i8*, i64, i32, i32*)
%fn.GetLastError = type i32 ()

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@__imp_VirtualQuery = external global %fn.VirtualQuery*
@__imp_VirtualProtect = external global %fn.VirtualProtect*
@__imp_GetLastError = external global %fn.GetLastError*

@aVirtualprotect = external global i8
@aVirtualqueryFa = external global i8
@aAddressPHasNoI = external global i8

declare i8* @sub_140002250(i8* %addr)
declare i8* @sub_140002390()
declare void @sub_140001700(i8*, ...)

define void @sub_140001760(i8* %addr) {
entry:
  %mbi = alloca %struct.MEMORY_BASIC_INFORMATION, align 8
  %count0 = load i32, i32* @dword_1400070A4, align 4
  %pos = icmp sgt i32 %count0, 0
  br i1 %pos, label %preloop, label %afterloop_init

preloop:
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %addr_int0 = ptrtoint i8* %addr to i64
  br label %loop

loop:
  %i = phi i32 [ 0, %preloop ], [ %i.next, %iter ]
  %i.z = zext i32 %i to i64
  %off.bytes = mul i64 %i.z, 40
  %ptr.start.field = getelementptr i8, i8* %base0, i64 24
  %ptr.start.entry = getelementptr i8, i8* %ptr.start.field, i64 %off.bytes
  %ptr.start.entry.cast = bitcast i8* %ptr.start.entry to i8**
  %start = load i8*, i8** %ptr.start.entry.cast, align 8
  %start_int = ptrtoint i8* %start to i64
  %below = icmp ult i64 %addr_int0, %start_int
  br i1 %below, label %iter, label %check_in_range

check_in_range:
  %ptr.rdi.field = getelementptr i8, i8* %base0, i64 32
  %ptr.rdi.entry = getelementptr i8, i8* %ptr.rdi.field, i64 %off.bytes
  %ptr.rdi.entry.cast = bitcast i8* %ptr.rdi.entry to i8**
  %rdi_load = load i8*, i8** %ptr.rdi.entry.cast, align 8
  %rdi_len_ptr.i8 = getelementptr i8, i8* %rdi_load, i64 8
  %rdi_len_ptr = bitcast i8* %rdi_len_ptr.i8 to i32*
  %len32 = load i32, i32* %rdi_len_ptr, align 4
  %len64 = zext i32 %len32 to i64
  %end.ptr = getelementptr i8, i8* %start, i64 %len64
  %end_int = ptrtoint i8* %end.ptr to i64
  %inrange = icmp ult i64 %addr_int0, %end_int
  br i1 %inrange, label %early_ret, label %iter

iter:
  %i.next = add i32 %i, 1
  %cmp.end = icmp ne i32 %i.next, %count0
  br i1 %cmp.end, label %loop, label %afterloop_init

early_ret:
  ret void

afterloop_init:
  %idx.sel = select i1 %pos, i32 %count0, i32 0
  %rdi = call i8* @sub_140002250(i8* %addr)
  %isnull = icmp eq i8* %rdi, null
  br i1 %isnull, label %no_image, label %have_image

no_image:
  call void (i8*, ...) @sub_140001700(i8* @aAddressPHasNoI, i8* %addr)
  ret void

have_image:
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = zext i32 %idx.sel to i64
  %entry.off = mul i64 %idx64, 40
  %entry.ptr = getelementptr i8, i8* %base1, i64 %entry.off
  %oldprot.ptr = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %oldprot.ptr, align 4
  %entry.rdi.ptr.i8 = getelementptr i8, i8* %entry.ptr, i64 32
  %entry.rdi.ptr = bitcast i8* %entry.rdi.ptr.i8 to i8**
  store i8* %rdi, i8** %entry.rdi.ptr, align 8
  %map = call i8* @sub_140002390()
  %rdi_off12.i8 = getelementptr i8, i8* %rdi, i64 12
  %rdi_off12 = bitcast i8* %rdi_off12.i8 to i32*
  %off32 = load i32, i32* %rdi_off12, align 4
  %off64 = zext i32 %off32 to i64
  %target = getelementptr i8, i8* %map, i64 %off64
  %entry.addr.ptr.i8 = getelementptr i8, i8* %entry.ptr, i64 24
  %entry.addr.ptr = bitcast i8* %entry.addr.ptr.i8 to i8**
  store i8* %target, i8** %entry.addr.ptr, align 8
  %impVQ.ptr = load %fn.VirtualQuery*, %fn.VirtualQuery** @__imp_VirtualQuery, align 8
  %vq.ret = call i64 %impVQ.ptr(i8* %target, %struct.MEMORY_BASIC_INFORMATION* %mbi, i64 48)
  %vq.zero = icmp eq i64 %vq.ret, 0
  br i1 %vq.zero, label %vq_fail, label %vq_ok

vq_ok:
  %prot.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 6
  %prot = load i32, i32* %prot.ptr, align 4
  %t1 = sub i32 %prot, 4
  %t2 = and i32 %t1, 4294967291
  %is_ok1 = icmp eq i32 %t2, 0
  br i1 %is_ok1, label %inc_count, label %check2

check2:
  %t3 = sub i32 %prot, 64
  %t4 = and i32 %t3, 4294967231
  %need_vp = icmp ne i32 %t4, 0
  br i1 %need_vp, label %do_vp, label %inc_count

do_vp:
  %is_ro = icmp eq i32 %prot, 2
  %np_rw = select i1 %is_ro, i32 4, i32 64
  %baseaddr.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 0
  %baseaddr = load i8*, i8** %baseaddr.ptr, align 8
  %regionsize.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %mbi, i32 0, i32 4
  %regionsize = load i64, i64* %regionsize.ptr, align 8
  %entry.save.addr.i8 = getelementptr i8, i8* %entry.ptr, i64 8
  %entry.save.addr = bitcast i8* %entry.save.addr.i8 to i8**
  store i8* %baseaddr, i8** %entry.save.addr, align 8
  %entry.save.size.i8 = getelementptr i8, i8* %entry.ptr, i64 16
  %entry.save.size = bitcast i8* %entry.save.size.i8 to i64*
  store i64 %regionsize, i64* %entry.save.size, align 8
  %impVP.ptr = load %fn.VirtualProtect*, %fn.VirtualProtect** @__imp_VirtualProtect, align 8
  %vp.ok = call i32 %impVP.ptr(i8* %baseaddr, i64 %regionsize, i32 %np_rw, i32* %oldprot.ptr)
  %vp.zero = icmp eq i32 %vp.ok, 0
  br i1 %vp.zero, label %vp_fail, label %inc_count

vp_fail:
  %impGLE.ptr = load %fn.GetLastError*, %fn.GetLastError** @__imp_GetLastError, align 8
  %gle = call i32 %impGLE.ptr()
  call void (i8*, ...) @sub_140001700(i8* @aVirtualprotect, i32 %gle)
  ret void

vq_fail:
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %rdi_len_ptr2.i8 = getelementptr i8, i8* %rdi, i64 8
  %rdi_len_ptr2 = bitcast i8* %rdi_len_ptr2.i8 to i32*
  %bytes = load i32, i32* %rdi_len_ptr2, align 4
  %entry.addr2.i8 = getelementptr i8, i8* %base2, i64 %entry.off
  %entry.addr2.field.i8 = getelementptr i8, i8* %entry.addr2.i8, i64 24
  %entry.addr2.field = bitcast i8* %entry.addr2.field.i8 to i8**
  %addr_arg = load i8*, i8** %entry.addr2.field, align 8
  call void (i8*, ...) @sub_140001700(i8* @aVirtualqueryFa, i32 %bytes, i8* %addr_arg)
  ret void

inc_count:
  %cnt3 = load i32, i32* @dword_1400070A4, align 4
  %cnt4 = add i32 %cnt3, 1
  store i32 %cnt4, i32* @dword_1400070A4, align 4
  ret void
}