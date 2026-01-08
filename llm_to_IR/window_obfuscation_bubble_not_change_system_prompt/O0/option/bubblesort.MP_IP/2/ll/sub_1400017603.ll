; ModuleID = 'sub_140001760'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@aAddressPHasNoI = private unnamed_addr constant [32 x i8] c"Address %p has no image-section\00"

declare i8* @sub_140002250(i8*)
declare i8* @sub_140002390()
declare void @sub_140612B3A(i8*, i8*, i32)
declare void @sub_140001700(i8*, i8*)

define void @sub_140001760(i8* %arg) {
entry:
  %stack = alloca [72 x i8], align 1
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %gt0 = icmp sgt i32 %cnt, 0
  br i1 %gt0, label %loop.init, label %no_entries

loop.init:                                        ; preds = %entry
  %base = load i8*, i8** @qword_1400070A8, align 8
  %first = getelementptr i8, i8* %base, i64 24
  br label %loop.header

loop.header:                                      ; preds = %loop.inc, %loop.init
  %cur = phi i8* [ %first, %loop.init ], [ %next, %loop.inc ]
  %idx = phi i32 [ 0, %loop.init ], [ %idx.next, %loop.inc ]
  %cur_p0 = bitcast i8* %cur to i8**
  %start = load i8*, i8** %cur_p0, align 8
  %arg_i = ptrtoint i8* %arg to i64
  %start_i = ptrtoint i8* %start to i64
  %before = icmp ult i64 %arg_i, %start_i
  br i1 %before, label %loop.inc, label %check.range

check.range:                                      ; preds = %loop.header
  %cur_plus8 = getelementptr i8, i8* %cur, i64 8
  %cur_p1 = bitcast i8* %cur_plus8 to i8**
  %sec = load i8*, i8** %cur_p1, align 8
  %sec_plus8 = getelementptr i8, i8* %sec, i64 8
  %sec_plus8_i32p = bitcast i8* %sec_plus8 to i32*
  %size = load i32, i32* %sec_plus8_i32p, align 4
  %size_z = zext i32 %size to i64
  %end_i = add i64 %start_i, %size_z
  %inrange = icmp ult i64 %arg_i, %end_i
  br i1 %inrange, label %ret.early, label %loop.inc

loop.inc:                                         ; preds = %check.range, %loop.header
  %idx.next = add i32 %idx, 1
  %next = getelementptr i8, i8* %cur, i64 40
  %cond = icmp ne i32 %idx.next, %cnt
  br i1 %cond, label %loop.header, label %call_path_from_loop

call_path_from_loop:                              ; preds = %loop.inc
  br label %call_path

no_entries:                                       ; preds = %entry
  br label %call_path

call_path:                                        ; preds = %no_entries, %call_path_from_loop
  %storeIndex.sel = phi i32 [ 0, %no_entries ], [ %cnt, %call_path_from_loop ]
  %res = call i8* @sub_140002250(i8* %arg)
  %isnull = icmp eq i8* %res, null
  br i1 %isnull, label %error, label %success

success:                                          ; preds = %call_path
  %base2 = load i8*, i8** @qword_1400070A8, align 8
  %idx64 = sext i32 %storeIndex.sel to i64
  %offset = mul i64 %idx64, 40
  %slot = getelementptr i8, i8* %base2, i64 %offset
  %slot_ptr = getelementptr i8, i8* %slot, i64 32
  %slot_ptr_pp = bitcast i8* %slot_ptr to i8**
  store i8* %res, i8** %slot_ptr_pp, align 8
  %slot_i32p = bitcast i8* %slot to i32*
  store i32 0, i32* %slot_i32p, align 4
  %baseimg = call i8* @sub_140002390()
  %res_plus12 = getelementptr i8, i8* %res, i64 12
  %res_plus12_i32p = bitcast i8* %res_plus12 to i32*
  %imgoff = load i32, i32* %res_plus12_i32p, align 4
  %imgoff_z = zext i32 %imgoff to i64
  %dest = getelementptr i8, i8* %baseimg, i64 %imgoff_z
  %base3 = load i8*, i8** @qword_1400070A8, align 8
  %slot2 = getelementptr i8, i8* %base3, i64 %offset
  %slot2_plus24 = getelementptr i8, i8* %slot2, i64 24
  %slot2_pp = bitcast i8* %slot2_plus24 to i8**
  store i8* %dest, i8** %slot2_pp, align 8
  %buf = getelementptr [72 x i8], [72 x i8]* %stack, i64 0, i64 0
  call void @sub_140612B3A(i8* %dest, i8* %buf, i32 48)
  ret void

error:                                            ; preds = %call_path
  %msg = getelementptr [32 x i8], [32 x i8]* @aAddressPHasNoI, i64 0, i64 0
  call void @sub_140001700(i8* %msg, i8* %arg)
  ret void

ret.early:                                        ; preds = %check.range
  ret void
}