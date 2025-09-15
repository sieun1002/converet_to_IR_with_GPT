; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/mcsema/ll/O0/quicksort_function.ll'
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
  %4 = add i64 %1, -72
  store i64 %4, i64* @RSP_2312_7f9a5b8, align 8, !tbaa !8
  %5 = add i64 %1, -48
  %6 = load i64, i64* @RDI_2296_7f9a5b8, align 8
  %7 = inttoptr i64 %5 to i64*
  store i64 %6, i64* %7, align 8
  %8 = add i64 %1, -56
  %9 = load i64, i64* @RSI_2280_7f9a5b8, align 8
  %10 = inttoptr i64 %8 to i64*
  store i64 %9, i64* %10, align 8
  %11 = add i64 %1, -64
  %12 = load i64, i64* @RDX_2264_7f9a5b8, align 8
  %13 = inttoptr i64 %11 to i64*
  store i64 %12, i64* %13, align 8
  br label %inst_1313

inst_130b:                                        ; preds = %inst_12f4, %inst_12ea
  %14 = phi %struct.Memory* [ %38, %inst_12ea ], [ %220, %inst_12f4 ]
  %15 = load i64, i64* @RBP_2328_7f9a5b8, align 8
  %16 = add i64 %15, -8
  %17 = inttoptr i64 %16 to i64*
  %18 = load i64, i64* %17, align 8
  %19 = add i64 %15, -56
  %20 = inttoptr i64 %19 to i64*
  store i64 %18, i64* %20, align 8
  br label %inst_1313

inst_1211:                                        ; preds = %inst_11f0.inst_1211_crit_edge, %inst_120c
  %21 = phi i32 [ %93, %inst_11f0.inst_1211_crit_edge ], [ %.pre3, %inst_120c ]
  %22 = phi i64 [ %89, %inst_11f0.inst_1211_crit_edge ], [ %.pre2, %inst_120c ]
  %23 = phi i64 [ %.pre1, %inst_11f0.inst_1211_crit_edge ], [ %107, %inst_120c ]
  %24 = shl i64 %23, 2
  %25 = add i64 %24, %22
  %26 = inttoptr i64 %25 to i32*
  %27 = load i32, i32* %26, align 4
  %28 = sub i32 %21, %27
  %29 = lshr i32 %28, 31
  %30 = lshr i32 %21, 31
  %31 = lshr i32 %27, 31
  %32 = xor i32 %30, %31
  %33 = xor i32 %29, %30
  %34 = add nuw nsw i32 %33, %32
  %35 = icmp eq i32 %34, 2
  %36 = icmp slt i32 %28, 0
  %37 = xor i1 %36, %35
  br i1 %37, label %inst_120c, label %inst_122b

