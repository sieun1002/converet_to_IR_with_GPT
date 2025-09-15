; ModuleID = 'quicksort.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu-elf"

%struct.State = type { %struct.ArchState, [32 x %union.VectorReg], %struct.ArithFlags, %union.anon, %struct.Segments, %struct.AddressSpace, %struct.GPR, %struct.X87Stack, %struct.MMX, %struct.FPUStatusFlags, %union.anon, %union.FPU, %struct.SegmentCaches }
%struct.ArchState = type { i32, i32, %union.anon }
%union.VectorReg = type { %union.vec512_t }
%union.vec512_t = type { %struct.uint64v8_t }
%struct.uint64v8_t = type { [8 x i64] }
%struct.ArithFlags = type { i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8 }
%struct.Segments = type { i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector, i16, %union.SegmentSelector }
%union.SegmentSelector = type { i16 }
%struct.AddressSpace = type { i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg }
%struct.Reg = type { %union.anon }
%struct.GPR = type { i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg, i64, %struct.Reg }
%struct.X87Stack = type { [8 x %struct.anon.3] }
%struct.anon.3 = type { [6 x i8], %struct.float80_t }
%struct.float80_t = type { [10 x i8] }
%struct.MMX = type { [8 x %struct.anon.4] }
%struct.anon.4 = type { i64, %union.vec64_t }
%union.vec64_t = type { %struct.uint64v1_t }
%struct.uint64v1_t = type { [1 x i64] }
%struct.FPUStatusFlags = type { i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, [4 x i8] }
%union.anon = type { i64 }
%union.FPU = type { %struct.anon.13 }
%struct.anon.13 = type { %struct.FpuFXSAVE, [96 x i8] }
%struct.FpuFXSAVE = type { %union.SegmentSelector, %union.SegmentSelector, %union.FPUAbridgedTagWord, i8, i16, i32, %union.SegmentSelector, i16, i32, %union.SegmentSelector, i16, %union.FPUControlStatus, %union.FPUControlStatus, [8 x %struct.FPUStackElem], [16 x %union.vec128_t] }
%union.FPUAbridgedTagWord = type { i8 }
%union.FPUControlStatus = type { i32 }
%struct.FPUStackElem = type { %union.anon.11, [6 x i8] }
%union.anon.11 = type { %struct.float80_t }
%union.vec128_t = type { %struct.uint128v1_t }
%struct.uint128v1_t = type { [1 x i128] }
%struct.SegmentCaches = type { %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow, %struct.SegmentShadow }
%struct.SegmentShadow = type { %union.anon, i32, i32 }
%struct.Memory = type opaque

@__mcsema_reg_state = external thread_local(initialexec) global %struct.State
@RSP_2312_7f9a5b8 = external global i64
@OF_2077_7f9a570 = external global i8
@SF_2073_7f9a570 = external global i8
@ZF_2071_7f9a570 = external global i8
@AF_2069_7f9a570 = external global i8
@PF_2067_7f9a570 = external global i8
@CF_2065_7f9a570 = external global i8
@RDI_2296_7f9a5b8 = external global i64
@RBP_2328_7f9a5b8 = external global i64
@RCX_2248_7f9a5b8 = external global i64
@RAX_2216_7f9a5b8 = external global i64
@RSI_2280_7f9a5b8 = external global i64
@RDX_2264_7f9a5b8 = external global i64
@RBP_2328_7fa1bc0 = external global i64*

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare !remill.function.type !4 i32 @llvm.ctpop.i32(i32) #0

; Function Attrs: noinline
define hidden %struct.Memory* @sub_1189_quick_sort(%struct.State* noalias nonnull %state, i64 %pc, %struct.Memory* noalias %memory) #1 {
inst_1189:
  %0 = load i64, i64* @RBP_2328_7f9a5b8, align 8
  %1 = load i64, i64* @RSP_2312_7f9a5b8, align 8, !tbaa !5
  %2 = add i64 %1, -8
  %3 = inttoptr i64 %2 to i64*
  store i64 %0, i64* %3, align 8
  store i64 %2, i64* @RBP_2328_7f9a5b8, align 8, !tbaa !8
  %4 = sub i64 %2, 64
  store i64 %4, i64* @RSP_2312_7f9a5b8, align 8, !tbaa !8
  %5 = sub i64 %2, 40
  %6 = load i64, i64* @RDI_2296_7f9a5b8, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = sub i64 %2, 48
  %9 = load i64, i64* @RSI_2280_7f9a5b8, align 8
  %10 = inttoptr i64 %8 to i64*
  store i64 %9, i64* %10, align 8
  %11 = sub i64 %2, 56
  %12 = load i64, i64* @RDX_2264_7f9a5b8, align 8
  %13 = inttoptr i64 %11 to i64*
  store i64 %12, i64* %13, align 8
  br label %inst_1313

