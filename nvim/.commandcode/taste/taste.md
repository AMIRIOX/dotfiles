# Taste

## Communication

- Writes in Chinese and expects Chinese-language replies. Confidence: 0.7

## Workflow

- Expects advice to be internally consistent and grounded in authoritative sources (official docs, upstream repo state) rather than rumor or secondhand claims; flags perceived contradictions between recommendations ("这怎么左右脑互博呢") and expects them reconciled into one clear position instead of being presented as an open A/B. Confidence: 0.7
- When they recall a guideline from somewhere but can't place it, asks for it to be fact-checked against primary sources before acting ("我似乎真的在哪见到过有说…确认一下这一点"), and will follow the verified conclusion ("如果确实是应该装就装吧") rather than being paralyzed by conflicting hearsay. Confidence: 0.6
- Expects project documentation (e.g. README) to stay accurate and be corrected whenever config/behavior changes — explicitly asks for stale docs to be fixed up (`README 都修正一下吧`) rather than left to drift, and approves cleaning up obsolete artifacts (e.g. backups) once they're confirmed unnecessary. Confidence: 0.55
- Expects claims to be empirically verified before being asserted — when told a problem exists, asks whether it was actually confirmed ("确认好问题真实存在吗?"), and pushes back on conclusions drawn from indirect/manual probes rather than real-world reproduction. Prefer rigorous, direct verification over inference. Confidence: 0.7
