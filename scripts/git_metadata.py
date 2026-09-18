"""Return the checkout's HEAD as a Terraform external data source result."""

import json
import subprocess
import sys


def main():
    query = json.load(sys.stdin)
    result = subprocess.run(
        ["git", "-C", query["repository_path"], "rev-parse", "--verify", "HEAD^{commit}"],
        capture_output=True,
        text=True,
        check=True,
    )
    json.dump({"commit_hash": result.stdout.strip()}, sys.stdout)


if __name__ == "__main__":
    try:
        main()
    except (KeyError, ValueError, OSError, subprocess.CalledProcessError) as error:
        print(f"Cannot read Git HEAD: {error}", file=sys.stderr)
        sys.exit(1)