inst_1313:                                        ; preds = %inst_12e0, %inst_130b, %inst_1189
  %38 = phi %struct.Memory* [ %memory, %inst_1189 ], [ %14, %inst_130b ], [ %80, %inst_12e0 ]
  %39 = load i64, i64* @RBP_2328_7f9a5b8, align 8
  %40 = add i64 %39, -48
  %41 = inttoptr i64 %40 to i64*
  %42 = load i64, i64* %41, align 8
  store i64 %42, i64* @RAX_2216_7f9a5b8, align 8, !tbaa !8
  %43 = add i64 %39, -56
  %44 = inttoptr i64 %43 to i64*
  %45 = load i64, i64* %44, align 8
  %46 = sub i64 %42, %45
  %47 = icmp ult i64 %42, %45
  %48 = zext i1 %47 to i8
  store i8 %48, i8* @CF_2065_7f9a570, align 1, !tbaa !10
  %49 = trunc i64 %46 to i32
  %50 = and i32 %49, 255
  %51 = call i32 @llvm.ctpop.i32(i32 %50) #2, !range !24
  %52 = trunc i32 %51 to i8
  %53 = and i8 %52, 1
  %54 = xor i8 %53, 1
  store i8 %54, i8* @PF_2067_7f9a570, align 1, !tbaa !25
  %55 = xor i64 %45, %42
  %56 = xor i64 %55, %46
  %57 = trunc i64 %56 to i8
  %58 = lshr i8 %57, 4
  %59 = and i8 %58, 1
  store i8 %59, i8* @AF_2069_7f9a570, align 1, !tbaa !26
  %60 = icmp eq i64 %46, 0
  %61 = zext i1 %60 to i8
  store i8 %61, i8* @ZF_2071_7f9a570, align 1, !tbaa !27
  %62 = lshr i64 %46, 63
  %63 = trunc i64 %62 to i8
  store i8 %63, i8* @SF_2073_7f9a570, align 1, !tbaa !28
  %64 = lshr i64 %42, 63
  %65 = lshr i64 %45, 63
  %66 = xor i64 %65, %64
  %67 = xor i64 %62, %64
  %68 = add nuw nsw i64 %67, %66
  %69 = icmp eq i64 %68, 2
  %70 = zext i1 %69 to i8
  store i8 %70, i8* @OF_2077_7f9a570, align 1, !tbaa !29
  %71 = icmp slt i64 %46, 0
  %72 = xor i1 %71, %69
  br i1 %72, label %inst_11a6, label %inst_1321

inst_1299:                                        ; preds = %inst_1235, %inst_122b
  %.pre-phi17 = phi i64 [ %.pre16, %inst_1235 ], [ %116, %inst_122b ]
  %.pre-phi11 = phi i64 [ %.pre10, %inst_1235 ], [ %113, %inst_122b ]
  %.pre-phi9 = phi i64 [ %.pre8, %inst_1235 ], [ %112, %inst_122b ]
  %.pre-phi = phi i64 [ %.pre5, %inst_1235 ], [ %109, %inst_122b ]
  %73 = phi i64 [ %146, %inst_1235 ], [ %23, %inst_122b ]
  %74 = phi i64 [ %.pre4, %inst_1235 ], [ %108, %inst_122b ]
  %75 = icmp eq i64 %.pre-phi, 0
  %76 = icmp eq i64 %.pre-phi17, 2
  %77 = icmp slt i64 %.pre-phi, 0
  %78 = xor i1 %77, %76
  %79 = or i1 %75, %78
  br i1 %79, label %inst_11f0, label %inst_12a7

inst_12e0:                                        ; preds = %inst_12c9, %inst_12bf
  %80 = phi %struct.Memory* [ %38, %inst_12bf ], [ %216, %inst_12c9 ]
  %81 = load i64, i64* @RBP_2328_7f9a5b8, align 8
  %82 = add i64 %81, -16
  %83 = inttoptr i64 %82 to i64*
  %84 = load i64, i64* %83, align 8
  %85 = add i64 %81, -48
  %86 = inttoptr i64 %85 to i64*
  store i64 %84, i64* %86, align 8
  br label %inst_1313

inst_11f0:                                        ; preds = %inst_11a6, %inst_11eb, %inst_1299
  %87 = phi i64 [ %.pre, %inst_11a6 ], [ %106, %inst_11eb ], [ %74, %inst_1299 ]
  %88 = shl i64 %87, 2
  %89 = load i64, i64* %235, align 8
  %90 = add i64 %88, %89
  %91 = inttoptr i64 %90 to i32*
  %92 = load i32, i32* %91, align 4
  %93 = load i32, i32* %241, align 4
  %94 = sub i32 %93, %92
  %95 = icmp ne i32 %94, 0
  %96 = lshr i32 %94, 31
  %97 = lshr i32 %93, 31
  %98 = lshr i32 %92, 31
  %99 = xor i32 %97, %98
  %100 = xor i32 %96, %97
  %101 = add nuw nsw i32 %100, %99
  %102 = icmp eq i32 %101, 2
  %103 = icmp sgt i32 %94, -1
  %104 = xor i1 %103, %102
  %105 = and i1 %95, %104
  br i1 %105, label %inst_11eb, label %inst_11f0.inst_1211_crit_edge

