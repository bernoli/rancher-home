Still figuring out module dependency and/or working with 0.13 beta. In the meantime

```
tf init ; tf plan ; tf apply -auto-approve ; tf destroy -auto-approve -target=module.flux; tf destroy -auto-approve
```