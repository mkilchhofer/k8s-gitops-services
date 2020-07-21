# About

This repo contains various services for internal usage.

## Secrets management

In order to store everything in Git (Infrastructure as code), I use the 'Sealed Secrets' concept of  Bitnami Labs: [github.com/bitnami-labs/sealed-secrets](https://github.com/bitnami-labs/sealed-secrets)

To encrypt a k8s secret, use the utility `kubeseal` on the client side:
```bash
$ kubeseal --cert https://sealed-secrets.tools.kilchhofer.info/v1/cert.pem -o yaml <mysecret.json >mysealedsecret.yaml
```

> Problem: "I can manage all my K8s config in git, except Secrets."
>
> Solution: Encrypt your Secret into a SealedSecret, which is safe to store - even to a public repository. The SealedSecret can be decrypted only by the controller running in the target cluster and nobody else (not even the original author) is able to obtain the original Secret from the SealedSecret.

--> Also push the file `mysealedsecret.yaml` to Git.