inst_11f0.inst_1211_crit_edge:                    ; preds = %inst_11f0
  %.pre1 = load i64, i64* %225, align 8
  br label %inst_1211

inst_11eb:                                        ; preds = %inst_11f0
  %106 = add i64 %87, 1
  store i64 %106, i64* %222, align 8
  br label %inst_11f0

inst_120c:                                        ; preds = %inst_1211
  %107 = add i64 %23, -1
  store i64 %107, i64* %225, align 8
  %.pre2 = load i64, i64* %235, align 8
  %.pre3 = load i32, i32* %241, align 4
  br label %inst_1211

inst_122b:                                        ; preds = %inst_1211
  %108 = load i64, i64* %222, align 8
  %109 = sub i64 %108, %23
  %110 = icmp ne i64 %109, 0
  %111 = lshr i64 %109, 63
  %112 = lshr i64 %108, 63
  %113 = lshr i64 %23, 63
  %114 = xor i64 %113, %112
  %115 = xor i64 %111, %112
  %116 = add nuw nsw i64 %115, %114
  %117 = icmp eq i64 %116, 2
  %118 = icmp sgt i64 %109, -1
  %119 = xor i1 %118, %117
  %120 = and i1 %110, %119
  br i1 %120, label %inst_1299, label %inst_1235

inst_1235:                                        ; preds = %inst_122b
  %121 = shl i64 %108, 2
  %122 = add i64 %121, %22
  %123 = inttoptr i64 %122 to i32*
  %124 = load i32, i32* %123, align 4
  %125 = add i64 %39, -20
  %126 = inttoptr i64 %125 to i32*
  store i32 %124, i32* %126, align 4
  %127 = load i64, i64* %225, align 8
  %128 = shl i64 %127, 2
  %129 = load i64, i64* %235, align 8
  %130 = add i64 %128, %129
  %131 = load i64, i64* %222, align 8
  %132 = shl i64 %131, 2
  store i64 %132, i64* @RCX_2248_7f9a5b8, align 8, !tbaa !8
  %133 = add i64 %132, %129
  %134 = inttoptr i64 %130 to i32*
  %135 = load i32, i32* %134, align 4
  %136 = inttoptr i64 %133 to i32*
  store i32 %135, i32* %136, align 4
  %137 = load i64, i64* %225, align 8
  %138 = shl i64 %137, 2
  %139 = load i64, i64* %235, align 8
  %140 = add i64 %139, %138
  %141 = load i32, i32* %126, align 4
  %142 = inttoptr i64 %140 to i32*
  store i32 %141, i32* %142, align 4
  %143 = load i64, i64* %222, align 8
  %144 = add i64 %143, 1
  store i64 %144, i64* %222, align 8
  %145 = load i64, i64* %225, align 8
  %146 = add i64 %145, -1
  store i64 %146, i64* %225, align 8
  %.pre4 = load i64, i64* %222, align 8
  %.pre5 = sub i64 %.pre4, %146
  %.pre6 = lshr i64 %.pre5, 63
  %.pre8 = lshr i64 %.pre4, 63
  %.pre10 = lshr i64 %146, 63
  %.pre12 = xor i64 %.pre10, %.pre8
  %.pre14 = xor i64 %.pre6, %.pre8
  %.pre16 = add nuw nsw i64 %.pre14, %.pre12
  br label %inst_1299