inst_130b:                                        ; preds = %inst_12f4, %inst_12ea
  %14 = phi %struct.Memory* [ %39, %inst_12ea ], [ %238, %inst_12f4 ]
  %15 = load i64, i64* @RBP_2328_7f9a5b8, align 8
  %16 = sub i64 %15, 8
  %17 = inttoptr i64 %16 to i64*
  %18 = load i64, i64* %17, align 8
  %19 = sub i64 %15, 56
  %20 = inttoptr i64 %19 to i64*
  store i64 %18, i64* %20, align 8
  br label %inst_1313

inst_1211:                                        ; preds = %inst_120c, %inst_11f0
  %21 = load i64, i64* %243, align 8
  %22 = mul i64 %21, 4
  %23 = load i64, i64* %254, align 8
  %24 = add i64 %22, %23
  %25 = inttoptr i64 %24 to i32*
  %26 = load i32, i32* %25, align 4
  %27 = load i32, i32* %260, align 4
  %28 = sub i32 %27, %26
  %29 = lshr i32 %28, 31
  %30 = trunc i32 %29 to i8
  %31 = lshr i32 %27, 31
  %32 = lshr i32 %26, 31
  %33 = xor i32 %31, %32
  %34 = xor i32 %29, %31
  %35 = add nuw nsw i32 %34, %33
  %36 = icmp eq i32 %35, 2
  %37 = icmp ne i8 %30, 0
  %38 = xor i1 %37, %36
  br i1 %38, label %inst_120c, label %inst_122b

inst_1313:                                        ; preds = %inst_12e0, %inst_130b, %inst_1189
  %39 = phi %struct.Memory* [ %memory, %inst_1189 ], [ %14, %inst_130b ], [ %89, %inst_12e0 ]
  %40 = load i64, i64* @RBP_2328_7f9a5b8, align 8
  %41 = sub i64 %40, 48
  %42 = inttoptr i64 %41 to i64*
  %43 = load i64, i64* %42, align 8
  store i64 %43, i64* @RAX_2216_7f9a5b8, align 8, !tbaa !8
  %44 = sub i64 %40, 56
  %45 = inttoptr i64 %44 to i64*
  %46 = load i64, i64* %45, align 8
  %47 = sub i64 %43, %46
  %48 = icmp ugt i64 %46, %43
  %49 = zext i1 %48 to i8
  store i8 %49, i8* @CF_2065_7f9a570, align 1, !tbaa !10
  %50 = trunc i64 %47 to i32
  %51 = and i32 %50, 255
  %52 = call i32 @llvm.ctpop.i32(i32 %51) #2, !range !24
  %53 = trunc i32 %52 to i8
  %54 = and i8 %53, 1
  %55 = xor i8 %54, 1
  store i8 %55, i8* @PF_2067_7f9a570, align 1, !tbaa !25
  %56 = xor i64 %46, %43
  %57 = xor i64 %56, %47
  %58 = lshr i64 %57, 4
  %59 = trunc i64 %58 to i8
  %60 = and i8 %59, 1
  store i8 %60, i8* @AF_2069_7f9a570, align 1, !tbaa !26
  %61 = icmp eq i64 %47, 0
  %62 = zext i1 %61 to i8
  store i8 %62, i8* @ZF_2071_7f9a570, align 1, !tbaa !27
  %63 = lshr i64 %47, 63
  %64 = trunc i64 %63 to i8
  store i8 %64, i8* @SF_2073_7f9a570, align 1, !tbaa !28
  %65 = lshr i64 %43, 63
  %66 = lshr i64 %46, 63
  %67 = xor i64 %66, %65
  %68 = xor i64 %63, %65
  %69 = add nuw nsw i64 %68, %67
  %70 = icmp eq i64 %69, 2
  %71 = zext i1 %70 to i8
  store i8 %71, i8* @OF_2077_7f9a570, align 1, !tbaa !29
  %72 = icmp ne i8 %64, 0
  %73 = xor i1 %72, %70
  br i1 %73, label %inst_11a6, label %inst_1321

