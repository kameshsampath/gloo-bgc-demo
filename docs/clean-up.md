---
title: Envrionment Cleanup
summary: Delete the cloud and other resources.
authors:
  - Kamesh Sampath
date: 2021-10-02
---

At the end of this chapter you would have,

- [x] Delete the Cloud resources on Civo, AWS, GCP
- [x] Delete the Vagrant VM

## Ensure Environment

Navigate to Tutorial home

```bash
cd $TUTORIAL_HOME
```

Set cluster environment variables

---8<--- "includes/env.md"

## Cloud Clean up

```bash
make clean-up
```

## Destroy Vagrant VM

```bash
make vm-destroy
```
