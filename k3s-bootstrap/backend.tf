terraform {
  cloud {
    organization = "mkilchhofer"

    workspaces {
      name = "k3s-bootstrap"
    }
  }
}
