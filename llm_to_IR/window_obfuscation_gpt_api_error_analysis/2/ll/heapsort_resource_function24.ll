; ModuleID = 'listing_sub_140002340.ll'
target triple = "x86_64-pc-windows-msvc"

%RTL_CRITICAL_SECTION = type { i32 }
%Block = type { i32, [12 x i8], %Block* }

@dword_1400070E8 = external global i32
@CriticalSection = external global %RTL_CRITICAL_SECTION
@Block = external global %Block*

declare dllimport void @EnterCriticalSection(%RTL_CRITICAL_SECTION* noundef)
declare dllimport void @LeaveCriticalSection(%RTL_CRITICAL_SECTION* noundef)
declare void @free(i8* noundef)

define dso_local i32 @sub_140002340(i32 noundef %arg) local_unnamed_addr {
entry:
  %g0 = load i32, i32* @dword_1400070E8, align 4
  %t0 = icmp eq i32 %g0, 0
  br i1 %t0, label %ret_zero, label %crit_enter

ret_zero:
  ret i32 0

crit_enter:
  call void @EnterCriticalSection(%RTL_CRITICAL_SECTION* noundef @CriticalSection)
  %head0 = load %Block*, %Block** @Block, align 8
  %isnull0 = icmp eq %Block* %head0, null
  br i1 %isnull0, label %leave, label %loop_hdr

loop_hdr:
  %prev.ph = phi %Block* [ null, %crit_enter ], [ %cur.next, %not_equal ]
  %cur.ph = phi %Block* [ %head0, %crit_enter ], [ %n1, %not_equal ]
  %keyptr = getelementptr inbounds %Block, %Block* %cur.ph, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %nptr = getelementptr inbounds %Block, %Block* %cur.ph, i32 0, i32 2
  %n1 = load %Block*, %Block** %nptr, align 8
  %cmp = icmp eq i32 %key, %arg
  br i1 %cmp, label %found, label %check_next

check_next:
  %nnull = icmp eq %Block* %n1, null
  br i1 %nnull, label %leave, label %not_equal

not_equal:
  %cur.next = phi %Block* [ %cur.ph, %check_next ]
  br label %loop_hdr

found:
  %prev_is_null = icmp eq %Block* %prev.ph, null
  br i1 %prev_is_null, label %unlink_head, label %unlink_mid

unlink_mid:
  %prev_next_ptr = getelementptr inbounds %Block, %Block* %prev.ph, i32 0, i32 2
  store %Block* %n1, %Block** %prev_next_ptr, align 8
  br label %do_free

unlink_head:
  store %Block* %n1, %Block** @Block, align 8
  br label %do_free

do_free:
  %cur_i8 = bitcast %Block* %cur.ph to i8*
  call void @free(i8* noundef %cur_i8)
  br label %leave

leave:
  call void @LeaveCriticalSection(%RTL_CRITICAL_SECTION* noundef @CriticalSection)
  ret i32 0
}