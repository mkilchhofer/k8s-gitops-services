# About

This repo contains various services for internal usage.

## Secrets management

In order to store everything in Git, I use Bitnamis Sealed Secrets concept: [github.com/bitnami-labs/sealed-secrets](https://github.com/bitnami-labs/sealed-secrets)

To encrypt a k8s secret use the following command:
```bash
$ kubeseal --cert https://sealed-secrets.k8s.kilchhofer.info/v1/cert.pem <mysecret.json >mysealedsecret.json
```
The encrypted `mysealedsecret.json` can only be decrypted by the Operator app in `kube-system`-namespace. Push this file to git to save everything in Git.
