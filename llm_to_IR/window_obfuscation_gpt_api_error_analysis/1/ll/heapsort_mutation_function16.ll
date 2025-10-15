; ModuleID = 'sub_140001B30_module'
target triple = "x86_64-pc-windows-msvc"

%struct.Entry = type { i32, i32, i8*, i64, i8*, i8* }
%struct.MEMORY_BASIC_INFORMATION = type { i8*, i8*, i32, i32, i64, i32, i32, i32 }

@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global %struct.Entry*, align 8

@aVirtualprotect = private unnamed_addr constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@aVirtualqueryFa = private unnamed_addr constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00", align 1
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002610(i8* %addr)
declare i8* @sub_140002750()
declare void @sub_140001AD0(i8*, ...)
declare i64 @VirtualQuery(i8* %lpAddress, %struct.MEMORY_BASIC_INFORMATION* %lpBuffer, i64 %dwLength)
declare i32 @VirtualProtect(i8* %lpAddress, i64 %dwSize, i32 %flNewProtect, i32* %lpflOldProtect)
declare i32 @GetLastError()

define void @sub_140001B30(i8* %addr) local_unnamed_addr {
entry:
  %buf = alloca %struct.MEMORY_BASIC_INFORMATION, align 8
  %cnt0 = load i32, i32* @dword_1400070A4, align 4
  %cnt_le_zero = icmp sle i32 %cnt0, 0
  br i1 %cnt_le_zero, label %loc_C60, label %loop_setup

loop_setup:
  %base_entries0 = load %struct.Entry*, %struct.Entry** @qword_1400070A8, align 8
  br label %loop_head

loop_head:
  %i = phi i32 [ 0, %loop_setup ], [ %i.next, %loop_inc ]
  %i_lt_cnt = icmp slt i32 %i, %cnt0
  br i1 %i_lt_cnt, label %loop_body, label %loc_B88

loop_body:
  %i.ext = sext i32 %i to i64
  %entry.ptr = getelementptr inbounds %struct.Entry, %struct.Entry* %base_entries0, i64 %i.ext
  %lpAddress.ptr = getelementptr inbounds %struct.Entry, %struct.Entry* %entry.ptr, i32 0, i32 4
  %lpAddress.val = load i8*, i8** %lpAddress.ptr, align 8
  %addr.int = ptrtoint i8* %addr to i64
  %start.int = ptrtoint i8* %lpAddress.val to i64
  %addr_lt_start = icmp ult i64 %addr.int, %start.int
  br i1 %addr_lt_start, label %loop_inc, label %check_within

check_within:
  %base.ptr.field = getelementptr inbounds %struct.Entry, %struct.Entry* %entry.ptr, i32 0, i32 2
  %base.ptr.val = load i8*, i8** %base.ptr.field, align 8
  %base.plus8 = getelementptr inbounds i8, i8* %base.ptr.val, i64 8
  %len32.ptr = bitcast i8* %base.plus8 to i32*
  %len32 = load i32, i32* %len32.ptr, align 4
  %len64 = zext i32 %len32 to i64
  %end.int = add i64 %start.int, %len64
  %addr_lt_end = icmp ult i64 %addr.int, %end.int
  br i1 %addr_lt_end, label %epilogue, label %loop_inc

loop_inc:
  %i.next = add i32 %i, 1
  br label %loop_head

loc_C60:
  br label %loc_B88

loc_B88:
  %insert_idx = phi i32 [ 0, %loc_C60 ], [ %cnt0, %loop_head ]
  %sect.ptr = call i8* @sub_140002610(i8* %addr)
  %sect_is_null = icmp eq i8* %sect.ptr, null
  br i1 %sect_is_null, label %loc_C82, label %have_sect

have_sect:
  %entries1 = load %struct.Entry*, %struct.Entry** @qword_1400070A8, align 8
  %idx.ext = sext i32 %insert_idx to i64
  %ins.entry = getelementptr inbounds %struct.Entry, %struct.Entry* %entries1, i64 %idx.ext
  %imgsec.ptr = getelementptr inbounds %struct.Entry, %struct.Entry* %ins.entry, i32 0, i32 5
  store i8* %sect.ptr, i8** %imgsec.ptr, align 8
  %oldprot.ptr = getelementptr inbounds %struct.Entry, %struct.Entry* %ins.entry, i32 0, i32 0
  store i32 0, i32* %oldprot.ptr, align 4
  %tmp.base = call i8* @sub_140002750()
  %off.ptr = getelementptr inbounds i8, i8* %sect.ptr, i64 12
  %off.i32.ptr = bitcast i8* %off.ptr to i32*
  %off.i32 = load i32, i32* %off.i32.ptr, align 4
  %off.i64 = zext i32 %off.i32 to i64
  %lpAddress.new = getelementptr inbounds i8, i8* %tmp.base, i64 %off.i64
  %lpAddress.store.ptr = getelementptr inbounds %struct.Entry, %struct.Entry* %ins.entry, i32 0, i32 4
  store i8* %lpAddress.new, i8** %lpAddress.store.ptr, align 8
  %vq.size = call i64 @VirtualQuery(i8* %lpAddress.new, %struct.MEMORY_BASIC_INFORMATION* %buf, i64 48)
  %vq.ok = icmp ne i64 %vq.size, 0
  br i1 %vq.ok, label %vq_success, label %loc_C67

vq_success:
  %prot.ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 6
  %prot = load i32, i32* %prot.ptr, align 4
  %is_rw = icmp eq i32 %prot, 4
  %is_xrw = icmp eq i32 %prot, 64
  %ok_prot = or i1 %is_rw, %is_xrw
  br i1 %ok_prot, label %loc_BFE, label %loc_C10

loc_C10:
  %is_ro = icmp eq i32 %prot, 2
  %newprot = select i1 %is_ro, i32 4, i32 64
  %baseaddr.ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 0
  %baseaddr = load i8*, i8** %baseaddr.ptr, align 8
  %regionsize.ptr = getelementptr inbounds %struct.MEMORY_BASIC_INFORMATION, %struct.MEMORY_BASIC_INFORMATION* %buf, i32 0, i32 4
  %regionsize = load i64, i64* %regionsize.ptr, align 8
  %basefield.ptr = getelementptr inbounds %struct.Entry, %struct.Entry* %ins.entry, i32 0, i32 2
  store i8* %baseaddr, i8** %basefield.ptr, align 8
  %sizefield.ptr = getelementptr inbounds %struct.Entry, %struct.Entry* %ins.entry, i32 0, i32 3
  store i64 %regionsize, i64* %sizefield.ptr, align 8
  %vp.res = call i32 @VirtualProtect(i8* %baseaddr, i64 %regionsize, i32 %newprot, i32* %oldprot.ptr)
  %vp.ok = icmp ne i32 %vp.res, 0
  br i1 %vp.ok, label %loc_BFE, label %vp_fail

vp_fail:
  %err = call i32 @GetLastError()
  %fmt.vp.ptr = getelementptr inbounds [39 x i8], [39 x i8]* @aVirtualprotect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.vp.ptr, i32 %err)
  br label %loc_C60

