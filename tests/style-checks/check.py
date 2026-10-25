"""Check layout-time failures, which tytanic's evaluation-time catch cannot test."""

from pathlib import Path
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parents[2]
OVERRIDES = {
    "list": "list.indent",
    "enum": "enum.indent",
    "heading": "heading.numbering",
    "figure": "figure.gap",
    "footnote": "footnote.entry.indent",
    "bibliography": "bibliography.style",
    "cite": "cite.style",
    "explicit-cite": "cite.style",
    "equation-above": "block.above",
    "equation-below": "block.below",
}


def compile_case(case, output, checks=True, sources=True):
    return subprocess.run(
        [
            "typst", "compile", "--root", str(ROOT),
            "--input", f"case={case}",
            "--input", f"checks={str(checks).lower()}",
            "--input", f"sources={str(sources).lower()}",
            str(Path(__file__).with_name("test.typ")), str(output),
        ],
        cwd=ROOT,
        capture_output=True,
        text=True,
        timeout=30,
    )


with tempfile.TemporaryDirectory(dir=ROOT) as directory:
    output = Path(directory) / "test.pdf"
    valid = compile_case("valid", output)
    assert valid.returncode == 0, valid.stderr
    for case, field in OVERRIDES.items():
        result = compile_case(case, output)
        assert result.returncode != 0, f"{case}: override was accepted"
        assert "does not allow changing these settings" in result.stderr, result.stderr
        assert f"`{field}`" in result.stderr, result.stderr
        unchecked = compile_case(case, output, checks=False)
        assert unchecked.returncode == 0, unchecked.stderr
    for case in ("manual-bibliography", "explicit-bibliography"):
        for checks in (True, False):
            for sources in (True, False):
                result = compile_case(case, output, checks=checks, sources=sources)
                assert result.returncode != 0, f"{case}: manual call was accepted"
                assert "do not call bibliography(...) manually" in result.stderr, result.stderr
                assert "iacrj bibliography option" in result.stderr, result.stderr

print(f"Style checks passed: valid document, {len(OVERRIDES)} style overrides, and manual bibliography calls.")
