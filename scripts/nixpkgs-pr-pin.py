#!/usr/bin/env python3
"""
nixpkgs PR cherry-pick tool with lock file
"""

import json
import subprocess
import sys
from pathlib import Path
from typing import Dict, List, Optional
from datetime import datetime, timezone


LOCKFILE = "nixpkgs-pr-pins.json"
UPSTREAM_REPO = "NixOS/nixpkgs"


class PRPinTool:
    def __init__(self, lockfile: str = LOCKFILE):
        self.lockfile = Path(lockfile)

    def init_lockfile(self):
        """Initialize lock file if it doesn't exist"""
        if not self.lockfile.exists():
            self.lockfile.write_text(
                json.dumps({"version": "1.0", "pins": {}}, indent=2)
            )

    def load_lockfile(self) -> dict:
        """Load lock file"""
        if not self.lockfile.exists():
            self.init_lockfile()
        return json.loads(self.lockfile.read_text())

    def save_lockfile(self, data: dict):
        """Save lock file"""
        self.lockfile.write_text(json.dumps(data, indent=2))

    def run_cmd(
        self, cmd: List[str], check: bool = True
    ) -> subprocess.CompletedProcess:
        """Run shell command"""
        return subprocess.run(cmd, capture_output=True, text=True, check=check)

    def get_pr_info(self, pr_number: int) -> Optional[dict]:
        """Get PR commits and metadata"""
        print(f"Getting info for nixpkgs PR #{pr_number}...")

        try:
            # Get PR data from GitHub
            result = self.run_cmd(
                [
                    "gh",
                    "pr",
                    "view",
                    str(pr_number),
                    "--repo",
                    UPSTREAM_REPO,
                    "--json",
                    "number,baseRefName,headRefName,headRefOid,title,url,createdAt",
                ]
            )
            pr_data = json.loads(result.stdout)

            base_branch = pr_data["baseRefName"]
            head_sha = pr_data["headRefOid"]

            # Fetch the PR branch
            self.run_cmd(
                [
                    "git",
                    "fetch",
                    "origin",
                    f"pull/{pr_number}/head:pr-{pr_number}-temp",
                ],
                check=False,
            )

            # Get merge base
            result = self.run_cmd(
                ["git", "merge-base", f"origin/{base_branch}", f"pr-{pr_number}-temp"]
            )
            merge_base = result.stdout.strip()

            # Get commits
            result = self.run_cmd(
                [
                    "git",
                    "log",
                    "--reverse",
                    "--pretty=format:%H|||%s|||%an|||%ai",
                    f"{merge_base}..pr-{pr_number}-temp",
                ]
            )

            commits = []
            for line in result.stdout.strip().split("\n"):
                if line:
                    sha, msg, author, date = line.split("|||")
                    commits.append(
                        {"sha": sha, "message": msg, "author": author, "date": date}
                    )

            # Cleanup temp branch
            self.run_cmd(["git", "branch", "-D", f"pr-{pr_number}-temp"], check=False)

            return {
                "pr": str(pr_number),
                "base_branch": base_branch,
                "head_ref": pr_data["headRefName"],
                "head_sha": head_sha,
                "title": pr_data["title"],
                "url": pr_data["url"],
                "pinned_at": datetime.now(timezone.utc).isoformat(),
                "commits": commits,
            }

        except subprocess.CalledProcessError as e:
            print(f"Error getting PR #{pr_number}: {e.stderr}")
            return None

    def cmd_init(self):
        """Initialize empty lock file"""
        self.init_lockfile()
        print(f"Initialized {self.lockfile}")

    def cmd_add(self, pr_numbers: List[int]):
        """Add PR(s) to lock file"""
        data = self.load_lockfile()

        for pr_number in pr_numbers:
            print(f"=== Adding PR #{pr_number} ===")
            pin_data = self.get_pr_info(pr_number)

            if pin_data:
                data["pins"][str(pr_number)] = pin_data
                self.save_lockfile(data)
                print(f"Added PR #{pr_number} to {self.lockfile}")
            else:
                print(f"Failed to add PR #{pr_number}")
            print()

    def cmd_update(self):
        """Update all PRs in lock file"""
        data = self.load_lockfile()

        if not data["pins"]:
            print("No PRs in lock file")
            return

        for pr_number in list(data["pins"].keys()):
            print(f"=== Updating PR #{pr_number} ===")
            pin_data = self.get_pr_info(int(pr_number))

            if pin_data:
                data["pins"][pr_number] = pin_data
                self.save_lockfile(data)
                print(f"Updated PR #{pr_number}")
            else:
                print(f"Failed to update PR #{pr_number}")
            print()

    def cmd_apply(self, skip_on_conflict: bool = True):
        """Apply PRs from lock file"""
        data = self.load_lockfile()

        if not data["pins"]:
            print("No PRs in lock file")
            return

        pr_numbers = sorted([int(k) for k in data["pins"].keys()])
        failed_prs = []

        for pr_number in pr_numbers:
            print(f"=== Applying PR #{pr_number} ===")
            pin = data["pins"][str(pr_number)]

            print(f"Title: {pin['title']}")
            print("Commits:")
            for commit in pin["commits"]:
                print(f"  {commit['sha'][:7]} {commit['message']}")
            print()

            # Cherry-pick each commit with -x flag
            for commit in pin["commits"]:
                print(f"Cherry-picking {commit['sha'][:7]}")
                result = self.run_cmd(
                    ["git", "cherry-pick", "-x", commit["sha"]], check=False
                )

                if result.returncode != 0:
                    print(f"⚠️  Conflict in PR #{pr_number}, commit {commit['sha'][:7]}")

                    if skip_on_conflict:
                        print(f"Skipping rest of PR #{pr_number}")
                        self.run_cmd(["git", "cherry-pick", "--abort"], check=False)
                        failed_prs.append(pr_number)
                        break
                    else:
                        print("Resolve conflict and run: git cherry-pick --continue")
                        sys.exit(1)

            if pr_number not in failed_prs:
                print(f"✓ Applied PR #{pr_number}")
            print()

        if failed_prs:
            print("\n⚠️  Failed to apply PRs (conflicts):")
            for pr in failed_prs:
                print(f"  - PR #{pr}: {data['pins'][str(pr)]['title']}")

    def cmd_sync(
        self, base_branch: str = "nixos-unstable", skip_on_conflict: bool = True
    ):
        """Update base branch and reapply PRs"""
        print("=== Syncing nixpkgs base branch ===")

        # Get current branch
        result = self.run_cmd(["git", "symbolic-ref", "--short", "HEAD"])
        current_branch = result.stdout.strip()

        print(f"Current branch: {current_branch}")
        print(f"Base branch: {base_branch}")

        # Fetch latest
        print(f"Fetching origin/{base_branch}...")
        self.run_cmd(["git", "fetch", "origin", base_branch])

        # Rebase onto latest base
        print(f"Rebasing onto origin/{base_branch}...")
        result = self.run_cmd(["git", "rebase", f"origin/{base_branch}"], check=False)

        if result.returncode != 0:
            print("⚠️  Rebase failed. Resolve conflicts and run: git rebase --continue")
            sys.exit(1)

        print("\n=== Reapplying PRs ===")
        self.cmd_apply(skip_on_conflict=skip_on_conflict)

    def cmd_list(self):
        """List PRs in lock file"""
        data = self.load_lockfile()

        if not data["pins"]:
            print("No pinned PRs")
            return

        print("Pinned PRs:")
        for pr_number in sorted([int(k) for k in data["pins"].keys()]):
            pin = data["pins"][str(pr_number)]
            num_commits = len(pin["commits"])
            print(
                f"  {pr_number}: {pin['title']} ({num_commits} commits, pinned {pin['pinned_at']})"
            )


