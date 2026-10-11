data "external" "git" {
  program = ["python3", "${path.module}/../../scripts/git_metadata.py"]

  query = {
    repository_path = abspath(path.module)
  }
}
