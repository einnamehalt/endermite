https://docs.fedoraproject.org/en-US/fedora-coreos/producing-ign/

`podman pull quay.io/coreos/butane:release`

```bash
alias butane='podman run --rm --interactive       \
              --security-opt label=disable        \
              --volume ${PWD}:/pwd --workdir /pwd \
              quay.io/coreos/butane:release'
```

`butane --pretty --strict example.bu > example.ign
`