def main():
    if len(sys.argv) < 2:
        print("Usage: nixpkgs-pr-pin {init|add|update|apply|sync|list} [options]")
        print()
        print("Commands:")
        print("  init               Initialize empty lock file")
        print(
            "  add <PR>...        Pin nixpkgs PR(s) to lock file with current commits"
        )
        print("  update             Update all PRs in lock file to latest commits")
        print("  apply              Apply all PRs from lock file to current branch")
        print(
            "  sync [base]        Update base branch (default: nixos-unstable) and reapply PRs"
        )
        print("  list               List all PRs in lock file")
        sys.exit(1)

    tool = PRPinTool()
    command = sys.argv[1]

    if command == "init":
        tool.cmd_init()

    elif command == "add":
        if len(sys.argv) < 3:
            print("Usage: nixpkgs-pr-pin add <PR_NUMBER> [PR_NUMBER...]")
            sys.exit(1)
        pr_numbers = [int(x) for x in sys.argv[2:]]
        tool.cmd_add(pr_numbers)

    elif command == "update":
        tool.cmd_update()

    elif command == "apply":
        tool.cmd_apply()

    elif command == "sync":
        base_branch = sys.argv[2] if len(sys.argv) > 2 else "nixos-unstable"
        tool.cmd_sync(base_branch)

    elif command == "list":
        tool.cmd_list()

    else:
        print(f"Unknown command: {command}")
        sys.exit(1)


if __name__ == "__main__":
    main()
