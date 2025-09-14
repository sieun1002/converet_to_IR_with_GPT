; ModuleID = 'add_round_key'
source_filename = "add_round_key"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @add_round_key(i8* %state, i8* %key) {
entry:
  %state.addr = alloca i8*, align 8
  %key.addr = alloca i8*, align 8
  %i = alloca i32, align 4
  store i8* %state, i8** %state.addr, align 8
  store i8* %key, i8** %key.addr, align 8
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %i.val, 15
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %state.ptr = load i8*, i8** %state.addr, align 8
  %key.ptr = load i8*, i8** %key.addr, align 8
  %idx.ext = zext i32 %i.val to i64
  %state.elem = getelementptr inbounds i8, i8* %state.ptr, i64 %idx.ext
  %key.elem = getelementptr inbounds i8, i8* %key.ptr, i64 %idx.ext
  %a8 = load i8, i8* %state.elem, align 1
  %b8 = load i8, i8* %key.elem, align 1
  %x = xor i8 %a8, %b8
  store i8 %x, i8* %state.elem, align 1
  %inc = add nsw i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:
  ret void
}