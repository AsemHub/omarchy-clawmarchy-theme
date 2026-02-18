# Phase 3: Color System Traceability - Context

**Gathered:** 2026-02-18
**Status:** Ready for planning

<domain>
## Phase Boundary

Audit and document every hardcoded hex value across all theme config files, mapping each to its colors.toml source key. Establish the boundary between Omarchy-generated and static override files. Publish results as a reference document accessible to users and contributors. This phase does NOT modify color values or create new variants — it documents what exists.

</domain>

<decisions>
## Implementation Decisions

### Annotation style
- Inline comments next to each hex value in the actual config file
- Comment format is Claude's discretion — pick the clearest approach per file format
- Which color value formats to annotate (hex only vs rgba etc.) is Claude's discretion
- For files that don't support native comments (JSON), use `_comment` or `//` keys within the JSON where the format allows it (established pattern from 02-03 VS Code work)

### Reference document structure
- Lives in repo root (e.g., `COLORS.md`) — visible to users and contributors
- Organization approach is Claude's discretion — pick what's most useful for maintainers
- Must prominently flag which files need manual updates when accent color changes — clear callout per static file, not buried as metadata

### File classification criteria
- Classification granularity (binary vs three-tier) is Claude's discretion based on what the codebase actually shows
- Classification surfaced in BOTH places: header comment in each file AND listed in the reference document
- Whether to annotate generated files is Claude's discretion — based on whether it adds value per file
- Header comment format/wording is Claude's discretion — balance consistency with format-appropriateness

### Unmapped color handling
- Hex values that don't map directly to a colors.toml key should be flagged as unmapped — clearly marked so they're visible during future audits
- Whether to also propose new colors.toml keys for unmapped values is Claude's discretion
- Whether some hardcoded values are intentional (e.g., pure black, urgency colors) vs accidentally untracked is Claude's discretion to determine
- Audit scope (this repo only vs template engine context) is Claude's discretion — scope based on what's useful for theme maintainers

### Claude's Discretion
- Inline comment format per file type
- Which color value formats warrant annotation
- Reference document organization (by component, by role, or hybrid)
- File classification granularity
- Whether generated files get annotations
- Header comment format standardization
- Proposal of new colors.toml keys for unmapped values
- Distinguishing intentional hardcoded values from accidental ones
- Audit scope relative to Omarchy's template engine

</decisions>

<specifics>
## Specific Ideas

- The `_comment` field pattern for JSON files is already established from Phase 2 (02-03 VS Code work) — use that as precedent
- The reference doc should serve as a practical "what do I need to update when changing accent color?" guide, not just an academic audit
- Mako border-size, Hyprlock overlay, and VS Code colorCustomizations are known static overrides from Phase 2 decisions

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 03-color-system-traceability*
*Context gathered: 2026-02-18*
