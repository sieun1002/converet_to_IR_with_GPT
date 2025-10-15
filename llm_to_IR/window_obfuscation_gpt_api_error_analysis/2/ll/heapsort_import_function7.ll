; ModuleID = 'recovered_sub_140001B30'
target triple = "x86_64-pc-windows-msvc"

%Entry = type { i32, i32, i8*, i8*, i8*, i8* }

@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global %Entry*, align 8

@.str.VirtualProtect = private constant [39 x i8] c"  VirtualProtect failed with code 0x%x\00", align 1
@.str.VirtualQuery = private constant [49 x i8] c"  VirtualQuery failed for %d bytes at address %p\00", align 1
@.str.NoImageSection = private constant [32 x i8] c"Address %p has no image-section\00", align 1

declare i8* @sub_140002610(i8* noundef)
declare i8* @sub_140002750()
declare i64 @sub_14001FAD3(i8* noundef, i8* noundef, i32 noundef)
declare i32 @loc_14000EEBA(i8* noundef, i8* noundef, i32 noundef, %Entry* noundef)
declare i32 @qword_140008260()
declare void @sub_140001AD0(i8* noundef, ...)

define dso_local void @sub_140001B30(i8* noundef %addr) local_unnamed_addr {
entry:
  %buf = alloca [48 x i8], align 16
  %count.load = load i32, i32* @dword_1400070A4, align 4
  %count.pos = icmp sgt i32 %count.load, 0
  br i1 %count.pos, label %range_check, label %call_find

range_check:                                          ; preds = %range_latch, %entry
  %i.ph = phi i32 [ 0, %entry ], [ %i.next, %range_latch ]
  %baseptr.load = load %Entry*, %Entry** @qword_1400070A8, align 8
  %cmp.end = icmp sge i32 %i.ph, %count.load
  br i1 %cmp.end, label %call_find, label %rc_body

rc_body:                                              ; preds = %range_check
  %i64 = sext i32 %i.ph to i64
  %e.ptr = getelementptr inbounds %Entry, %Entry* %baseptr.load, i64 %i64
  %field4.ptr = getelementptr inbounds %Entry, %Entry* %e.ptr, i32 0, i32 4
  %baseAddr = load i8*, i8** %field4.ptr, align 8
  %addr.int = ptrtoint i8* %addr to i64
  %base.int = ptrtoint i8* %baseAddr to i64
  %lt.base = icmp ult i64 %addr.int, %base.int
  br i1 %lt.base, label %range_latch, label %check_end

check_end:                                            ; preds = %rc_body
  %field5.ptr = getelementptr inbounds %Entry, %Entry* %e.ptr, i32 0, i32 5
  %pinfo.ptr = load i8*, i8** %field5.ptr, align 8
  %size.ptr.i8 = getelementptr inbounds i8, i8* %pinfo.ptr, i64 8
  %size.ptr.i32 = bitcast i8* %size.ptr.i8 to i32*
  %size.val = load i32, i32* %size.ptr.i32, align 4
  %size.z = zext i32 %size.val to i64
  %end.int = add i64 %base.int, %size.z
  %lt.end = icmp ult i64 %addr.int, %end.int
  br i1 %lt.end, label %ret, label %range_latch

range_latch:                                          ; preds = %check_end, %rc_body
  %i.next = add nuw nsw i32 %i.ph, 1
  br label %range_check

call_find:                                            ; preds = %range_check, %entry, %restart
  %pinfo = call i8* @sub_140002610(i8* noundef %addr)
  %pinfo.null = icmp eq i8* %pinfo, null
  br i1 %pinfo.null, label %log_noimage, label %have_info

have_info:                                            ; preds = %call_find
  %baseptr2.load = load %Entry*, %Entry** @qword_1400070A8, align 8
  %idx64 = sext i32 %count.load to i64
  %new.e = getelementptr inbounds %Entry, %Entry* %baseptr2.load, i64 %idx64
  %new.f5 = getelementptr inbounds %Entry, %Entry* %new.e, i32 0, i32 5
  store i8* %pinfo, i8** %new.f5, align 8
  %new.f0 = getelementptr inbounds %Entry, %Entry* %new.e, i32 0, i32 0
  store i32 0, i32* %new.f0, align 4
  %baseA = call i8* @sub_140002750()
  %off.ptr.i8 = getelementptr inbounds i8, i8* %pinfo, i64 12
  %off.ptr.i32 = bitcast i8* %off.ptr.i8 to i32*
  %off.val = load i32, i32* %off.ptr.i32, align 4
  %off.z = zext i32 %off.val to i64
  %rcx.ptr = getelementptr inbounds i8, i8* %baseA, i64 %off.z
  %new.f4 = getelementptr inbounds %Entry, %Entry* %new.e, i32 0, i32 4
  store i8* %rcx.ptr, i8** %new.f4, align 8
  %buf.i8 = bitcast [48 x i8]* %buf to i8*
  %vq.ok = call i64 @sub_14001FAD3(i8* noundef %rcx.ptr, i8* noundef %buf.i8, i32 noundef 48)
  %vq.succ = icmp ne i64 %vq.ok, 0
  br i1 %vq.succ, label %after_query, label %vquery_failed

after_query:                                          ; preds = %have_info
  %p.2C.i8 = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 44
  %p.2C.i32 = bitcast i8* %p.2C.i8 to i32*
  %eax.val = load i32, i32* %p.2C.i32, align 4
  %sub4 = add i32 %eax.val, -4
  %mask4 = and i32 %sub4, -5
  %is.4.8 = icmp eq i32 %mask4, 0
  br i1 %is.4.8, label %inc_and_ret, label %test_40

test_40:                                              ; preds = %after_query
  %sub64 = add i32 %eax.val, -64
  %mask64 = and i32 %sub64, -65
  %is.40.80 = icmp eq i32 %mask64, 0
  br i1 %is.40.80, label %inc_and_ret, label %do_protect

do_protect:                                           ; preds = %test_40
  %p.00.i8 = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 0
  %p.00.q = bitcast i8* %p.00.i8 to i8**
  %rcx.val = load i8*, i8** %p.00.q, align 8
  %p.10.i8 = getelementptr inbounds [48 x i8], [48 x i8]* %buf, i64 0, i64 16
  %p.10.q = bitcast i8* %p.10.i8 to i8**
  %rdx.val = load i8*, i8** %p.10.q, align 8
  %cmp2 = icmp eq i32 %eax.val, 2
  %prot.sel = select i1 %cmp2, i32 4, i32 64
  %new.f2 = getelementptr inbounds %Entry, %Entry* %new.e, i32 0, i32 2
  store i8* %rcx.val, i8** %new.f2, align 8
  %new.f3 = getelementptr inbounds %Entry, %Entry* %new.e, i32 0, i32 3
  store i8* %rdx.val, i8** %new.f3, align 8
  %prot.ok = call i32 @loc_14000EEBA(i8* noundef %rcx.val, i8* noundef %rdx.val, i32 noundef %prot.sel, %Entry* noundef %new.e)
  %prot.succ = icmp ne i32 %prot.ok, 0
  br i1 %prot.succ, label %inc_and_ret, label %prot_failed

inc_and_ret:                                          ; preds = %do_protect, %test_40, %after_query
  %cnt.old = load i32, i32* @dword_1400070A4, align 4
  %cnt.new = add i32 %cnt.old, 1
  store i32 %cnt.new, i32* @dword_1400070A4, align 4
  br label %ret

vquery_failed:                                        ; preds = %have_info
  %baseptr3.load = load %Entry*, %Entry** @qword_1400070A8, align 8
  %pinfo.sz.ptr.i8 = getelementptr inbounds i8, i8* %pinfo, i64 8
  %pinfo.sz.ptr.i32 = bitcast i8* %pinfo.sz.ptr.i8 to i32*
  %pinfo.sz = load i32, i32* %pinfo.sz.ptr.i32, align 4
  %e2.ptr = getelementptr inbounds %Entry, %Entry* %baseptr3.load, i64 %idx64
  %e2.f4 = getelementptr inbounds %Entry, %Entry* %e2.ptr, i32 0, i32 4
  %r8.val = load i8*, i8** %e2.f4, align 8
  %fmt1 = getelementptr inbounds [49 x i8], [49 x i8]* @.str.VirtualQuery, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* noundef %fmt1, i32 noundef %pinfo.sz, i8* noundef %r8.val)
  br label %log_noimage

prot_failed:                                          ; preds = %do_protect
  %err = call i32 @qword_140008260()
  %fmt2 = getelementptr inbounds [39 x i8], [39 x i8]* @.str.VirtualProtect, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* noundef %fmt2, i32 noundef %err)
  br label %restart

log_noimage:                                          ; preds = %vquery_failed, %call_find
  %fmt3 = getelementptr inbounds [32 x i8], [32 x i8]* @.str.NoImageSection, i64 0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* noundef %fmt3, i8* noundef %addr)
  br label %ret

restart:                                              ; preds = %prot_failed
  br label %call_find

ret:                                                  ; preds = %inc_and_ret, %log_noimage, %check_end
  ret void
}