inst_1299:                                        ; preds = %inst_1235, %inst_122b
  %74 = load i64, i64* %240, align 8
  %75 = load i64, i64* %243, align 8
  %76 = sub i64 %74, %75
  %77 = icmp eq i64 %76, 0
  %78 = lshr i64 %76, 63
  %79 = trunc i64 %78 to i8
  %80 = lshr i64 %74, 63
  %81 = lshr i64 %75, 63
  %82 = xor i64 %81, %80
  %83 = xor i64 %78, %80
  %84 = add nuw nsw i64 %83, %82
  %85 = icmp eq i64 %84, 2
  %86 = icmp ne i8 %79, 0
  %87 = xor i1 %86, %85
  %88 = or i1 %77, %87
  br i1 %88, label %inst_11f0, label %inst_12a7

inst_12e0:                                        ; preds = %inst_12c9, %inst_12bf
  %89 = phi %struct.Memory* [ %39, %inst_12bf ], [ %233, %inst_12c9 ]
  %90 = load i64, i64* @RBP_2328_7f9a5b8, align 8
  %91 = sub i64 %90, 16
  %92 = inttoptr i64 %91 to i64*
  %93 = load i64, i64* %92, align 8
  %94 = sub i64 %90, 48
  %95 = inttoptr i64 %94 to i64*
  store i64 %93, i64* %95, align 8
  br label %inst_1313

inst_11f0:                                        ; preds = %inst_11a6, %inst_11eb, %inst_1299
  %96 = load i64, i64* %240, align 8
  %97 = mul i64 %96, 4
  %98 = load i64, i64* %254, align 8
  %99 = add i64 %97, %98
  %100 = inttoptr i64 %99 to i32*
  %101 = load i32, i32* %100, align 4
  %102 = load i32, i32* %260, align 4
  %103 = sub i32 %102, %101
  %104 = icmp eq i32 %103, 0
  %105 = zext i1 %104 to i8
  %106 = lshr i32 %103, 31
  %107 = trunc i32 %106 to i8
  %108 = lshr i32 %102, 31
  %109 = lshr i32 %101, 31
  %110 = xor i32 %108, %109
  %111 = xor i32 %106, %108
  %112 = add nuw nsw i32 %111, %110
  %113 = icmp eq i32 %112, 2
  %114 = icmp eq i8 %105, 0
  %115 = icmp eq i8 %107, 0
  %116 = xor i1 %115, %113
  %117 = and i1 %114, %116
  br i1 %117, label %inst_11eb, label %inst_1211

inst_11eb:                                        ; preds = %inst_11f0
  %118 = add i64 %96, 1
  store i64 %118, i64* %240, align 8
  br label %inst_11f0

inst_120c:                                        ; preds = %inst_1211
  %119 = sub i64 %21, 1
  store i64 %119, i64* %243, align 8
  br label %inst_1211

inst_122b:                                        ; preds = %inst_1211
  %120 = load i64, i64* %240, align 8
  %121 = sub i64 %120, %21
  %122 = icmp eq i64 %121, 0
  %123 = zext i1 %122 to i8
  %124 = lshr i64 %121, 63
  %125 = trunc i64 %124 to i8
  %126 = lshr i64 %120, 63
  %127 = lshr i64 %21, 63
  %128 = xor i64 %127, %126
  %129 = xor i64 %124, %126
  %130 = add nuw nsw i64 %129, %128
  %131 = icmp eq i64 %130, 2
  %132 = icmp eq i8 %123, 0
  %133 = icmp eq i8 %125, 0
  %134 = xor i1 %133, %131
  %135 = and i1 %132, %134
  br i1 %135, label %inst_1299, label %inst_1235

