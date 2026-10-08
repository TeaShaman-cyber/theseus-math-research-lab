"""Keep the first bounded mathematical discovery pass from becoming a perpetual umbrella."""
import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
CONTRACT = ROOT / "QA" / "campaigns" / "first-non-rh-pass-v0.json"


class BoundedDiscoveryCampaignTest(unittest.TestCase):
    def test_first_pass_has_an_exit_independent_of_new_seam_resolution(self):
        campaign = json.loads(CONTRACT.read_text(encoding="utf-8"))
        self.assertEqual(campaign["schema"], "theseus.math-bounded-campaign.v1")
        self.assertEqual(campaign["issue"], "TeaShaman-cyber/theseus-math-research-lab#18")
        self.assertEqual(campaign["scope"], "FIRST_NON_RH_ACCEPTED_CORPUS_PASS")
        self.assertEqual(
            set(campaign["terminal_outcomes"]),
            {"FOUND_CANDIDATE", "NO_SIGNAL", "STILL_CORPUS_BOUNDARY", "DEGRADED"},
        )
        self.assertEqual(
            campaign["exit_criteria"],
            [
                "bounded_pass_receipt_with_exact_source_tool_and_artifact",
                "outcome_and_unresolved_boundaries_recorded",
                "surviving_seams_handed_off_to_independent_issues_or_parked",
            ],
        )
        self.assertFalse(campaign["completion_requires_solving_seams"])
        self.assertFalse(campaign["completion_requires_children_closed"])
        self.assertFalse(campaign["scope_expansion_in_place"])
        self.assertEqual(
            campaign["independent_seam_example"],
            "TeaShaman-cyber/theseus-math-research-lab#56",
        )

    def test_repo_documents_boundaries_in_versioned_qa(self):
        guide = (ROOT / "README.md").read_text(encoding="utf-8")
        qa = (ROOT / "QA" / "README.md").read_text(encoding="utf-8")
        self.assertIn("QA/campaigns/first-non-rh-pass-v0.json", guide)
        self.assertIn("campaigns/first-non-rh-pass-v0.json", qa)


if __name__ == "__main__":
    unittest.main()