inst_12a7:                                        ; preds = %inst_1299
  %147 = load i64, i64* %41, align 8
  %148 = sub i64 %73, %147
  %149 = lshr i64 %148, 63
  store i64 %148, i64* @RDX_2264_7f9a5b8, align 8, !tbaa !8
  %150 = load i64, i64* %44, align 8
  %151 = sub i64 %150, %74
  %152 = lshr i64 %151, 63
  %153 = sub i64 %148, %151
  %154 = lshr i64 %153, 63
  %155 = xor i64 %152, %149
  %156 = xor i64 %154, %149
  %157 = add nuw nsw i64 %156, %155
  %158 = icmp eq i64 %157, 2
  %159 = icmp sgt i64 %153, -1
  %160 = xor i1 %159, %158
  br i1 %160, label %inst_12ea, label %inst_12bf

inst_12ea:                                        ; preds = %inst_12a7
  %161 = xor i64 %74, %150
  %162 = lshr i64 %150, 63
  %163 = xor i64 %.pre-phi9, %162
  %164 = sub i64 %74, %150
  %165 = icmp ugt i64 %150, %74
  %166 = zext i1 %165 to i8
  store i8 %166, i8* @CF_2065_7f9a570, align 1, !tbaa !10
  %167 = trunc i64 %164 to i32
  %168 = and i32 %167, 255
  %169 = call i32 @llvm.ctpop.i32(i32 %168) #2, !range !24
  %170 = trunc i32 %169 to i8
  %171 = and i8 %170, 1
  %172 = xor i8 %171, 1
  store i8 %172, i8* @PF_2067_7f9a570, align 1, !tbaa !25
  %173 = xor i64 %161, %164
  %174 = trunc i64 %173 to i8
  %175 = lshr i8 %174, 4
  %176 = and i8 %175, 1
  store i8 %176, i8* @AF_2069_7f9a570, align 1, !tbaa !26
  %177 = icmp eq i64 %164, 0
  %178 = zext i1 %177 to i8
  store i8 %178, i8* @ZF_2071_7f9a570, align 1, !tbaa !27
  %179 = lshr i64 %164, 63
  %180 = trunc i64 %179 to i8
  store i8 %180, i8* @SF_2073_7f9a570, align 1, !tbaa !28
  %181 = xor i64 %179, %.pre-phi9
  %182 = add nuw nsw i64 %181, %163
  %183 = icmp eq i64 %182, 2
  %184 = zext i1 %183 to i8
  store i8 %184, i8* @OF_2077_7f9a570, align 1, !tbaa !29
  %185 = icmp sgt i64 %164, -1
  %186 = xor i1 %185, %183
  br i1 %186, label %inst_130b, label %inst_12f4

inst_12bf:                                        ; preds = %inst_12a7
  %187 = xor i64 %147, %73
  %188 = lshr i64 %147, 63
  %189 = xor i64 %188, %.pre-phi11
  %190 = sub i64 %147, %73
  %191 = icmp ugt i64 %73, %147
  %192 = zext i1 %191 to i8
  store i8 %192, i8* @CF_2065_7f9a570, align 1, !tbaa !10
  %193 = trunc i64 %190 to i32
  %194 = and i32 %193, 255
  %195 = call i32 @llvm.ctpop.i32(i32 %194) #2, !range !24
  %196 = trunc i32 %195 to i8
  %197 = and i8 %196, 1
  %198 = xor i8 %197, 1
  store i8 %198, i8* @PF_2067_7f9a570, align 1, !tbaa !25
  %199 = xor i64 %187, %190
  %200 = trunc i64 %199 to i8
  %201 = lshr i8 %200, 4
  %202 = and i8 %201, 1
  store i8 %202, i8* @AF_2069_7f9a570, align 1, !tbaa !26
  %203 = icmp eq i64 %190, 0
  %204 = zext i1 %203 to i8
  store i8 %204, i8* @ZF_2071_7f9a570, align 1, !tbaa !27
  %205 = lshr i64 %190, 63
  %206 = trunc i64 %205 to i8
  store i8 %206, i8* @SF_2073_7f9a570, align 1, !tbaa !28
  %207 = xor i64 %205, %188
  %208 = add nuw nsw i64 %207, %189
  %209 = icmp eq i64 %208, 2
  %210 = zext i1 %209 to i8
  store i8 %210, i8* @OF_2077_7f9a570, align 1, !tbaa !29
  %211 = icmp sgt i64 %190, -1
  %212 = xor i1 %211, %209
  br i1 %212, label %inst_12e0, label %inst_12c9

