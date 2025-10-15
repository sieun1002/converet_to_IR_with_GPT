; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"

%struct.EXCEPTION_RECORD = type { i32, i32, %struct.EXCEPTION_RECORD*, i8*, [15 x i64] }
%struct.EXCEPTION_POINTERS = type { %struct.EXCEPTION_RECORD*, i8* }

@off_140004400 = external dso_local global i32*
@qword_1400070D0 = external dso_local global i32 (%struct.EXCEPTION_POINTERS*)*

declare dso_local void @sub_140001010()
declare dso_local void (i32)* @signal(i32, void (i32)*)
declare dso_local void @sub_1400024E0()

define dso_local void @sub_1400013E0() {
entry:
  %p.addr = load i32*, i32** @off_140004400, align 8
  %isnull = icmp eq i32* %p.addr, null
  br i1 %isnull, label %afterstore, label %store

store:
  store i32 1, i32* %p.addr, align 4
  br label %afterstore

afterstore:
  call void @sub_140001010()
  ret void
}

define dso_local i32 @sub_140002080(%struct.EXCEPTION_POINTERS* %ptrs) {
entry:
  %recptr.ptr = getelementptr inbounds %struct.EXCEPTION_POINTERS, %struct.EXCEPTION_POINTERS* %ptrs, i32 0, i32 0
  %recptr = load %struct.EXCEPTION_RECORD*, %struct.EXCEPTION_RECORD** %recptr.ptr, align 8
  %code.ptr = getelementptr inbounds %struct.EXCEPTION_RECORD, %struct.EXCEPTION_RECORD* %recptr, i32 0, i32 0
  %code = load i32, i32* %code.ptr, align 4
  switch i32 %code, label %fallback [
    i32 3221225477, label %case_segv
    i32 3221225501, label %case_ill
    i32 3221225675, label %case_fpe
    i32 3221225676, label %case_fpe
    i32 3221225677, label %case_fpe
    i32 3221225678, label %case_fpe
    i32 3221225680, label %case_fpe
    i32 3221225681, label %case_fpe
    i32 3221225683, label %case_fpe
    i32 3221225684, label %case_fpe
  ]

case_fpe:
  br label %do_signal

case_ill:
  br label %do_signal

case_segv:
  br label %do_signal

do_signal:
  %sig.phi = phi i32 [ 8, %case_fpe ], [ 4, %case_ill ], [ 11, %case_segv ]
  %sig_dfl = inttoptr i64 0 to void (i32)*
  %handler = call void (i32)* @signal(i32 %sig.phi, void (i32)* %sig_dfl)
  %is_dfl = icmp eq void (i32)* %handler, %sig_dfl
  br i1 %is_dfl, label %fallback, label %check_ign

check_ign:
  %sig_ign = inttoptr i64 1 to void (i32)*
  %is_ign = icmp eq void (i32)* %handler, %sig_ign
  br i1 %is_ign, label %ret0, label %call_handler

call_handler:
  call void %handler(i32 %sig.phi)
  br label %retm1

fallback:
  %flt = load i32 (%struct.EXCEPTION_POINTERS*)*, i32 (%struct.EXCEPTION_POINTERS*)** @qword_1400070D0, align 8
  %flt_null = icmp eq i32 (%struct.EXCEPTION_POINTERS*)* %flt, null
  br i1 %flt_null, label %ret0, label %tailcall

tailcall:
  %res = tail call i32 %flt(%struct.EXCEPTION_POINTERS* %ptrs)
  ret i32 %res

ret0:
  ret i32 0

retm1:
  ret i32 -1
}