loc_C67:
  %entries2 = load %struct.Entry*, %struct.Entry** @qword_1400070A8, align 8
  %addr.logged.ptr = getelementptr inbounds %struct.Entry, %struct.Entry* %entries2, i64 %idx.ext
  %lpaddr.logged.field = getelementptr inbounds %struct.Entry, %struct.Entry* %addr.logged.ptr, i32 0, i32 4
  %lpaddr.logged = load i8*, i8** %lpaddr.logged.field, align 8
  %bytes.ptr = getelementptr inbounds i8, i8* %sect.ptr, i64 8
  %bytes.i32.ptr = bitcast i8* %bytes.ptr to i32*
  %bytes.i32 = load i32, i32* %bytes.i32.ptr, align 4
  %fmt.vq.ptr = getelementptr inbounds [49 x i8], [49 x i8]* @aVirtualqueryFa, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.vq.ptr, i32 %bytes.i32, i8* %lpaddr.logged)
  br label %loc_C82

loc_C82:
  %fmt.noimg.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %fmt.noimg.ptr, i8* %addr)
  br label %epilogue

loc_BFE:
  %oldcnt = load i32, i32* @dword_1400070A4, align 4
  %newcnt = add i32 %oldcnt, 1
  store i32 %newcnt, i32* @dword_1400070A4, align 4
  br label %epilogue

epilogue:
  ret void
}