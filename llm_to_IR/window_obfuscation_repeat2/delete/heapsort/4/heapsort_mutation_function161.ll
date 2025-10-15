; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.MEMORY_BASIC_INFORMATION = type { i8*, i8*, i32, i32, i64, i32, i32, i32 }

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00"
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00"
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002610(i8*)
declare i8* @sub_140002750()

declare i64 @VirtualQuery(i8*, %struct.MEMORY_BASIC_INFORMATION*, i64)
declare i32 @VirtualProtect(i8*, i64, i32, i32*)
declare i32 @GetLastError()
declare void @sub_140001AD0(i8*, ...)

define void @sub_140001B30(i8* %rbx_param) local_unnamed_addr {
entry:
  %count0 = load i32, i32* @dword_1400070A4, align 4
  %pos = icmp sgt i32 %count0, 0
  br i1 %pos, label %loop.init, label %no_count

loop.init:
  %base.ptr = load i8*, i8** @qword_1400070A8, align 8
  %scan.start = getelementptr i8, i8* %base.ptr, i64 24
  br label %loop

loop:
  %i = phi i32 [ 0, %loop.init ], [ %i.next, %cont ]
  %scan.ptr = phi i8* [ %scan.start, %loop.init ], [ %scan.next, %cont ]
  %start.addr.pp = bitcast i8* %scan.ptr to i8**
  %start.addr = load i8*, i8** %start.addr.pp, align 8
  %rbx_lt_start = icmp ult i8* %rbx_param, %start.addr
  br i1 %rbx_lt_start, label %cont, label %check_end

check_end:
  %ptr_rdi_loc = getelementptr i8, i8* %scan.ptr, i64 8
  %ptr_rdi_pp = bitcast i8* %ptr_rdi_loc to i8**
  %ptr_rdi = load i8*, i8** %ptr_rdi_pp, align 8
  %len32.ptr = getelementptr i8, i8* %ptr_rdi, i64 8
  %len32.ip = bitcast i8* %len32.ptr to i32*
  %len32 = load i32, i32* %len32.ip, align 4
  %len64 = zext i32 %len32 to i64
  %start.int = ptrtoint i8* %start.addr to i64
  %end.int = add i64 %start.int, %len64
  %rbx.int = ptrtoint i8* %rbx_param to i64
  %inrange = icmp ult i64 %rbx.int, %end.int
  br i1 %inrange, label %ret, label %cont

cont:
  %i.next = add i32 %i, 1
  %scan.next = getelementptr i8, i8* %scan.ptr, i64 40
  %more = icmp ne i32 %i.next, %count0
  br i1 %more, label %loop, label %call_path

no_count:
  br label %call_path

call_path:
  %rsi.phi = phi i32 [ 0, %no_count ], [ %count0, %cont ], [ 0, %vp_fail ]
  %rdi.val = call i8* @sub_140002610(i8* %rbx_param)
  %isnull = icmp eq i8* %rdi.val, null
  br i1 %isnull, label %no_image_section, label %have_rdi

have_rdi:
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %rsi64 = sext i32 %rsi.phi to i64
  %mul5 = mul i64 %rsi64, 5
  %offset = shl i64 %mul5, 3
  %entry.ptr = getelementptr i8, i8* %base2, i64 %offset
  %field20 = getelementptr i8, i8* %entry.ptr, i64 32
  %field20.pp = bitcast i8* %field20 to i8**
  store i8* %rdi.val, i8** %field20.pp, align 8
  %field0 = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %field0, align 4
  %rax2 = call i8* @sub_140002750()
  %rdi.plus.c = getelementptr i8, i8* %rdi.val, i64 12
  %rdi.plus.c.ip = bitcast i8* %rdi.plus.c to i32*
  %edx.val = load i32, i32* %rdi.plus.c.ip, align 4
  %edx64 = zext i32 %edx.val to i64
  %rcx.addr = getelementptr i8, i8* %rax2, i64 %edx64
  %field18 = getelementptr i8, i8* %entry.ptr, i64 24
  %field18.pp = bitcast i8* %field18 to i8**
  store i8* %rcx.addr, i8** %field18.pp, align 8
  %buf = alloca %struct.MEMORY_BASIC_INFORMATION, align 8
  %vqret = call i64 @VirtualQuery(i8* %rcx.addr, %struct.MEMORY_BASIC_INFORMATION* %buf, i64 48)
  %vqzero = icmp eq i64 %vqret, 0
  br i1 %vqzero, label %vqfail, label %after_vq

vqfail:
  %rdi.plus.8 = getelementptr i8, i8* %rdi.val, i64 8
  %rdi.plus.8.ip = bitcast i8* %rdi.plus.8 to i32*
  %bytes = load i32, i32* %rdi.plus.8.ip, align 4
  %fmt2.gep = getelementptr [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  %fmt2.ptr = bitcast i8* %fmt2.gep to i8*
  %saved.addr = load i8*, i8** %field18.pp, align 8
  call void (i8*, ...) @sub_140001AD0(i8* %fmt2.ptr, i32 %bytes, i8* %saved.addr)
  br label %no_image_section

after_vq:
  %protect.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 6
  %protect = load i32, i32* %protect.ptr, align 4
  %t1 = add i32 %protect, -4
  %mask1 = and i32 %t1, -5
  %is_zero1 = icmp eq i32 %mask1, 0
  br i1 %is_zero1, label %inc_count, label %check2

check2:
  %t2 = add i32 %protect, -64
  %mask2 = and i32 %t2, -65
  %nz2 = icmp ne i32 %mask2, 0
  br i1 %nz2, label %do_prot, label %inc_count

do_prot:
  %is2 = icmp eq i32 %protect, 2
  %fl = select i1 %is2, i32 4, i32 64
  %baseaddr.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 0
  %baseaddr = load i8*, i8** %baseaddr.ptr, align 8
  %regionsize.ptr = getelementptr %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 4
  %regionsize = load i64, i64* %regionsize.ptr, align 8
  %entry.plus.8 = getelementptr i8, i8* %entry.ptr, i64 8
  %entry.plus.8.pp = bitcast i8* %entry.plus.8 to i8**
  store i8* %baseaddr, i8** %entry.plus.8.pp, align 8
  %entry.plus.16 = getelementptr i8, i8* %entry.ptr, i64 16
  %entry.plus.16.p = bitcast i8* %entry.plus.16 to i64*
  store i64 %regionsize, i64* %entry.plus.16.p, align 8
  %oldprot.ptr = bitcast i8* %entry.ptr to i32*
  %vpok = call i32 @VirtualProtect(i8* %baseaddr, i64 %regionsize, i32 %fl, i32* %oldprot.ptr)
  %ok = icmp ne i32 %vpok, 0
  br i1 %ok, label %inc_count, label %vp_fail

vp_fail:
  %err = call i32 @GetLastError()
  %fmt1.gep = getelementptr [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  %fmt1.ptr = bitcast i8* %fmt1.gep to i8*
  call void (i8*, ...) @sub_140001AD0(i8* %fmt1.ptr, i32 %err)
  br label %call_path

inc_count:
  %oldcnt = load i32, i32* @dword_1400070A4, align 4
  %newcnt = add i32 %oldcnt, 1
  store i32 %newcnt, i32* @dword_1400070A4, align 4
  br label %ret

no_image_section:
  %fmt3.gep = getelementptr [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  %fmt3.ptr = bitcast i8* %fmt3.gep to i8*
  call void (i8*, ...) @sub_140001AD0(i8* %fmt3.ptr, i8* %rbx_param)
  br label %ret

ret:
  ret void
}