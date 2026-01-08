; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@qword_140008298 = external dso_local global i8*
@qword_140008290 = external dso_local global i8*
@qword_140008260 = external dso_local global i8*

@aVirtualprotect = external dso_local global i8
@aVirtualqueryFa = external dso_local global i8
@aAddressPHasNoI = external dso_local global i8

declare dso_local i8* @sub_140002250(i8*)
declare dso_local i8* @sub_140002390()
declare dso_local void @sub_140001700(i8*, ...)

define dso_local void @sub_140001760(i8* %0) {
entry:
  %rbx = alloca i8*, align 8
  %mb = alloca [48 x i8], align 8
  store i8* %0, i8** %rbx, align 8
  %1 = load i32, i32* @dword_1400070A4, align 4
  %2 = icmp sgt i32 %1, 0
  br i1 %2, label %have_entries_setup, label %no_entries

have_entries_setup:                                ; preds = %entry
  %3 = load i8*, i8** @qword_1400070A8, align 8
  %4 = getelementptr i8, i8* %3, i64 24
  br label %loop

loop:                                              ; preds = %inc_iter, %have_entries_setup
  %rax_phi = phi i8* [ %4, %have_entries_setup ], [ %16, %inc_iter ]
  %r9_phi = phi i32 [ 0, %have_entries_setup ], [ %15, %inc_iter ]
  %5 = load i8*, i8** %rbx, align 8
  %6 = ptrtoint i8* %5 to i64
  %7 = bitcast i8* %rax_phi to i8**
  %8 = load i8*, i8** %7, align 8
  %9 = ptrtoint i8* %8 to i64
  %10 = icmp ult i64 %6, %9
  br i1 %10, label %inc_iter, label %range_check

range_check:                                       ; preds = %loop
  %11 = getelementptr i8, i8* %rax_phi, i64 8
  %12 = bitcast i8* %11 to i8**
  %13 = load i8*, i8** %12, align 8
  %14 = getelementptr i8, i8* %13, i64 8
  %size32ptr = bitcast i8* %14 to i32*
  %size32 = load i32, i32* %size32ptr, align 4
  %size64 = zext i32 %size32 to i64
  %end = add i64 %9, %size64
  %inrange = icmp ult i64 %6, %end
  br i1 %inrange, label %early_ret, label %inc_iter

inc_iter:                                          ; preds = %range_check, %loop
  %15 = add i32 %r9_phi, 1
  %16 = getelementptr i8, i8* %rax_phi, i64 40
  %17 = icmp ne i32 %15, %1
  br i1 %17, label %loop, label %call_new

no_entries:                                        ; preds = %entry, %vp_fail_cont
  br label %call_new

call_new:                                          ; preds = %no_entries, %inc_iter
  %esi_cur = phi i32 [ 0, %no_entries ], [ %1, %inc_iter ]
  %18 = load i8*, i8** %rbx, align 8
  %rdi = call i8* @sub_140002250(i8* %18)
  %rdi_isnull = icmp eq i8* %rdi, null
  br i1 %rdi_isnull, label %no_image, label %after_rdi_nonnull

after_rdi_nonnull:                                 ; preds = %call_new
  %19 = load i8*, i8** @qword_1400070A8, align 8
  %20 = sext i32 %esi_cur to i64
  %21 = mul i64 %20, 5
  %22 = shl i64 %21, 3
  %entry_ptr = getelementptr i8, i8* %19, i64 %22
  %off20 = getelementptr i8, i8* %entry_ptr, i64 32
  %off20p = bitcast i8* %off20 to i8**
  store i8* %rdi, i8** %off20p, align 8
  %entry_dword = bitcast i8* %entry_ptr to i32*
  store i32 0, i32* %entry_dword, align 4
  %rax3 = call i8* @sub_140002390()
  %rdi_plus_c = getelementptr i8, i8* %rdi, i64 12
  %rdi_plus_c_i32p = bitcast i8* %rdi_plus_c to i32*
  %edx32 = load i32, i32* %rdi_plus_c_i32p, align 4
  %edx64 = zext i32 %edx32 to i64
  %rcx_calc = getelementptr i8, i8* %rax3, i64 %edx64
  %23 = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr2 = getelementptr i8, i8* %23, i64 %22
  %off18 = getelementptr i8, i8* %entry_ptr2, i64 24
  %off18p = bitcast i8* %off18 to i8**
  store i8* %rcx_calc, i8** %off18p, align 8
  %mb_ptr = getelementptr [48 x i8], [48 x i8]* %mb, i64 0, i64 0
  %vfq_loc = load i8*, i8** @qword_140008298, align 8
  %vfq = bitcast i8* %vfq_loc to i64 (i8*, i8*, i64)*
  %vqret = call i64 %vfq(i8* %rcx_calc, i8* %mb_ptr, i64 48)
  %vqzero = icmp eq i64 %vqret, 0
  br i1 %vqzero, label %vquery_fail, label %vquery_ok

vquery_ok:                                         ; preds = %after_rdi_nonnull
  %prot_off = getelementptr i8, i8* %mb_ptr, i64 36
  %prot_i32p = bitcast i8* %prot_off to i32*
  %eax_prot = load i32, i32* %prot_i32p, align 4
  %t1 = sub i32 %eax_prot, 4
  %t2 = and i32 %t1, -5
  %is0 = icmp eq i32 %t2, 0
  br i1 %is0, label %inc_count, label %check2

check2:                                            ; preds = %vquery_ok
  %t3 = sub i32 %eax_prot, 64
  %t4 = and i32 %t3, -65
  %is0b = icmp eq i32 %t4, 0
  br i1 %is0b, label %inc_count, label %need_protect

inc_count:                                         ; preds = %need_protect, %check2, %vquery_ok, %vp_ok
  %oldc = load i32, i32* @dword_1400070A4, align 4
  %newc = add i32 %oldc, 1
  store i32 %newc, i32* @dword_1400070A4, align 4
  ret void

need_protect:                                      ; preds = %check2
  %is_two = icmp eq i32 %eax_prot, 2
  %r8fl = select i1 %is_two, i32 4, i32 64
  %baseaddr_p = bitcast i8* %mb_ptr to i8**
  %baseaddr = load i8*, i8** %baseaddr_p, align 8
  %rs_off = getelementptr i8, i8* %mb_ptr, i64 24
  %rs_i64p = bitcast i8* %rs_off to i64*
  %regionsize = load i64, i64* %rs_i64p, align 8
  %entry_plus8 = getelementptr i8, i8* %entry_ptr2, i64 8
  %entry_plus8p = bitcast i8* %entry_plus8 to i8**
  store i8* %baseaddr, i8** %entry_plus8p, align 8
  %entry_plus10 = getelementptr i8, i8* %entry_ptr2, i64 16
  %entry_plus10p = bitcast i8* %entry_plus10 to i64*
  store i64 %regionsize, i64* %entry_plus10p, align 8
  %vp_loc = load i8*, i8** @qword_140008290, align 8
  %vp = bitcast i8* %vp_loc to i32 (i8*, i64, i32, i32*)*
  %oldprot_p = bitcast i8* %entry_ptr2 to i32*
  %vp_res = call i32 %vp(i8* %baseaddr, i64 %regionsize, i32 %r8fl, i32* %oldprot_p)
  %vp_ok = icmp ne i32 %vp_res, 0
  br i1 %vp_ok, label %inc_count, label %vp_fail

vp_fail:                                           ; preds = %need_protect
  %gle_loc = load i8*, i8** @qword_140008260, align 8
  %gle = bitcast i8* %gle_loc to i32 ()*
  %err = call i32 %gle()
  %fmt_vp = bitcast i8* @aVirtualprotect to i8*
  call void (i8*, ...) @sub_140001700(i8* %fmt_vp, i32 %err)
  br label %vp_fail_cont

vp_fail_cont:                                      ; preds = %vp_fail
  br label %no_entries

vquery_fail:                                       ; preds = %after_rdi_nonnull
  %24 = load i8*, i8** @qword_1400070A8, align 8
  %rdi_plus8 = getelementptr i8, i8* %rdi, i64 8
  %rdi_plus8_i32p = bitcast i8* %rdi_plus8 to i32*
  %edx_fail = load i32, i32* %rdi_plus8_i32p, align 4
  %addr_saved_base = getelementptr i8, i8* %24, i64 %22
  %addr_saved_off = getelementptr i8, i8* %addr_saved_base, i64 24
  %addr_saved_p = bitcast i8* %addr_saved_off to i8**
  %addr_saved = load i8*, i8** %addr_saved_p, align 8
  %fmt_vq = bitcast i8* @aVirtualqueryFa to i8*
  call void (i8*, ...) @sub_140001700(i8* %fmt_vq, i32 %edx_fail, i8* %addr_saved)
  br label %no_image

no_image:                                          ; preds = %vquery_fail, %call_new
  %fmt_noimg = bitcast i8* @aAddressPHasNoI to i8*
  %rbx_ld = load i8*, i8** %rbx, align 8
  call void (i8*, ...) @sub_140001700(i8* %fmt_noimg, i8* %rbx_ld)
  ret void

early_ret:                                         ; preds = %range_check
  ret void
}