inst_1235:                                        ; preds = %inst_122b
  %136 = mul i64 %120, 4
  %137 = add i64 %136, %23
  %138 = inttoptr i64 %137 to i32*
  %139 = load i32, i32* %138, align 4
  %140 = sub i64 %40, 20
  %141 = inttoptr i64 %140 to i32*
  store i32 %139, i32* %141, align 4
  %142 = load i64, i64* %243, align 8
  %143 = mul i64 %142, 4
  %144 = load i64, i64* %254, align 8
  %145 = add i64 %143, %144
  %146 = load i64, i64* %240, align 8
  %147 = mul i64 %146, 4
  store i64 %147, i64* @RCX_2248_7f9a5b8, align 8, !tbaa !8
  %148 = add i64 %147, %144
  %149 = inttoptr i64 %145 to i32*
  %150 = load i32, i32* %149, align 4
  %151 = inttoptr i64 %148 to i32*
  store i32 %150, i32* %151, align 4
  %152 = load i64, i64* %243, align 8
  %153 = mul i64 %152, 4
  %154 = load i64, i64* %254, align 8
  %155 = add i64 %154, %153
  %156 = load i32, i32* %141, align 4
  %157 = inttoptr i64 %155 to i32*
  store i32 %156, i32* %157, align 4
  %158 = load i64, i64* %240, align 8
  %159 = add i64 %158, 1
  store i64 %159, i64* %240, align 8
  %160 = load i64, i64* %243, align 8
  %161 = sub i64 %160, 1
  store i64 %161, i64* %243, align 8
  br label %inst_1299

inst_12a7:                                        ; preds = %inst_1299
  %162 = load i64, i64* %42, align 8
  %163 = sub i64 %75, %162
  %164 = lshr i64 %163, 63
  store i64 %163, i64* @RDX_2264_7f9a5b8, align 8, !tbaa !8
  %165 = load i64, i64* %45, align 8
  %166 = sub i64 %165, %74
  %167 = lshr i64 %166, 63
  %168 = sub i64 %163, %166
  %169 = lshr i64 %168, 63
  %170 = trunc i64 %169 to i8
  %171 = xor i64 %167, %164
  %172 = xor i64 %169, %164
  %173 = add nuw nsw i64 %172, %171
  %174 = icmp eq i64 %173, 2
  %175 = icmp eq i8 %170, 0
  %176 = xor i1 %175, %174
  br i1 %176, label %inst_12ea, label %inst_12bf

inst_12ea:                                        ; preds = %inst_12a7
  %177 = xor i64 %74, %165
  %178 = lshr i64 %165, 63
  %179 = xor i64 %80, %178
  %180 = sub i64 %74, %165
  %181 = icmp ugt i64 %165, %74
  %182 = zext i1 %181 to i8
  store i8 %182, i8* @CF_2065_7f9a570, align 1, !tbaa !10
  %183 = trunc i64 %180 to i32
  %184 = and i32 %183, 255
  %185 = call i32 @llvm.ctpop.i32(i32 %184) #2, !range !24
  %186 = trunc i32 %185 to i8
  %187 = and i8 %186, 1
  %188 = xor i8 %187, 1
  store i8 %188, i8* @PF_2067_7f9a570, align 1, !tbaa !25
  %189 = xor i64 %177, %180
  %190 = lshr i64 %189, 4
  %191 = trunc i64 %190 to i8
  %192 = and i8 %191, 1
  store i8 %192, i8* @AF_2069_7f9a570, align 1, !tbaa !26
  %193 = icmp eq i64 %180, 0
  %194 = zext i1 %193 to i8
  store i8 %194, i8* @ZF_2071_7f9a570, align 1, !tbaa !27
  %195 = lshr i64 %180, 63
  %196 = trunc i64 %195 to i8
  store i8 %196, i8* @SF_2073_7f9a570, align 1, !tbaa !28
  %197 = xor i64 %195, %80
  %198 = add nuw nsw i64 %197, %179
  %199 = icmp eq i64 %198, 2
  %200 = zext i1 %199 to i8
  store i8 %200, i8* @OF_2077_7f9a570, align 1, !tbaa !29
  %201 = icmp eq i8 %196, 0
  %202 = xor i1 %201, %199
  br i1 %202, label %inst_130b, label %inst_12f4

