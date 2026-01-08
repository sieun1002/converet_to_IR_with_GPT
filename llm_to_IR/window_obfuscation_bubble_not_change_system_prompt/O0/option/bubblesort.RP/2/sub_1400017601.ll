; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8
@__imp_VirtualQuery = external global i64 (i8*, i8*, i64)*, align 8
@__imp_VirtualProtect = external global i32 (i8*, i64, i32, i32*)*, align 8
@__imp_GetLastError = external global i32 ()*, align 8
@aVirtualprotect = external global i8, align 1
@aVirtualqueryFa = external global i8, align 1
@aAddressPHasNoI = external global i8, align 1

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_140001700(i8*, ...)

define void @sub_140001760(i8* %addr) {
entry:
  %Buffer = alloca [48 x i8], align 8
  %cnt0 = load i32, i32* @dword_1400070A4, align 4
  %cnt_le = icmp sle i32 %cnt0, 0
  br i1 %cnt_le, label %loc_140001890, label %search_init

search_init:                                      ; preds = %entry
  %base0 = load i8*, i8** @qword_1400070A8, align 8
  %scanptr0 = getelementptr i8, i8* %base0, i64 24
  br label %loop

loop:                                             ; preds = %next_iter, %search_init
  %scanptr.ph = phi i8* [ %scanptr0, %search_init ], [ %scanptr.next, %next_iter ]
  %i.ph = phi i32 [ 0, %search_init ], [ %i.next, %next_iter ]
  %start.ptr = bitcast i8* %scanptr.ph to i8**
  %start = load i8*, i8** %start.ptr, align 8
  %lt.start = icmp ult i8* %addr, %start
  br i1 %lt.start, label %next_iter, label %check_end

check_end:                                        ; preds = %loop
  %desc.addr = getelementptr i8, i8* %scanptr.ph, i64 8
  %desc.ptr = bitcast i8* %desc.addr to i8**
  %desc = load i8*, i8** %desc.ptr, align 8
  %desc.size.addr = getelementptr i8, i8* %desc, i64 8
  %desc.size.p = bitcast i8* %desc.size.addr to i32*
  %desc.size32 = load i32, i32* %desc.size.p, align 4
  %desc.size64 = zext i32 %desc.size32 to i64
  %start.int = ptrtoint i8* %start to i64
  %end.int = add i64 %start.int, %desc.size64
  %end.ptr = inttoptr i64 %end.int to i8*
  %lt.end = icmp ult i8* %addr, %end.ptr
  br i1 %lt.end, label %found_ret, label %next_iter

next_iter:                                        ; preds = %check_end, %loop
  %i.next = add i32 %i.ph, 1
  %scanptr.next = getelementptr i8, i8* %scanptr.ph, i64 40
  %cont = icmp ne i32 %i.next, %cnt0
  br i1 %cont, label %loop, label %create_entry_prepare_from_loop

found_ret:                                        ; preds = %check_end
  br label %ret

create_entry_prepare_from_loop:                   ; preds = %next_iter
  br label %create_entry

loc_140001890:                                    ; preds = %entry, %vp_fail
  br label %create_entry

create_entry:                                     ; preds = %loc_140001890, %create_entry_prepare_from_loop
  %index = phi i32 [ 0, %loc_140001890 ], [ %cnt0, %create_entry_prepare_from_loop ]
  %desc.new = call i8* @sub_140002250(i8* %addr)
  %isnull = icmp eq i8* %desc.new, null
  br i1 %isnull, label %error_no_image_section, label %init_entry

init_entry:                                       ; preds = %create_entry
  %base1 = load i8*, i8** @qword_1400070A8, align 8
  %mul4 = mul i32 %index, 4
  %sum = add i32 %index, %mul4
  %sum64 = zext i32 %sum to i64
  %offset = shl i64 %sum64, 3
  %entry.ptr = getelementptr i8, i8* %base1, i64 %offset
  %entry.p20 = getelementptr i8, i8* %entry.ptr, i64 32
  %entry.p20.pp = bitcast i8* %entry.p20 to i8**
  store i8* %desc.new, i8** %entry.p20.pp, align 8
  %entry.p0 = bitcast i8* %entry.ptr to i32*
  store i32 0, i32* %entry.p0, align 4
  %baseRet = call i8* @sub_140002390()
  %desc.off.addr = getelementptr i8, i8* %desc.new, i64 12
  %desc.off.p = bitcast i8* %desc.off.addr to i32*
  %desc.off = load i32, i32* %desc.off.p, align 4
  %desc.off64 = zext i32 %desc.off to i64
  %baseRet.int = ptrtoint i8* %baseRet to i64
  %rcx.addr.int = add i64 %baseRet.int, %desc.off64
  %rcx.addr = inttoptr i64 %rcx.addr.int to i8*
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %entry.ptr2 = getelementptr i8, i8* %base2, i64 %offset
  %entry.p18 = getelementptr i8, i8* %entry.ptr2, i64 24
  %entry.p18.pp = bitcast i8* %entry.p18 to i8**
  store i8* %rcx.addr, i8** %entry.p18.pp, align 8
  %buf.ptr = getelementptr inbounds [48 x i8], [48 x i8]* %Buffer, i64 0, i64 0
  %impVQ = load i64 (i8*, i8*, i64)*, i64 (i8*, i8*, i64)** @__imp_VirtualQuery, align 8
  %vq.ret = call i64 %impVQ(i8* %rcx.addr, i8* %buf.ptr, i64 48)
  %vq.zero = icmp eq i64 %vq.ret, 0
  br i1 %vq.zero, label %loc_140001897, label %after_vq

after_vq:                                         ; preds = %init_entry
  %prot.byte.ptr = getelementptr inbounds [48 x i8], [48 x i8]* %Buffer, i64 0, i64 36
  %prot.p = bitcast i8* %prot.byte.ptr to i32*
  %prot = load i32, i32* %prot.p, align 4
  %t1 = sub i32 %prot, 4
  %t2 = and i32 %t1, -5
  %z1 = icmp eq i32 %t2, 0
  br i1 %z1, label %inc_count, label %test40

test40:                                           ; preds = %after_vq
  %t3 = sub i32 %prot, 64
  %t4 = and i32 %t3, -65
  %jnz = icmp ne i32 %t4, 0
  br i1 %jnz, label %loc_140001840, label %inc_count

inc_count:                                        ; preds = %test40, %after_vq, %loc_140001840
  %oldc = load i32, i32* @dword_1400070A4, align 4
  %newc = add i32 %oldc, 1
  store i32 %newc, i32* @dword_1400070A4, align 4
  br label %ret

loc_140001840:                                    ; preds = %test40
  %is2 = icmp eq i32 %prot, 2
  %flNew = select i1 %is2, i32 4, i32 64
  %baseaddr.byte.ptr = getelementptr inbounds [48 x i8], [48 x i8]* %Buffer, i64 0, i64 0
  %baseaddr.p = bitcast i8* %baseaddr.byte.ptr to i8**
  %baseaddr = load i8*, i8** %baseaddr.p, align 8
  %regionsize.byte.ptr = getelementptr inbounds [48 x i8], [48 x i8]* %Buffer, i64 0, i64 24
  %regionsize.p = bitcast i8* %regionsize.byte.ptr to i64*
  %regionsize = load i64, i64* %regionsize.p, align 8
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %entry.ptr3 = getelementptr i8, i8* %base3, i64 %offset
  %entry.p8 = getelementptr i8, i8* %entry.ptr3, i64 8
  %entry.p8.pp = bitcast i8* %entry.p8 to i8**
  store i8* %baseaddr, i8** %entry.p8.pp, align 8
  %entry.p10 = getelementptr i8, i8* %entry.ptr3, i64 16
  %entry.p10.p = bitcast i8* %entry.p10 to i64*
  store i64 %regionsize, i64* %entry.p10.p, align 8
  %oldprot.p = bitcast i8* %entry.ptr3 to i32*
  %impVP = load i32 (i8*, i64, i32, i32*)*, i32 (i8*, i64, i32, i32*)** @__imp_VirtualProtect, align 8
  %vp.ret = call i32 %impVP(i8* %baseaddr, i64 %regionsize, i32 %flNew, i32* %oldprot.p)
  %vp.ok = icmp ne i32 %vp.ret, 0
  br i1 %vp.ok, label %inc_count, label %vp_fail

vp_fail:                                          ; preds = %loc_140001840
  %impGLE = load i32 ()*, i32 ()** @__imp_GetLastError, align 8
  %gle = call i32 %impGLE()
  %fmt1.p = bitcast i8* @aVirtualprotect to i8*
  call void (i8*, ...) @sub_140001700(i8* %fmt1.p, i32 %gle)
  br label %loc_140001890

loc_140001897:                                    ; preds = %init_entry
  %base4 = load i8*, i8** @qword_1400070A8, align 8
  %entry.ptr4 = getelementptr i8, i8* %base4, i64 %offset
  %entry.p18.2 = getelementptr i8, i8* %entry.ptr4, i64 24
  %entry.p18.2.pp = bitcast i8* %entry.p18.2 to i8**
  %r8val = load i8*, i8** %entry.p18.2.pp, align 8
  %desc.sz.addr = getelementptr i8, i8* %desc.new, i64 8
  %desc.sz.p = bitcast i8* %desc.sz.addr to i32*
  %desc.sz = load i32, i32* %desc.sz.p, align 4
  %fmt2.p = bitcast i8* @aVirtualqueryFa to i8*
  call void (i8*, ...) @sub_140001700(i8* %fmt2.p, i32 %desc.sz, i8* %r8val)
  br label %error_no_image_section

error_no_image_section:                           ; preds = %create_entry, %loc_140001897
  %fmt3.p = bitcast i8* @aAddressPHasNoI to i8*
  call void (i8*, ...) @sub_140001700(i8* %fmt3.p, i8* %addr)
  br label %ret

ret:                                              ; preds = %found_ret, %inc_count, %error_no_image_section
  ret void
}