inst_12c9:                                        ; preds = %inst_12bf
  store i64 %73, i64* @RDX_2264_7f9a5b8, align 8, !tbaa !8
  store i64 %147, i64* @RCX_2248_7f9a5b8, align 8, !tbaa !8
  %213 = load i64, i64* %235, align 8
  store i64 %213, i64* @RAX_2216_7f9a5b8, align 8, !tbaa !8
  store i64 %147, i64* @RSI_2280_7f9a5b8, align 8, !tbaa !8
  store i64 %213, i64* @RDI_2296_7f9a5b8, align 8, !tbaa !8
  %214 = load i64, i64* @RSP_2312_7f9a5b8, align 8, !tbaa !5
  %215 = add i64 %214, -8
  store i64 %215, i64* @RSP_2312_7f9a5b8, align 8, !tbaa !8
  %216 = call %struct.Memory* @sub_1189_quick_sort(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %38)
  br label %inst_12e0

inst_12f4:                                        ; preds = %inst_12ea
  store i64 %150, i64* @RDX_2264_7f9a5b8, align 8, !tbaa !8
  store i64 %74, i64* @RCX_2248_7f9a5b8, align 8, !tbaa !8
  %217 = load i64, i64* %235, align 8
  store i64 %217, i64* @RAX_2216_7f9a5b8, align 8, !tbaa !8
  store i64 %74, i64* @RSI_2280_7f9a5b8, align 8, !tbaa !8
  store i64 %217, i64* @RDI_2296_7f9a5b8, align 8, !tbaa !8
  %218 = load i64, i64* @RSP_2312_7f9a5b8, align 8, !tbaa !5
  %219 = add i64 %218, -8
  store i64 %219, i64* @RSP_2312_7f9a5b8, align 8, !tbaa !8
  %220 = call %struct.Memory* @sub_1189_quick_sort(%struct.State* @__mcsema_reg_state, i64 undef, %struct.Memory* %38)
  br label %inst_130b

inst_11a6:                                        ; preds = %inst_1313
  %221 = add i64 %39, -16
  %222 = inttoptr i64 %221 to i64*
  store i64 %42, i64* %222, align 8
  %223 = load i64, i64* %44, align 8
  %224 = add i64 %39, -8
  %225 = inttoptr i64 %224 to i64*
  store i64 %223, i64* %225, align 8
  %226 = load i64, i64* %44, align 8
  %227 = load i64, i64* %41, align 8
  %228 = sub i64 %226, %227
  %229 = lshr i64 %228, 63
  %230 = add i64 %229, %228
  %231 = lshr i64 %230, 1
  %232 = add i64 %231, %227
  %233 = shl i64 %232, 2
  %234 = add i64 %39, -40
  %235 = inttoptr i64 %234 to i64*
  %236 = load i64, i64* %235, align 8
  %237 = add i64 %233, %236
  %238 = inttoptr i64 %237 to i32*
  %239 = load i32, i32* %238, align 4
  %240 = add i64 %39, -24
  %241 = inttoptr i64 %240 to i32*
  store i32 %239, i32* %241, align 4
  %.pre = load i64, i64* %222, align 8
  br label %inst_11f0

inst_1321:                                        ; preds = %inst_1313
  %242 = load i64*, i64** @RBP_2328_7fa1bc0, align 8
  %243 = load i64, i64* %242, align 8
  store i64 %243, i64* @RBP_2328_7f9a5b8, align 8, !tbaa !8
  %244 = add i64 %39, 16
  store i64 %244, i64* @RSP_2312_7f9a5b8, align 8, !tbaa !8
  ret %struct.Memory* %38
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
