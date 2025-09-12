#!/usr/bin/env python3
import json, math, tempfile, subprocess
from pathlib import Path
import networkx as nx
from networkx.drawing.nx_pydot import read_dot
from networkx.algorithms.similarity import graph_edit_distance

# ===== 여기만 프로젝트에 맞게 수정 =====
DIR_A = Path("../original/ll")        # 기준 폴더
DIR_B = Path("../llm_to_IR/chatGPT_api2/O0/repeat_5/1")         # 비교 대상 폴더
OUT_JSON = Path("./chatGPT_api2_1.json")
LLVMDIFF = "llvm-diff"
OPT = "opt"
RECURSIVE = False              # 하위 폴더까지 찾을지
GED_TIMEOUT = 3.0             # 그래프 편집 거리 timeout(초); None이면 무제한
TRUNCATE = 2000               # 로그 길이 제한 (문자 수)
# =====================================

def run(cmd, cwd=None):
    p = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
    return p.returncode, (p.stdout or "")[:TRUNCATE], (p.stderr or "")[:TRUNCATE]

def cosine_sim(v1, v2):
    a = v1[0]*v2[0] + v1[1]*v2[1]
    n1 = math.hypot(v1[0], v1[1])
    n2 = math.hypot(v2[0], v2[1])
    return 0.0 if n1 == 0 or n2 == 0 else a/(n1*n2)

def cfg_summary(ll_path: Path):
    with tempfile.TemporaryDirectory() as td:
        rc, so, se = run([OPT, "-disable-output", "-dot-cfg", str(ll_path)], cwd=td)
        # 수집
        dots = sorted(Path(td).glob("cfg.*.dot"))
        graphs = []
        total_nodes = 0
        total_edges = 0
        for d in dots:
            try:
                g = read_dot(str(d))
                # 단순화 (MultiGraph -> Graph)
                g = nx.Graph(g)
                graphs.append(g)
                total_nodes += g.number_of_nodes()
                total_edges += g.number_of_edges()
            except Exception:
                pass
        union = nx.disjoint_union_all(graphs) if graphs else nx.Graph()
        return {
            "functions": len(dots),
            "total_nodes": int(total_nodes),
            "total_edges": int(total_edges),
            "graph": union
        }

def find_ll(dirpath: Path):
    pattern = "**/*.ll" if RECURSIVE else "*.ll"
    files = {}
    for p in dirpath.glob(pattern):
        files[p.name] = p 
    return files

def main():
    a_map = find_ll(DIR_A)
    b_map = find_ll(DIR_B)
    common = sorted(set(a_map.keys()) & set(b_map.keys()))

    results = []
    for name in common:
        a = a_map[name]
        b = b_map[name]

        # 1) 텍스트 비교 (llvm-diff)
        rc, out, err = run([LLVMDIFF, str(a), str(b)])
        llvm_equal = (rc == 0)

        # 2) CFG 비교
        a_cfg = cfg_summary(a)
        b_cfg = cfg_summary(b)

        v1 = [a_cfg["total_nodes"], a_cfg["total_edges"]]
        v2 = [b_cfg["total_nodes"], b_cfg["total_edges"]]
        cos = cosine_sim(v1, v2)

        ged = graph_edit_distance(a_cfg["graph"], b_cfg["graph"], timeout=GED_TIMEOUT)
        ged_sim = (1.0 / (1.0 + ged)) if isinstance(ged, (int, float)) else None

        results.append({
            "name": name,
            "a_path": str(a),
            "b_path": str(b),
            "text": {
                "llvm_diff_equal": llvm_equal,
                "llvm_diff_rc": rc,
                "stdout": out,
                "stderr": err
            },
            "cfg": {
                "a": {"functions": a_cfg["functions"], "total_nodes": a_cfg["total_nodes"], "total_edges": a_cfg["total_edges"]},
                "b": {"functions": b_cfg["functions"], "total_nodes": b_cfg["total_nodes"], "total_edges": b_cfg["total_edges"]},
                "cosine_similarity": cos,
                "ged_similarity": ged_sim
            }
        })

    OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    with OUT_JSON.open("w", encoding="utf-8") as f:
        json.dump(results, f, ensure_ascii=False, indent=2)

if __name__ == "__main__":
    main()
