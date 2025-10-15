; ModuleID = 'fixed_module'
source_filename = "fixed_module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.EXCEPTION_RECORD = type { i32, i32 }
%struct.EXCEPTION_POINTERS = type { %struct.EXCEPTION_RECORD*, i8* }

@gSink = dso_local global i32 0, align 4
@off_140004400 = dso_local global i32* @gSink, align 8
@qword_1400070D0 = dso_local global i32 (%struct.EXCEPTION_POINTERS*)* null, align 8

declare dllimport void (i32)* @signal(i32, void (i32)*)

define dso_local void @sub_140001010() {
entry:
  ret void
}

define dso_local void @sub_1400024E0() {
entry:
  ret void
}

define dso_local void @sub_1400013E0() {
entry:
  %0 = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %0, align 4
  call void @sub_140001010()
  ret void
}

define dso_local i32 @sub_140002080(%struct.EXCEPTION_POINTERS* %p) {
entry:
  %rec.ptr.ptr = getelementptr inbounds %struct.EXCEPTION_POINTERS, %struct.EXCEPTION_POINTERS* %p, i32 0, i32 0
  %rec.ptr = load %struct.EXCEPTION_RECORD*, %struct.EXCEPTION_RECORD** %rec.ptr.ptr, align 8
  %code.ptr = getelementptr inbounds %struct.EXCEPTION_RECORD, %struct.EXCEPTION_RECORD* %rec.ptr, i32 0, i32 0
  %code = load i32, i32* %code.ptr, align 4
  %is_av = icmp eq i32 %code, 3221225477
  br i1 %is_av, label %set_segv, label %check_ill1

set_segv:                                            ; preds = %entry
  br label %set_done

check_ill1:                                          ; preds = %entry
  %is_ill1 = icmp eq i32 %code, 3221225501
  br i1 %is_ill1, label %set_ill, label %check_ill2

set_ill:                                             ; preds = %check_ill1
  br label %set_done

check_ill2:                                          ; preds = %check_ill1
  %is_priv = icmp eq i32 %code, 3221225622
  br i1 %is_priv, label %set_ill2, label %check_fpe

set_ill2:                                            ; preds = %check_ill2
  br label %set_done

check_fpe:                                           ; preds = %check_ill2
  %low = icmp uge i32 %code, 3221225611
  %high = icmp ule i32 %code, 3221225619
  %inrange = and i1 %low, %high
  br i1 %inrange, label %set_fpe, label %no_signal

set_fpe:                                             ; preds = %check_fpe
  br label %set_done

no_signal:                                           ; preds = %check_fpe
  br label %set_done

set_done:                                            ; preds = %no_signal, %set_fpe, %set_ill2, %set_ill, %set_segv
  %s = phi i32 [ 11, %set_segv ], [ 4, %set_ill ], [ 4, %set_ill2 ], [ 8, %set_fpe ], [ 0, %no_signal ]
  %is_zero = icmp eq i32 %s, 0
  br i1 %is_zero, label %fallback, label %handle_signal

fallback:                                            ; preds = %set_done
  %fp = load i32 (%struct.EXCEPTION_POINTERS*)*, i32 (%struct.EXCEPTION_POINTERS*)** @qword_1400070D0, align 8
  %hasfp = icmp ne i32 (%struct.EXCEPTION_POINTERS*)* %fp, null
  br i1 %hasfp, label %callfp, label %ret0

callfp:                                              ; preds = %fallback
  %res = call i32 %fp(%struct.EXCEPTION_POINTERS* %p)
  ret i32 %res

ret0:                                                ; preds = %fallback
  ret i32 0

handle_signal:                                       ; preds = %set_done
  %sig_dfl = inttoptr i64 0 to void (i32)*
  %old = call void (i32)* @signal(i32 %s, void (i32)* %sig_dfl)
  %old_i = ptrtoint void (i32)* %old to i64
  %is_ign = icmp eq i64 %old_i, 1
  br i1 %is_ign, label %on_ign, label %check_null

on_ign:                                              ; preds = %handle_signal
  %sig_ign = inttoptr i64 1 to void (i32)*
  %tmp1 = call void (i32)* @signal(i32 %s, void (i32)* %sig_ign)
  %is_fpe = icmp eq i32 %s, 8
  br i1 %is_fpe, label %callfpeextra, label %ret_minus1

callfpeextra:                                        ; preds = %on_ign
  call void @sub_1400024E0()
  br label %ret_minus1

ret_minus1:                                          ; preds = %callfpeextra, %on_ign, %call_old
  ret i32 -1

check_null:                                          ; preds = %handle_signal
  %is_null = icmp eq i64 %old_i, 0
  br i1 %is_null, label %maybe_fp, label %call_old

maybe_fp:                                            ; preds = %check_null
  %fp2 = load i32 (%struct.EXCEPTION_POINTERS*)*, i32 (%struct.EXCEPTION_POINTERS*)** @qword_1400070D0, align 8
  %hasfp2 = icmp ne i32 (%struct.EXCEPTION_POINTERS*)* %fp2, null
  br i1 %hasfp2, label %callfp2, label %ret0_2

callfp2:                                             ; preds = %maybe_fp
  %res2 = call i32 %fp2(%struct.EXCEPTION_POINTERS* %p)
  ret i32 %res2

ret0_2:                                              ; preds = %maybe_fp
  ret i32 0

call_old:                                            ; preds = %check_null
  call void %old(i32 %s)
  br label %ret_minus1
}