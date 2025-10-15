; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:64:64-p271:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i8*

declare dso_local i8* @sub_140002B68(i32, i32)
declare dso_local void @sub_1400024E0()

define dso_local i32 @sub_140002080(i8** %argpp) local_unnamed_addr {
entry:
  %rdx.ptr = load i8*, i8** %argpp, align 8
  %rdx.i32ptr = bitcast i8* %rdx.ptr to i32*
  %code = load i32, i32* %rdx.i32ptr, align 4
  %masked = and i32 %code, 553648127
  %is_tag = icmp eq i32 %masked, 541541187
  br i1 %is_tag, label %check_bit, label %main

check_bit:
  %plus4 = getelementptr inbounds i8, i8* %rdx.ptr, i64 4
  %b = load i8, i8* %plus4, align 1
  %b1 = and i8 %b, 1
  %b1_is_zero = icmp eq i8 %b1, 0
  br i1 %b1_is_zero, label %ret_minus1, label %main

main:
  %is_av = icmp eq i32 %code, -1073741819
  br i1 %is_av, label %handle_11, label %chk_001D

chk_001D:
  %is_001D = icmp eq i32 %code, -1073741795
  br i1 %is_001D, label %handle_4, label %handle_8

handle_11:
  %h11 = call i8* @sub_140002B68(i32 11, i32 0)
  %h11_isnull = icmp eq i8* %h11, null
  %h11_val = ptrtoint i8* %h11 to i64
  %h11_is1 = icmp eq i64 %h11_val, 1
  br i1 %h11_is1, label %h11_set, label %h11_chknull

h11_set:
  %tmp_h11_set = call i8* @sub_140002B68(i32 11, i32 1)
  br label %ret_minus1

h11_chknull:
  br i1 %h11_isnull, label %handler_check, label %h11_call

h11_call:
  %h11_fn = bitcast i8* %h11 to void (i32)*
  call void %h11_fn(i32 11)
  br label %ret_minus1

handle_4:
  %h4 = call i8* @sub_140002B68(i32 4, i32 0)
  %h4_isnull = icmp eq i8* %h4, null
  %h4_val = ptrtoint i8* %h4 to i64
  %h4_is1 = icmp eq i64 %h4_val, 1
  br i1 %h4_is1, label %h4_set, label %h4_chknull

h4_set:
  %tmp_h4_set = call i8* @sub_140002B68(i32 4, i32 1)
  br label %ret_minus1

h4_chknull:
  br i1 %h4_isnull, label %handler_check, label %h4_call

h4_call:
  %h4_fn = bitcast i8* %h4 to void (i32)*
  call void %h4_fn(i32 4)
  br label %ret_minus1

handle_8:
  %h8 = call i8* @sub_140002B68(i32 8, i32 0)
  %h8_isnull = icmp eq i8* %h8, null
  %h8_val = ptrtoint i8* %h8 to i64
  %h8_is1 = icmp eq i64 %h8_val, 1
  br i1 %h8_is1, label %h8_set, label %h8_chknull

h8_set:
  %tmp_h8_set = call i8* @sub_140002B68(i32 8, i32 1)
  call void @sub_1400024E0()
  br label %ret_minus1

h8_chknull:
  br i1 %h8_isnull, label %handler_check, label %h8_call

h8_call:
  %h8_fn = bitcast i8* %h8 to void (i32)*
  call void %h8_fn(i32 8)
  br label %ret_minus1

handler_check:
  %fp.raw = load i8*, i8** @qword_1400070D0, align 8
  %fp.null = icmp eq i8* %fp.raw, null
  br i1 %fp.null, label %ret_zero, label %tailjmp

tailjmp:
  %fp = bitcast i8* %fp.raw to i32 (i8**)*
  %res = tail call i32 %fp(i8** %argpp)
  ret i32 %res

ret_minus1:
  ret i32 -1

ret_zero:
  ret i32 0
}