; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str.element_found_at_index_d_nl = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() {
loc_1060:
  %fmt.ptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str.element_found_at_index_d_nl, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i32 3)
  ret i32 0
}