inst_12bf:                                        ; preds = %inst_12a7
  %203 = xor i64 %162, %75
  %204 = lshr i64 %162, 63
  %205 = xor i64 %204, %81
  %206 = sub i64 %162, %75
  %207 = icmp ugt i64 %75, %162
  %208 = zext i1 %207 to i8
  store i8 %208, i8* @CF_2065_7f9a570, align 1, !tbaa !10
  %209 = trunc i64 %206 to i32
  %210 = and i32 %209, 255
  %211 = call i32 @llvm.ctpop.i32(i32 %210) #2, !range !24
  %212 = trunc i32 %211 to i8
  %213 = and i8 %212, 1
  %214 = xor i8 %213, 1
  store i8 %214, i8* @PF_2067_7f9a570, align 1, !tbaa !25
  %215 = xor i64 %203, %206
  %216 = lshr i64 %215, 4
  %217 = trunc i64 %216 to i8
  %218 = and i8 %217, 1
  store i8 %218, i8* @AF_2069_7f9a570, align 1, !tbaa !26
  %219 = icmp eq i64 %206, 0
  %220 = zext i1 %219 to i8
  store i8 %220, i8* @ZF_2071_7f9a570, align 1, !tbaa !27
  %221 = lshr i64 %206, 63
  %222 = trunc i64 %221 to i8
  store i8 %222, i8* @SF_2073_7f9a570, align 1, !tbaa !28
  %223 = xor i64 %221, %204
  %224 = add nuw nsw i64 %223, %205
  %225 = icmp eq i64 %224, 2
  %226 = zext i1 %225 to i8
  store i8 %226, i8* @OF_2077_7f9a570, align 1, !tbaa !29
  %227 = icmp eq i8 %222, 0
  %228 = xor i1 %227, %225
  br i1 %228, label %inst_12e0, label %inst_12c9

inst_12c9:                                        ; preds = %inst_12bf
  store i64 %75, i64* @RDX_2264_7f9a5b8, align 8, !tbaa !8
  store i64 %162, i64* @RCX_2248_7f9a5b8, align 8, !tbaa !8
  %229 = load i64, i64* %254, align 8
  store i64 %229, i64* @RAX_2216_7f9a5b8, align 8, !tbaa !8
  store i64 %162, i64* @RSI_2280_7f9a5b8, align 8, !tbaa !8
  store i64 %229, i64* @RDI_2296_7f9a5b8, align 8, !tbaa !8
  %230 = load i64, i64* @RSP_2312_7f9a5b8, align 8, !tbaa !5
  %231 = add i64 %230, -8
  %232 = inttoptr i64 %231 to i64*
  store i64 undef, i64* %232, align 8
  store i64 %231, i64* @RSP_2312_7f9a5b8, align 8, !tbaa !8
  %233 = call %struct.Memory* @sub_1189_quick_sort(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %39)
  br label %inst_12e0

inst_12f4:                                        ; preds = %inst_12ea
  store i64 %165, i64* @RDX_2264_7f9a5b8, align 8, !tbaa !8
  store i64 %74, i64* @RCX_2248_7f9a5b8, align 8, !tbaa !8
  %234 = load i64, i64* %254, align 8
  store i64 %234, i64* @RAX_2216_7f9a5b8, align 8, !tbaa !8
  store i64 %74, i64* @RSI_2280_7f9a5b8, align 8, !tbaa !8
  store i64 %234, i64* @RDI_2296_7f9a5b8, align 8, !tbaa !8
  %235 = load i64, i64* @RSP_2312_7f9a5b8, align 8, !tbaa !5
  %236 = add i64 %235, -8
  %237 = inttoptr i64 %236 to i64*
  store i64 undef, i64* %237, align 8
  store i64 %236, i64* @RSP_2312_7f9a5b8, align 8, !tbaa !8
  %238 = call %struct.Memory* @sub_1189_quick_sort(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %39)
  br label %inst_130b

inst_11a6:                                        ; preds = %inst_1313
  %239 = sub i64 %40, 16
  %240 = inttoptr i64 %239 to i64*
  store i64 %43, i64* %240, align 8
  %241 = load i64, i64* %45, align 8
  %242 = sub i64 %40, 8
  %243 = inttoptr i64 %242 to i64*
  store i64 %241, i64* %243, align 8
  %244 = load i64, i64* %45, align 8
  %245 = load i64, i64* %42, align 8
  %246 = sub i64 %244, %245
  %247 = lshr i64 %246, 62
  %248 = lshr i64 %247, 1
  %249 = add i64 %248, %246
  %250 = ashr i64 %249, 1
  %251 = add i64 %250, %245
  %252 = mul i64 %251, 4
  %253 = sub i64 %40, 40
  %254 = inttoptr i64 %253 to i64*
  %255 = load i64, i64* %254, align 8
  %256 = add i64 %252, %255
  %257 = inttoptr i64 %256 to i32*
  %258 = load i32, i32* %257, align 4
  %259 = sub i64 %40, 24
  %260 = inttoptr i64 %259 to i32*
  store i32 %258, i32* %260, align 4
  br label %inst_11f0

inst_1321:                                        ; preds = %inst_1313
  %261 = load i64*, i64** @RBP_2328_7fa1bc0, align 8
  %262 = load i64, i64* %261, align 8
  store i64 %262, i64* @RBP_2328_7f9a5b8, align 8, !tbaa !8
  %263 = add i64 %40, 8
  %264 = add i64 %263, 8
  store i64 %264, i64* @RSP_2312_7f9a5b8, align 8, !tbaa !8
  ret %struct.Memory* %39
}

attributes #0 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #1 = { noinline "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }

!llvm.ident = !{!0, !0, !0}
!llvm.module.flags = !{!1, !2, !3}
!llvm.dbg.cu = !{}

!0 = !{!"clang version 9.0.1 (https://github.com/trailofbits/vcpkg.git 4592a93cc4ca82f1963dba08413c43639662d7ae)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 2, !"Dwarf Version", i32 4}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{!"base.helper.semantics"}
!5 = !{!6, !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C++ TBAA"}
!8 = !{!9, !9, i64 0}
!9 = !{!"long", !6, i64 0}
!10 = !{!11, !6, i64 2065}
!11 = !{!"_ZTS5State", !6, i64 16, !12, i64 2064, !6, i64 2080, !13, i64 2088, !15, i64 2112, !17, i64 2208, !18, i64 2480, !19, i64 2608, !20, i64 2736, !6, i64 2760, !6, i64 2768, !21, i64 3280}
!12 = !{!"_ZTS10ArithFlags", !6, i64 0, !6, i64 1, !6, i64 2, !6, i64 3, !6, i64 4, !6, i64 5, !6, i64 6, !6, i64 7, !6, i64 8, !6, i64 9, !6, i64 10, !6, i64 11, !6, i64 12, !6, i64 13, !6, i64 14, !6, i64 15}
!13 = !{!"_ZTS8Segments", !14, i64 0, !6, i64 2, !14, i64 4, !6, i64 6, !14, i64 8, !6, i64 10, !14, i64 12, !6, i64 14, !14, i64 16, !6, i64 18, !14, i64 20, !6, i64 22}
!14 = !{!"short", !6, i64 0}
!15 = !{!"_ZTS12AddressSpace", !9, i64 0, !16, i64 8, !9, i64 16, !16, i64 24, !9, i64 32, !16, i64 40, !9, i64 48, !16, i64 56, !9, i64 64, !16, i64 72, !9, i64 80, !16, i64 88}
!16 = !{!"_ZTS3Reg", !6, i64 0}
!17 = !{!"_ZTS3GPR", !9, i64 0, !16, i64 8, !9, i64 16, !16, i64 24, !9, i64 32, !16, i64 40, !9, i64 48, !16, i64 56, !9, i64 64, !16, i64 72, !9, i64 80, !16, i64 88, !9, i64 96, !16, i64 104, !9, i64 112, !16, i64 120, !9, i64 128, !16, i64 136, !9, i64 144, !16, i64 152, !9, i64 160, !16, i64 168, !9, i64 176, !16, i64 184, !9, i64 192, !16, i64 200, !9, i64 208, !16, i64 216, !9, i64 224, !16, i64 232, !9, i64 240, !16, i64 248, !9, i64 256, !16, i64 264}
!18 = !{!"_ZTS8X87Stack", !6, i64 0}
!19 = !{!"_ZTS3MMX", !6, i64 0}
!20 = !{!"_ZTS14FPUStatusFlags", !6, i64 0, !6, i64 1, !6, i64 2, !6, i64 3, !6, i64 4, !6, i64 5, !6, i64 6, !6, i64 7, !6, i64 8, !6, i64 9, !6, i64 10, !6, i64 11, !6, i64 12, !6, i64 13, !6, i64 14, !6, i64 15, !6, i64 16, !6, i64 17, !6, i64 18, !6, i64 19, !6, i64 20}
!21 = !{!"_ZTS13SegmentCaches", !22, i64 0, !22, i64 16, !22, i64 32, !22, i64 48, !22, i64 64, !22, i64 80}
!22 = !{!"_ZTS13SegmentShadow", !6, i64 0, !23, i64 8, !23, i64 12}
!23 = !{!"int", !6, i64 0}
!24 = !{i32 0, i32 9}
!25 = !{!11, !6, i64 2067}
!26 = !{!11, !6, i64 2069}
!27 = !{!11, !6, i64 2071}
!28 = !{!11, !6, i64 2073}
!29 = !{!11, !6, i64 2077}
